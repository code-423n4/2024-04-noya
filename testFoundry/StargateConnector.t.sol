// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "contracts/connectors/StargateConnector.sol";

import "./utils/resources/MainnetAddresses.sol";

contract TestStargateConnector is testStarter, MainnetAddresses {
    StargateConnector connector;

    address stargateRouter = 0x8731d54E9D02c286767d56ac03e8037C07e01e98;
    address LPStakingTime = 0x1c3000b8f475A958b87c73a5cc5780Ab763122FC;
    address LPStaking = 0xB0D502E938ed5f4df2E681fE6E419ff29631d62b;
    uint256 poolId = 3;

    function setUp() public {
        console.log("----------- Initialization -----------");
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);
        deployEverythingNormal(USDC);

        connector = new StargateConnector(
            LPStaking, stargateRouter, BaseConnectorCP(registry, vaultId, swapHandler, noyaOracle)
        );
        console.log("StargateConnector deployed: %s", address(connector));

        addConnectorToRegistry(vaultId, address(connector));

        addTrustedTokens(vaultId, address(accountingManager), USDC);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));

        addTrustedTokens(vaultId, address(accountingManager), DAI);

        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));

        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        addRoutesToNoyaOracle(address(DAI), address(USDC), address(840));

        console.log("Tokens added to registry");

        registry.addTrustedPosition(
            vaultId, connector.STARGATE_LP_POSITION_TYPE(), address(connector), true, false, abi.encode(poolId), ""
        );
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        IStargateLPStaking staking = IStargateLPStaking(LPStaking);

        addTrustedTokens(vaultId, address(accountingManager), staking.stargate());

        registry.addTrustedPosition(
            vaultId, 0, address(accountingManager), false, false, abi.encode(staking.stargate()), ""
        );

        console.log("Positions added to registry");
    }

    function testStargateDeposit() public {
        console.log("-----------Stargate Deposit Flow--------------");
        uint256 _amountDAI = 100e18;
        _dealERC20(DAI, address(connector), _amountDAI);
        vm.startPrank(owner);
        uint256 positionTVL = connector._getPositionTVL(
            HoldingPI(
                address(connector),
                address(connector),
                registry.calculatePositionId(
                    address(connector), connector.STARGATE_LP_POSITION_TYPE(), abi.encode(poolId)
                ),
                "",
                "",
                block.timestamp
            ),
            USDC
        );
        console.log("positionTVL: %s", positionTVL);

        connector.depositIntoStargatePool(StargateRequest(3, 0, 0)); //  Covered coverage bug number 39, 40

        connector.depositIntoStargatePool(StargateRequest(3, _amountDAI, 0)); //  Covered coverage bug number 39

        positionTVL = connector._getPositionTVL(
            HoldingPI(
                address(connector),
                address(connector),
                registry.calculatePositionId(
                    address(connector), connector.STARGATE_LP_POSITION_TYPE(), abi.encode(poolId)
                ),
                "",
                "",
                block.timestamp
            ),
            USDC
        );
        assertTrue(isCloseTo(positionTVL, 100e6, 100));

        uint256 tvl = accountingManager.TVL();
        console.log("TVL: %s", tvl);
        assertTrue(isCloseTo(tvl, 100e6, 100));
        vm.stopPrank();
    }

    function testWithdraw() public {
        console.log("-----------Stargate Withdraw Flow--------------");
        uint256 _amountUSDC = 85e6;
        uint256 _amountDAI = 100e18;
        _dealERC20(DAI, address(connector), _amountDAI);
        vm.startPrank(owner);
        connector.depositIntoStargatePool(StargateRequest(poolId, _amountDAI, 0));

        uint256 tvl = accountingManager.TVL();
        console.log("TVL: %s", tvl);
        assertTrue(isCloseTo(tvl, 100e6, 100));

        IStargateLPStaking staking = IStargateLPStaking(LPStaking);
        IERC20 pool = IERC20(staking.poolInfo(poolId).lpToken);
        connector.withdrawFromStargatePool(StargateRequest(poolId, 1, 0)); //  Covered coverage bug number 43, 44
        uint256 lpBalance = pool.balanceOf(address(connector));
        connector.withdrawFromStargatePool(StargateRequest(poolId, lpBalance, 0));
        tvl = accountingManager.TVL();
        console.log("TVL: %s", tvl);
        assertTrue(isCloseTo(tvl, 100e6, 100));
        vm.stopPrank();
    }

    function testStakeAndWithdrawFromStake() public {
        uint256 _amountDAI = 100e18;
        _dealERC20(DAI, address(connector), 2 * _amountDAI);
        vm.startPrank(owner);

        connector.depositIntoStargatePool(StargateRequest(3, _amountDAI, 0));

        IStargateLPStaking staking = IStargateLPStaking(LPStaking);
        IERC20 pool = IERC20(staking.poolInfo(poolId).lpToken);
        uint256 lpBalance = pool.balanceOf(address(connector));
        console.log("lpBalance: %s", lpBalance);
        connector.depositIntoStargatePool(StargateRequest(3, 0, lpBalance)); //  Covered coverage bug number 40 , 41
        vm.roll(block.number + 100);
        uint256 rewardBalanceBefore = IERC20(staking.stargate()).balanceOf(address(connector));
        connector.depositIntoStargatePool(StargateRequest(3, _amountDAI, 1));
        connector.depositIntoStargatePool(StargateRequest(3, 0, type(uint256).max)); //  Covered coverage bug number 41

        uint256 rewardBalanceAfter = IERC20(staking.stargate()).balanceOf(address(connector));
        console.log("rewardBalance update: %s", rewardBalanceAfter - rewardBalanceBefore);
        assertTrue(rewardBalanceAfter > rewardBalanceBefore);

        vm.roll(block.number + 100);
        rewardBalanceBefore = rewardBalanceAfter;
        connector.claimStargateRewards(poolId);
        rewardBalanceAfter = IERC20(staking.stargate()).balanceOf(address(connector));
        assertTrue(rewardBalanceAfter > rewardBalanceBefore);
        console.log("rewardBalance claim: %s", rewardBalanceAfter - rewardBalanceBefore);

        uint256 lpBalanceInStaking = staking.userInfo(poolId, address(connector)).amount;
        console.log("lpBalanceInStaking: %s", lpBalanceInStaking);
        connector.withdrawFromStargatePool(StargateRequest(poolId, 0, lpBalanceInStaking / 2)); //  Covered coverage bug number 42
        connector.withdrawFromStargatePool(StargateRequest(poolId, lpBalanceInStaking, lpBalanceInStaking / 2)); //  Covered coverage bug number 42, 43
        vm.stopPrank();
    }
}
