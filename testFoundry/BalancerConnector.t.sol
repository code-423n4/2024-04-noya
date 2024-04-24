// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "./utils/resources/MainnetAddresses.sol";

import "contracts/connectors/BalancerConnector.sol";

contract TestBalancerConnector is testStarter, MainnetAddresses {
    BalancerConnector connector;

    function setUp() public {
        console.log("----------- Initialization -----------");
        // --------------------------------- set env ---------------------------------
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);
        deployEverythingNormal(USDC);

        connector =
            new BalancerConnector(balancerVault, BAL, AURA, BaseConnectorCP(registry, vaultId, swapHandler, noyaOracle));
        console.log("BalancerConnector deployed: %s", address(connector));

        addConnectorToRegistry(vaultId, address(connector));
        // --------------------------------- set trusted tokens ---------------------------------

        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTrustedTokens(vaultId, address(accountingManager), DAI);
        addTrustedTokens(vaultId, address(accountingManager), USDT);
        addTrustedTokens(vaultId, address(accountingManager), WETH);
        addTrustedTokens(vaultId, address(accountingManager), WSTETH);

        // --------------------------------- init NoyaValueOracle ---------------------------------

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(USDT), address(840), address(USDT_USD_FEED));
        addTokenToNoyaOracle(address(USDT), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(CRVUSD), address(840), address(CRVUSD_USD_FEED));
        addTokenToNoyaOracle(address(CRVUSD), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(WSTETH), address(840), address(STETH_USD_FEED));
        addTokenToNoyaOracle(address(WSTETH), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(WETH), address(840), address(WETH_USD_FEED));
        addTokenToNoyaOracle(address(WETH), address(chainlinkOracle));

        address[] memory route = new address[](1);
        route[0] = address(840);
        noyaOracle.updatePriceRoute(WETH, USDC, route);
        noyaOracle.updatePriceRoute(WSTETH, USDC, route);

        // --------------------------------- init ChainlinkchainlinkOracle ---------------------------------
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(USDT), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(WETH), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(WSTETH), "");
        address[] memory tokens = new address[](3);
        tokens[0] = address(DAI);
        tokens[1] = address(USDC);
        tokens[2] = address(USDT);
        uint256[] memory weights = new uint256[](3);
        weights[0] = uint256(333_333_333_333_333_333);
        weights[1] = uint256(333_333_333_333_333_333);
        weights[2] = uint256(333_333_333_333_333_333);
        registry.addTrustedPosition(
            0,
            connector.BALANCER_LP_POSITION(),
            address(connector),
            false,
            false,
            abi.encode(vanillaUsdcDaiUsdtId),
            abi.encode(
                PoolInfo({
                    pool: vanillaUsdcDaiUsdt,
                    tokens: tokens,
                    tokenIndex: 2,
                    poolId: vanillaUsdcDaiUsdtId,
                    weights: weights,
                    auraPoolAddress: address(0),
                    boosterPoolId: 0
                })
            )
        );
        vm.stopPrank();
    }

    function testVaultDepositFlow() public {
        console.log("-----------Base Workflow--------------");
        uint256 _amount = 10_000 * 1e6;
        _dealWhale(baseToken, address(connector), USDC_Whale, 3 * _amount);

        uint256 _tvl1 = accountingManager.TVL();
        console.log("TVL_1 %s", _tvl1);

        vm.startPrank(address(owner));

        // --------------------------------- add pools  ---------------------------------

        uint256[] memory amounts = new uint256[](4);
        amounts[2] = 1000 * 1e6;

        uint256[] memory amountsW = new uint256[](3);
        amountsW[1] = 1000 * 1e6;

        connector.openPosition(vanillaUsdcDaiUsdtId, amounts, amountsW, 0, 0); // Cover coverage bug number 64

        uint256 balance = connector.totalLpBalanceOf(vanillaUsdcDaiUsdtId); // Cover coverage bug number 68
        console.log("Balance %s", balance);
        connector.decreasePosition(DecreasePositionParams(vanillaUsdcDaiUsdtId, 0, 0, 0, 0, 0)); // Cover coverage bug number 66
        connector.decreasePosition(DecreasePositionParams(vanillaUsdcDaiUsdtId, balance / 2, 0, 0, 0, 0)); // Cover coverage bug number 67
        connector.decreasePosition(
            DecreasePositionParams(vanillaUsdcDaiUsdtId, connector.totalLpBalanceOf(vanillaUsdcDaiUsdtId), 0, 0, 0, 0)
        ); // Cover coverage bug number 65 , 66, 67

        vm.stopPrank();
    }

    function testDepositIntoWETH_WSTETHPool() public {
        uint256 _amount = 10e18;
        _dealERC20(WETH, address(connector), _amount);
        _dealERC20(WSTETH, address(connector), 3 * _amount);

        vm.startPrank(owner);

        address[] memory tokens = new address[](2);
        tokens[0] = address(WETH);
        tokens[1] = address(WSTETH);
        uint256[] memory weights = new uint256[](2);
        weights[0] = uint256(1e18 / 2);
        weights[1] = uint256(1e18 / 2);
        registry.addTrustedPosition(
            0,
            connector.BALANCER_LP_POSITION(),
            address(connector),
            false,
            false,
            abi.encode(wstETH_wETH_BPT_id),
            abi.encode(
                PoolInfo({
                    pool: wstETH_wETH_BPT,
                    tokens: tokens,
                    tokenIndex: 0,
                    poolId: wstETH_wETH_BPT_id,
                    weights: weights,
                    auraPoolAddress: wsETH_wETH_Aura,
                    boosterPoolId: 153
                })
            )
        );

        uint256[] memory amounts = new uint256[](3);
        amounts[0] = _amount;
        // amounts[2] = _amount;

        uint256[] memory amountsW = new uint256[](2);
        amountsW[0] = _amount;
        // amountsW[1] = _amount;

        connector.openPosition(wstETH_wETH_BPT_id, amounts, amountsW, 0, 10); // Cover coverage bug number 64

        IERC20(wsETH_wETH_Aura).balanceOf(address(connector));

        uint256 tvl = accountingManager.TVL(); // Cover coverage bug number 68

        connector.openPosition(wstETH_wETH_BPT_id, amounts, amountsW, 0, 0); // Cover coverage bug number 64

        uint256 bptBalance = IERC20(wstETH_wETH_BPT).balanceOf(address(connector));

        tvl = accountingManager.TVL();
        console.log("TVL %s", tvl);
        // assertTrue(tvl > 0, "testDepositIntoWETH_WSTETHPool: E0");

        connector.depositIntoAuraBooster(wstETH_wETH_BPT_id, bptBalance);

        connector.openPosition(wstETH_wETH_BPT_id, amounts, amountsW, 0, 0);

        bptBalance = IERC20(wstETH_wETH_BPT).balanceOf(address(connector));

        address[] memory auraRewards = new address[](1);
        auraRewards[0] = wsETH_wETH_Aura;
        connector.harvestAuraRewards(auraRewards);

        console.log("Aura rewards %s", IERC20(wsETH_wETH_Aura).balanceOf(address(connector)));

        connector.decreasePosition(
            DecreasePositionParams(
                wstETH_wETH_BPT_id, 0, 0, 0, 0, IERC20(wsETH_wETH_Aura).balanceOf(address(connector)) / 2
            )
        ); // Cover coverage bug number 65

        //     vm.stopPrank();
    }
}
