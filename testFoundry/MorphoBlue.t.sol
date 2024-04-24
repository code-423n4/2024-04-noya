// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "./utils/testStarter.sol";
import "./utils/resources/MainnetAddresses.sol";
import {
    MorphoBlueConnector,
    BaseConnectorCP,
    Id,
    Market,
    IMorpho,
    MarketParams
} from "contracts/connectors/MorphoBlueConnector.sol";
import { MockDataFeedForMorphoBlue } from "./utils/mocks/MockDataFeedForMorphoBlue.sol";
import { IrmMock } from "./utils/mocks/IrmMock.sol";
// import { IMorpho, MarketParams, Market } from "contracts/external/interfaces/MorphoBlue/IMorpho.sol";

contract TestMorphoBlue is testStarter, MainnetAddresses {
    MorphoBlueConnector connector;
    MockDataFeedForMorphoBlue private mockUsdcUsd;
    Id usdcDaiMarketId;
    MarketParams private usdcDaiMarket;
    IMorpho public morphoBlueContract = IMorpho(morphoBlue);
    address public morphoBlueOwner = 0xcBa28b38103307Ec8dA98377ffF9816C164f9AFa;
    IrmMock irm;

    uint256 public DEFAULT_LLTV = 860_000_000_000_000_000; // (86% LLTV)

    uint256 internal constant MARKET_PARAMS_BYTES_LENGTH = 5 * 32;

    function id(MarketParams memory marketParams) internal pure returns (Id marketParamsId) {
        assembly ("memory-safe") {
            marketParamsId := keccak256(marketParams, MARKET_PARAMS_BYTES_LENGTH)
        }
    }

    function setUp() public {
        console.log("----------- Initialization -----------");
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);

        deployEverythingNormal(USDC);

        // --------------------------------- init connector ---------------------------------

        connector = new MorphoBlueConnector(morphoBlue, BaseConnectorCP(registry, 0, swapHandler, noyaOracle));

        // ------------------- add connector to registry -------------------
        addConnectorToRegistry(vaultId, address(connector));
        // ------------------- addTokensToSupplyOrBorrow -------------------
        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTrustedTokens(vaultId, address(accountingManager), DAI);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));
        mockUsdcUsd = new MockDataFeedForMorphoBlue(USDC_USD_FEED);
        mockUsdcUsd.setMockAnswer(1e8, ERC20(USDC), ERC20(USDC));

        irm = new IrmMock();

        vm.stopPrank();

        vm.startPrank(morphoBlueOwner);
        morphoBlueContract.enableIrm(address(irm));
        morphoBlueContract.setFeeRecipient(owner);
        vm.stopPrank();
        vm.startPrank(owner);

        usdcDaiMarket = MarketParams({
            loanToken: address(USDC),
            collateralToken: address(DAI),
            oracle: address(mockUsdcUsd),
            irm: address(irm),
            lltv: DEFAULT_LLTV
        });

        morphoBlueContract.createMarket(usdcDaiMarket);
        usdcDaiMarketId = id(usdcDaiMarket);

        console.log("Tokens added to registry");
        registry.addTrustedPosition(
            vaultId, connector.MORPHO_POSITION_ID(), address(connector), true, false, abi.encode(usdcDaiMarketId), ""
        );
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        registry.addTrustedPosition(vaultId, 12, address(connector), false, false, abi.encode(usdcDaiMarketId), "");
        console.log("Positions added to registry");
        vm.stopPrank();
    }

    function testDeposit() public {
        uint256 amount = 1000 * 1e6;
        uint256 amount_dai = 1000 * 1e18;
        console.log("----------- Test Deposit -----------");
        _dealWhale(baseToken, address(connector), USDC_Whale, amount);
        _dealERC20(DAI, address(connector), amount_dai);
        vm.startPrank(owner);

        connector.supply(amount, usdcDaiMarketId, true);
        connector.supply(amount_dai, usdcDaiMarketId, false);

        uint256 tvl = accountingManager.TVL();
        console.log("TVL: %s", tvl);

        vm.stopPrank();
    }

    function testWithdraw() public {
        uint256 amount = 1000 * 1e6;
        console.log("----------- Test Deposit -----------");
        _dealWhale(baseToken, address(connector), USDC_Whale, 3 * amount);
        _dealERC20(DAI, address(connector), 3 * amount);
        vm.startPrank(owner);

        assertEq(
            address(morphoBlueContract), address(connector.morphoBlue()), "MorphoBlue address is not set correctly"
        );

        connector.supply(amount, usdcDaiMarketId, true);
        connector.supply(amount, usdcDaiMarketId, false);

        connector.withdraw(amount, usdcDaiMarketId, true); // Cover coverage bug number 26
        connector.withdraw(amount, usdcDaiMarketId, false);
        vm.stopPrank();
    }

    function testBorrowAndRepay() public {
        uint256 amount = 1000 * 1e6;
        console.log("----------- Test Borrow and Repay -----------");
        _dealWhale(baseToken, address(connector), USDC_Whale, 3 * amount);
        _dealERC20(DAI, address(connector), 3 * amount);
        vm.startPrank(owner);

        connector.getHealthFactor(usdcDaiMarketId, Market(0, 0, 0, 0, 0, 0));

        connector.supply(amount, usdcDaiMarketId, true);
        // to add liquidity to the pool
        connector.supply(amount, usdcDaiMarketId, false);

        connector.borrow(amount / 2, usdcDaiMarketId);

        connector.updateMinimumHealthFactor(10_320_000_000_000_000_000);
        vm.expectRevert();
        connector.borrow(amount / 5, usdcDaiMarketId); // Cover coverage bug number 27

        connector.updateMinimumHealthFactor(15e17);
        connector.repay(amount / 2, usdcDaiMarketId);

        connector.getPositionTVL( //  Covered coverage bug number 28
            HoldingPI({
                calculatorConnector: address(connector),
                positionId: registry.calculatePositionId(address(connector), 12, abi.encode(usdcDaiMarketId)),
                ownerConnector: address(connector),
                data: "",
                additionalData: "",
                positionTimestamp: 0
            }),
            address(USDC)
        );

        vm.stopPrank();
    }
}
