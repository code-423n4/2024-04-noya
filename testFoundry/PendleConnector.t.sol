// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "./utils/testStarter.sol";
import "./utils/resources/MainnetAddresses.sol";

import "contracts/connectors/PendleConnector.sol";

contract TestPendleConnector is testStarter, MainnetAddresses {
    PendleConnector connector;
    uint256 public startingBlock1 = 19_312_332;

    function setUp() public {
        console.log("----------- Initialization -----------");
        // --------------------------------- set env --------------------------------
        uint256 fork = vm.createFork(RPC_URL);
        vm.selectFork(fork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);

        deployEverythingNormal(USDC);

        // --------------------------------- init connector ---------------------------------
        connector = new PendleConnector(
            pendleMarketDepositHelper,
            pendleRouter,
            pendleStaticRouter,
            BaseConnectorCP(registry, vaultId, swapHandler, noyaOracle)
        );

        console.log("PendleConnector deployed: %s", address(connector));
        addConnectorToRegistry(vaultId, address(connector));

        // ------------------- addTokensToSupplyOrBorrow -------------------
        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTrustedTokens(vaultId, address(accountingManager), DAI);
        addTrustedTokens(vaultId, address(accountingManager), GHO);
        addTrustedTokens(vaultId, address(accountingManager), USDT);
        addTrustedTokens(vaultId, address(accountingManager), STG);
        addTrustedTokens(vaultId, address(accountingManager), PENDLE);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(USDT), address(840), address(USDT_USD_FEED));
        addTokenToNoyaOracle(address(USDT), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(GHO), address(840), address(GHO_USD_FEED));
        addTokenToNoyaOracle(address(GHO), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(STG), address(840), address(STG_USD_FEED));
        addTokenToNoyaOracle(address(STG), address(chainlinkOracle));

        addRoutesToNoyaOracle(address(STG), address(USDC), address(840));
        addRoutesToNoyaOracle(address(GHO), address(USDC), address(840));
        addRoutesToNoyaOracle(address(DAI), address(USDC), address(840));
        addRoutesToNoyaOracle(address(USDT), address(USDC), address(840));

        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(GHO), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(USDT), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(STG), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(PENDLE), "");
        registry.addTrustedPosition(0, 12, address(connector), true, false, abi.encode(pendleUsdtMarket), "");
        registry.addTrustedPosition(
            0, connector.PENDLE_POSITION_ID(), address(connector), true, false, abi.encode(pendleUsdtMarket), ""
        );
    }

    function testDeposit() public {
        uint256 amount = 1000;

        _dealERC20(USDT, address(connector), amount);
        vm.startPrank(owner);

        uint256 tvl_before = connector.getPositionTVL( //  Covered coverage bug number 29.3
            HoldingPI({
                calculatorConnector: address(connector),
                positionId: registry.calculatePositionId(
                    address(connector), connector.PENDLE_POSITION_ID(), abi.encode(pendleUsdtMarket)
                    ),
                ownerConnector: address(connector),
                data: "",
                additionalData: "",
                positionTimestamp: 0
            }),
            address(USDC)
        );
        assertEq(tvl_before, 0);

        (IPStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT) = IPMarket(pendleUsdtMarket).readTokens();

        connector.supply(pendleUsdtMarket, amount);
        uint256 syBalance = _SY.balanceOf(address(connector));

        connector.mintPTAndYT(pendleUsdtMarket, syBalance);

        uint256 PTBalance = _PT.balanceOf(address(connector));
        uint256 YTBalance = _YT.balanceOf(address(connector));
        console.log("syBalance: %s", syBalance);
        console.log("PTBalance: %s", PTBalance);
        console.log("YTBalance: %s", YTBalance);

        assertTrue(isCloseTo(PTBalance, syBalance, 100));
        assertTrue(isCloseTo(YTBalance, syBalance, 100));

        uint256 tvl = accountingManager.TVL();
        assertTrue(isCloseTo(tvl, amount, 100));

        connector.getPositionTVL( //  Covered coverage bug number 29.2
            HoldingPI({
                calculatorConnector: address(connector),
                positionId: registry.calculatePositionId(address(connector), 12, abi.encode(pendleUsdtMarket)),
                ownerConnector: address(connector),
                data: "",
                additionalData: "",
                positionTimestamp: 0
            }),
            address(USDC)
        );

        vm.stopPrank();
    }

    function testDepositAndWithdraw() public {
        uint256 amount = 1000;

        _dealERC20(USDT, address(connector), amount);
        vm.startPrank(owner);

        (IPStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT) = IPMarket(pendleUsdtMarket).readTokens();

        connector.supply(pendleUsdtMarket, amount);
        uint256 syBalance = _SY.balanceOf(address(connector));
        connector.decreasePosition(IPMarket(pendleUsdtMarket), syBalance / 4, true); //  Covered coverage bug number 29
        connector.decreasePosition(IPMarket(pendleUsdtMarket), syBalance / 4, false);
        syBalance = _SY.balanceOf(address(connector));
        connector.decreasePosition(IPMarket(pendleUsdtMarket), syBalance, true);

        vm.stopPrank();
    }

    function testSwapYTToPT() public {
        uint256 amount = 1000;

        _dealERC20(USDT, address(connector), amount);
        vm.startPrank(owner);

        (IPStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT) = IPMarket(pendleUsdtMarket).readTokens();

        connector.supply(pendleUsdtMarket, amount);
        uint256 syBalance = _SY.balanceOf(address(connector));

        connector.mintPTAndYT(pendleUsdtMarket, syBalance);

        uint256 PTBalance = _PT.balanceOf(address(connector));
        uint256 YTBalance = _YT.balanceOf(address(connector));

        connector.swapYTForPT(
            pendleUsdtMarket,
            YTBalance,
            0,
            ApproxParams({ guessOffchain: 1000, guessMin: 0, guessMax: 0, maxIteration: 8, eps: 1e18 })
        );

        uint256 PTBalanceAfter = _PT.balanceOf(address(connector));
        assertTrue(PTBalanceAfter > PTBalance);

        vm.stopPrank();
    }

    function testSwapYTToSY() public {
        uint256 amount = 1000;

        _dealERC20(USDT, address(connector), amount);
        vm.startPrank(owner);

        (IPStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT) = IPMarket(pendleUsdtMarket).readTokens();

        connector.supply(pendleUsdtMarket, amount);
        uint256 syBalance = _SY.balanceOf(address(connector));

        connector.mintPTAndYT(pendleUsdtMarket, syBalance);

        uint256 PTBalance = _PT.balanceOf(address(connector));
        uint256 YTBalance = _YT.balanceOf(address(connector));
        syBalance = _SY.balanceOf(address(connector));
        connector.swapYTForSY(
            pendleUsdtMarket,
            YTBalance,
            0,
            LimitOrderData(
                address(pendleStaticRouter),
                0, // only used for swap operations, will be ignored otherwise
                new FillOrderParams[](0),
                new FillOrderParams[](0),
                ""
            )
        );

        uint256 syBalanceAfter = _SY.balanceOf(address(connector));
        assertTrue(syBalanceAfter > syBalance);

        vm.stopPrank();
    }

    function testDepositIntoMarket() public {
        uint256 amount = 10_000;

        _dealERC20(USDT, address(connector), amount);
        vm.startPrank(owner);

        (IPStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT) = IPMarket(pendleUsdtMarket).readTokens();

        connector.supply(pendleUsdtMarket, amount);
        uint256 syBalance = _SY.balanceOf(address(connector));

        vm.roll(block.number + 20);
        vm.warp(block.timestamp + 1 hours);

        uint256 tvl = accountingManager.TVL();
        assertTrue(isCloseTo(tvl, amount, 100));
        connector.mintPTAndYT(pendleUsdtMarket, syBalance / 2);
        vm.roll(block.number + 20);
        vm.warp(block.timestamp + 1 hours);

        tvl = accountingManager.TVL();
        assertTrue(isCloseTo(tvl, amount, 100));

        syBalance = _SY.balanceOf(address(connector));

        uint256 PTBalance = _PT.balanceOf(address(connector));
        uint256 YTBalance = _YT.balanceOf(address(connector));

        connector.depositIntoMarket(IPMarket(pendleUsdtMarket), syBalance, PTBalance);

        vm.roll(block.number + 20);
        vm.warp(block.timestamp + 1 hours);

        tvl = accountingManager.TVL();
        assertTrue(isCloseTo(tvl, amount, 5000));

        uint256 LPBalance = IERC20(pendleUsdtMarket).balanceOf(address(connector));
        connector.depositIntoPenpie(pendleUsdtMarket, LPBalance);

        vm.roll(block.number + 20);
        vm.warp(block.timestamp + 1 hours);

        tvl = accountingManager.TVL();
        assertTrue(isCloseTo(tvl, amount, 5000));

        connector.withdrawFromPenpie(pendleUsdtMarket, LPBalance);
        vm.roll(block.number + 20);
        vm.warp(block.timestamp + 1 hours);

        tvl = accountingManager.TVL();
        assertTrue(isCloseTo(tvl, amount, 5000));
        connector.burnLP(IPMarket(pendleUsdtMarket), LPBalance);

        vm.roll(block.number + 20);
        vm.warp(block.timestamp + 1 hours);

        tvl = accountingManager.TVL();
        console.log("tvl2: %s", tvl);
        vm.stopPrank();
    }

    function testDepositIntoMarketAndClaimRewards() public {
        uint256 amount = 10_000;

        _dealERC20(USDT, address(connector), amount);
        vm.startPrank(owner);

        (IPStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT) = IPMarket(pendleUsdtMarket).readTokens();

        connector.supply(pendleUsdtMarket, amount);
        uint256 syBalance = _SY.balanceOf(address(connector));

        connector.mintPTAndYT(pendleUsdtMarket, syBalance / 2);

        syBalance = _SY.balanceOf(address(connector));

        uint256 PTBalance = _PT.balanceOf(address(connector));
        uint256 YTBalance = _YT.balanceOf(address(connector));

        connector.depositIntoMarket(IPMarket(pendleUsdtMarket), syBalance, PTBalance);

        uint256 LPBalance = IERC20(pendleUsdtMarket).balanceOf(address(connector));
        connector.depositIntoPenpie(pendleUsdtMarket, LPBalance);

        connector.claimRewards(IPMarket(pendleUsdtMarket));

        vm.stopPrank();
    }

    function testSwapPtForSY() public {
        uint256 amount = 10_000;

        _dealERC20(USDT, address(connector), amount);
        vm.startPrank(owner);

        (IPStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT) = IPMarket(pendleUsdtMarket).readTokens();

        connector.supply(pendleUsdtMarket, amount);
        uint256 syBalance = _SY.balanceOf(address(connector));

        connector.mintPTAndYT(pendleUsdtMarket, syBalance / 2);

        syBalance = _SY.balanceOf(address(connector));

        uint256 PTBalance = _PT.balanceOf(address(connector));
        uint256 YTBalance = _YT.balanceOf(address(connector));
        vm.expectRevert();
        connector.swapExactPTForSY(IPMarket(pendleUsdtMarket), PTBalance, "", 1e10);

        connector.swapExactPTForSY(IPMarket(pendleUsdtMarket), PTBalance, "", 0);

        assertTrue(_SY.balanceOf(address(connector)) > syBalance);

        assertEq(
            connector._getPositionTVL(
                HoldingPI({
                    calculatorConnector: address(connector),
                    ownerConnector: address(connector),
                    positionId: 0,
                    data: "",
                    additionalData: "",
                    positionTimestamp: 0
                }),
                USDC
            ),
            0
        );

        vm.stopPrank();
    }
}
