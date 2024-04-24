// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "./utils/resources/MainnetAddresses.sol";
import "contracts/connectors/MaverickConnector.sol";

import "@openzeppelin/contracts-5.0/token/ERC721/IERC721.sol";

contract TestMavericConnector is testStarter, MainnetAddresses {
    MaverickConnector connector;

    function setUp() public {
        console.log("----------- Initialization -----------");
        // --------------------------------- set env --------------------------------
        uint256 fork = vm.createFork(RPC_URL, 19_637_572);
        vm.selectFork(fork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);

        deployEverythingNormal(USDC);

        connector = new MaverickConnector(
            MAV,
            veMAV,
            mavericRouter,
            mavericPositionInspector,
            BaseConnectorCP(registry, vaultId, swapHandler, noyaOracle)
        );

        console.log("MaverickConnector deployed: %s", address(connector));
        addConnectorToRegistry(vaultId, address(connector));

        // ------------------- addTokensToSupplyOrBorrow -------------------
        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTrustedTokens(vaultId, address(accountingManager), DAI);
        addTrustedTokens(vaultId, address(accountingManager), GHO);
        addTrustedTokens(vaultId, address(accountingManager), MAV);
        addTrustedTokens(vaultId, address(accountingManager), veMAV);
        addTrustedTokens(vaultId, address(accountingManager), WETH);
        addTrustedTokens(vaultId, address(accountingManager), WSTETH);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(GHO), address(840), address(GHO_USD_FEED));
        addTokenToNoyaOracle(address(GHO), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(WSTETH), address(840), address(STETH_USD_FEED));
        addTokenToNoyaOracle(address(WSTETH), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(WETH), address(840), address(WETH_USD_FEED));
        addTokenToNoyaOracle(address(WETH), address(chainlinkOracle));

        addRoutesToNoyaOracle(address(GHO), address(USDC), address(840));
        addRoutesToNoyaOracle(address(DAI), address(USDC), address(840));

        address[] memory route = new address[](1);
        route[0] = address(840);
        noyaOracle.updatePriceRoute(WETH, USDC, route);
        noyaOracle.updatePriceRoute(WSTETH, USDC, route);

        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(GHO), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(MAV), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(veMAV), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(WETH), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(WSTETH), "");
        registry.addTrustedPosition(
            0, connector.MAVERICK_LP(), address(connector), true, false, abi.encode(mavericUSDC_GHO_pool), ""
        );
        registry.addTrustedPosition(
            0, connector.MAVERICK_LP(), address(connector), true, false, abi.encode(mavericWETH_WSTETH_pool), ""
        );
    }

    function test_depositFlow() public {
        console.log("-----------Maverick Deposit Flow--------------");
        uint256 _amountUSDC = 85e6;
        uint256 _amountGHO = 85e18;
        _dealWhale(USDC, address(connector), USDC_Whale, 2 * _amountUSDC);
        _dealERC20(GHO, address(connector), 2 * _amountGHO);

        vm.startPrank(owner);

        AddLiquidityParams[] memory params = new AddLiquidityParams[](1);
        params[0] = AddLiquidityParams({
            kind: 0,
            pos: 100,
            isDelta: false,
            deltaA: uint128(_amountGHO),
            deltaB: uint128(_amountUSDC)
        });

        connector.addLiquidityInMaverickPool(
            MavericAddLiquidityParams({
                ethPoolIncluded: false,
                pool: IMaverickPool(mavericUSDC_GHO_pool),
                params: params,
                minTokenAAmount: 0,
                minTokenBAmount: 0,
                tokenARequiredAllowance: _amountGHO,
                tokenBRequiredAllowance: _amountUSDC,
                deadline: block.timestamp + 2 days
            })
        );

        vm.warp(block.timestamp + 2 days);

        // connector.claimBoostedPositionRewards(IMaverickReward(address(0x6C9eaa92A7612c98a57d01cCEB921821650523dF)));
        IERC721(address(0x4A3e49f77a2A5b60682a2D6B8899C7c5211EB646)).balanceOf(address(connector));
        uint256 _tvl = accountingManager.TVL();
        console.log("TVL %s", _tvl);

        assertTrue(isCloseTo(_tvl, 340e6, 100), "testDepositFlow: E1");
        RemoveLiquidityParams[] memory removeParams = new RemoveLiquidityParams[](1);
        removeParams[0] = RemoveLiquidityParams(17, 85_000_000_000_000_000_000);
        connector.removeLiquidityFromMaverickPool(
            MavericRemoveLiquidityParams(
                IMaverickPool(mavericUSDC_GHO_pool), 2879, removeParams, 0, 0, block.timestamp + 1
            )
        ); // Covered coverage bug number 62
        vm.stopPrank();
    }

    function test_depositBoostedPosition() public {
        console.log("-----------Maverick Deposit Flow--------------");
        uint256 _amountWETH = 85e18;
        uint256 _amountWSTETH = 85e18;

        _dealERC20(WETH, address(connector), 2 * _amountWETH);
        _dealERC20(WSTETH, address(connector), 2 * _amountWSTETH);

        vm.startPrank(owner);

        AddLiquidityParams[] memory params = new AddLiquidityParams[](1);
        params[0] = AddLiquidityParams({
            kind: 0,
            pos: 100,
            isDelta: false,
            deltaA: uint128(_amountWETH),
            deltaB: uint128(_amountWSTETH)
        });

        connector.addLiquidityInMaverickPool(
            MavericAddLiquidityParams({
                ethPoolIncluded: false,
                pool: IMaverickPool(mavericWETH_WSTETH_pool),
                params: params,
                minTokenAAmount: 0,
                minTokenBAmount: 0,
                tokenARequiredAllowance: _amountWETH,
                tokenBRequiredAllowance: _amountWSTETH,
                deadline: block.timestamp + 10 days
            })
        );

        uint256 _tvl = accountingManager.TVL();
        console.log("TVL %s", _tvl);

        // vm.warp(block.timestamp + 2 days);

        connector.claimBoostedPositionRewards(IMaverickReward(address(0xbF1FB3F9aF0B243d75561349833991BE2561172B)));
        // IERC721(address(0x4A3e49f77a2A5b60682a2D6B8899C7c5211EB646)).balanceOf(address(connector));

        // assertTrue(isCloseTo(_tvl, 340e6, 100), "testDepositFlow: E1");
        // RemoveLiquidityParams[] memory removeParams = new RemoveLiquidityParams[](1);
        // removeParams[0] = RemoveLiquidityParams(17, 85_000_000_000_000_000_000);
        // connector.removeLiquidityFromMaverickPool(IMaverickPool(mavericUSDC_GHO_pool), 2846, removeParams, 0, 0);
        // vm.stopPrank();
    }

    function testVeMavDeposit() public {
        console.log("-----------VeMav Deposit Flow--------------");
        uint256 _amount = 100e18;
        _dealERC20(MAV, address(connector), _amount);
        vm.startPrank(owner);
        connector.stake(_amount, 10 days, false);
        vm.expectRevert();
        connector.unstake(0);

        vm.warp(block.timestamp + 10 days);

        connector.unstake(0);
        vm.stopPrank();
    }
}
