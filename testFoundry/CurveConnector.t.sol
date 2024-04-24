// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "contracts/connectors/CurveConnector.sol";

import "./utils/resources/MainnetAddresses.sol";

contract TestCurveConnector is testStarter, MainnetAddresses {
    CurveConnector connector;

    function setUp() public {
        console.log("----------- Initialization -----------");
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);
        deployEverythingNormal(USDC);

        connector = new CurveConnector(
            convexCurveMainnetBooster, CVX, CRV, prisma, BaseConnectorCP(registry, vaultId, swapHandler, noyaOracle)
        );
        console.log("CurveConnector deployed: %s", address(connector));

        addConnectorToRegistry(vaultId, address(connector));

        addTrustedTokens(vaultId, address(accountingManager), MKUSD);
        addTrustedTokens(vaultId, address(accountingManager), CRVUSD);
        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTrustedTokens(vaultId, address(accountingManager), DAI);
        addTrustedTokens(vaultId, address(accountingManager), USDT);
        addTrustedTokens(vaultId, address(accountingManager), SUSD);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(USDT), address(840), address(USDT_USD_FEED));
        addTokenToNoyaOracle(address(USDT), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(CRVUSD), address(840), address(CRVUSD_USD_FEED));
        addTokenToNoyaOracle(address(CRVUSD), address(chainlinkOracle));

        addRoutesToNoyaOracle(address(DAI), address(USDC), address(840));
        addRoutesToNoyaOracle(address(CRVUSD), address(USDC), address(840));
        addRoutesToNoyaOracle(address(USDT), address(USDC), address(840));

        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(USDT), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(MKUSD), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(CRVUSD), "");

        address[] memory tokens = new address[](3);
        tokens[0] = address(DAI);
        tokens[1] = address(USDC);
        tokens[2] = address(USDT);

        PoolInfo memory poolInfo = PoolInfo(
            TriCryptoPool,
            3,
            TriCrypto_LP,
            TriCrypto_Gauge,
            convexTriCryptoLPToken,
            convexTriCryptoRewardBooster,
            address(0),
            address(0),
            tokens,
            address(0),
            1,
            address(0)
        );
        registry.addTrustedPosition(
            0,
            connector.CURVE_LP_POSITION(),
            address(connector),
            false,
            false,
            abi.encode(TriCryptoPool),
            abi.encode(poolInfo)
        );

        address[] memory tokens2 = new address[](2);
        tokens2[0] = address(MKUSD);
        tokens2[1] = address(CRVUSD);

        PoolInfo memory poolInfo2 = PoolInfo(
            MKUSD_CRVUSD_pool,
            2,
            MKUSD_CRVUSD_pool,
            MKUSD_CRVUSD_Gauge,
            convexMKUSD_CRVUSD_RewardBooster,
            convexMKUSD_CRVUSD_LPToken,
            MKUSD_CRVUSD_prismaConvexPool,
            MKUSD_CRVUSD_prismaCurvePool,
            tokens2,
            address(0),
            1,
            address(0)
        );
        registry.addTrustedPosition(
            0,
            connector.CURVE_LP_POSITION(),
            address(connector),
            true,
            false,
            abi.encode(MKUSD_CRVUSD_pool),
            abi.encode(poolInfo2)
        );

        address[] memory tokens5 = new address[](2);
        tokens2[0] = address(FRAX);
        tokens2[1] = address(USDT);

        PoolInfo memory poolInfo5 = PoolInfo(
            frax3CrvPool,
            2,
            address(0),
            address(0),
            address(0),
            address(0),
            address(0),
            address(0),
            tokens5,
            address(0),
            1,
            TriCryptoPool
        );
        registry.addTrustedPosition(
            0,
            connector.CURVE_LP_POSITION(),
            address(connector),
            true,
            false,
            abi.encode(frax3CrvPool),
            abi.encode(poolInfo5)
        );

        address[] memory tokens3 = new address[](4);
        tokens3[0] = address(DAI);
        tokens3[1] = address(USDC);
        tokens3[2] = address(USDT);
        tokens3[3] = address(SUSD);

        PoolInfo memory poolInfo3 = PoolInfo(
            SUSD_pool,
            4,
            SUSD_LP,
            address(0),
            address(0),
            address(0),
            address(0),
            address(0),
            tokens3,
            address(0),
            1,
            address(0)
        );
        registry.addTrustedPosition(
            0,
            connector.CURVE_LP_POSITION(),
            address(connector),
            true,
            false,
            abi.encode(SUSD_pool),
            abi.encode(poolInfo3)
        );
        console.log("CurveConnector deployed: %s", address(connector));
    }

    function test_normalCurveDeposit() public {
        uint256 _amount = 100_000_000;

        _dealWhale(baseToken, address(connector), USDC_Whale, 3 * _amount);

        vm.startPrank(address(owner));

        connector.openCurvePosition(TriCryptoPool, 1, 3 * _amount, 0);

        uint256 _tvl = accountingManager.TVL();

        assertTrue(isCloseTo(_tvl, 3 * _amount, 100), "test_normalCurveDeposit: E1");

        connector.decreaseCurvePosition(TriCryptoPool, 1, 2 * _amount, 0);

        connector.decreaseCurvePosition(TriCryptoPool, 1, _amount, 0);

        _tvl = accountingManager.TVL();

        assertTrue(isCloseTo(_tvl, 3 * _amount, 100), "test_normalCurveDeposit: E1");

        uint256 totalBalance = IERC20(TriCrypto_LP).balanceOf(address(connector));
        connector.decreaseCurvePosition(TriCryptoPool, 1, totalBalance, 0); // Cover coverage bug number 24

        vm.stopPrank();
    }

    function test_CurveGaugeDeposit() public {
        uint256 _amount = 100_000_000;

        _dealWhale(baseToken, address(connector), USDC_Whale, 3 * _amount);

        vm.startPrank(address(owner));

        connector.openCurvePosition(TriCryptoPool, 1, 3 * _amount, 0);
        uint256 lpBalance = IERC20(TriCrypto_LP).balanceOf(address(connector));

        connector.depositIntoGauge(TriCryptoPool, lpBalance);

        address[] memory gauges = new address[](1);
        gauges[0] = SteCRV;
        connector.harvestRewards(gauges);

        assertEq(IERC20(TriCrypto_Gauge).balanceOf(address(connector)), lpBalance);
        uint256 _tvl = accountingManager.TVL();

        assertTrue(isCloseTo(_tvl, 3 * _amount, 100), "test_normalCurveDeposit: E1");

        connector.withdrawFromGauge(address(TriCrypto_Gauge), lpBalance);

        vm.stopPrank();
    }

    function test_CurveConvex() public {
        uint256 _amount = 100_000_000;

        _dealWhale(baseToken, address(connector), USDC_Whale, 4 * _amount);

        vm.startPrank(address(owner));

        connector.openCurvePosition(TriCryptoPool, 1, 3 * _amount, 0);
        uint256 lpBalance = IERC20(TriCrypto_LP).balanceOf(address(connector));

        connector.depositIntoConvexBooster(TriCryptoPool, 9, lpBalance / 2, false);
        connector.depositIntoConvexBooster(TriCryptoPool, 9, lpBalance / 2, true);
        address[] memory tokens = new address[](1);
        tokens[0] = convexTriCryptoRewardBooster;

        connector.harvestConvexRewards(tokens);
        uint256 convexBalance = IERC20(convexTriCryptoLPToken).balanceOf(address(connector));
        console.log("Convex balance: %s", convexBalance);
        connector.withdrawFromConvexBooster(9, convexBalance);

        uint256 rewardPoolBalance = IERC20(convexTriCryptoRewardBooster).balanceOf(address(connector));
        connector.withdrawFromConvexRewardPool(address(convexTriCryptoRewardBooster), rewardPoolBalance);

        vm.stopPrank();
    }

    function test_Prisma() public {
        uint256 _amount = 100e18;

        _dealERC20(address(CRVUSD), address(connector), 3 * _amount);

        vm.startPrank(address(owner));

        connector.openCurvePosition(address(0x3de254A0f838a844F727fee81040e0FA7884B935), 1, 3 * _amount, 0);
        uint256 lpBalance = IERC20(0x3de254A0f838a844F727fee81040e0FA7884B935).balanceOf(address(connector));

        uint256 tvl = accountingManager.TVL();
        console.log("TVL: %s", tvl);

        assertTrue(isCloseTo(tvl, noyaOracle.getValue(CRVUSD, USDC, 3 * _amount), 100), "test_Prisma: E1");

        connector.depositIntoPrisma(address(0x3de254A0f838a844F727fee81040e0FA7884B935), lpBalance / 2, false);

        connector.depositIntoPrisma(address(0x3de254A0f838a844F727fee81040e0FA7884B935), lpBalance / 2, true);

        uint256 prismaBalance = IERC20(MKUSD_CRVUSD_prismaCurvePool).balanceOf(address(connector));
        console.log("Prisma balance: %s", prismaBalance);
        uint256 prismaConvexBalance = IERC20(MKUSD_CRVUSD_prismaConvexPool).balanceOf(address(connector));
        console.log("Prisma Convex balance: %s", prismaConvexBalance);
        connector.withdrawFromPrisma(MKUSD_CRVUSD_prismaCurvePool, prismaBalance);

        tvl = accountingManager.TVL();
        console.log("TVL: %s", tvl);

        assertTrue(isCloseTo(tvl, noyaOracle.getValue(CRVUSD, USDC, 3 * _amount), 100), "test_Prisma: E2");
        address[] memory depositToken = new address[](1);
        depositToken[0] = MKUSD_CRVUSD_prismaCurvePool;

        connector.harvestPrismaRewards(depositToken);
    }

    function testGetters() public {
        address[] memory poolTokens = new address[](2);
        poolTokens[0] = address(FRAX);
        poolTokens[1] = address(TriCryptoPool);
        PoolInfo memory poolInfo5 = PoolInfo(
            frax3CrvPool,
            2,
            address(0),
            address(0),
            address(0),
            address(0),
            address(0),
            address(0),
            poolTokens,
            address(0),
            1,
            TriCryptoPool
        );

        connector.LPToUnder(poolInfo5, 10e18);
        connector.LPToUnder(poolInfo5, 0);

        connector.balanceOfConvexRewardPool(poolInfo5);
        connector.balanceOfRewardPool(poolInfo5);
    }
}
