// SPDX-License-Identifier: Apache-2.0

pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/utils/Strings.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";

import { FraxConnector, BaseConnectorCP } from "contracts/connectors/FraxConnector.sol";
import "contracts/helpers/valueOracle/oracles/WETH_Oracle.sol";
import "contracts/external/interfaces/Frax/IFraxPair.sol";
import "./utils/testStarter.sol";
import "./utils/resources/MainnetAddresses.sol";

contract TestFraxConnector is testStarter, MainnetAddresses {
    // using SafeERC20 for IERC20;

    FraxConnector connector;

    address constant fraxPool = 0x794F6B13FBd7EB7ef10d1ED205c9a416910207Ff;

    function setUp() public {
        console.log("----------- Initialization -----------");
        // --------------------------------- set env --------------------------------

        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);

        deployEverythingNormal(WETH);

        // --------------------------------- init connector ---------------------------------
        connector = new FraxConnector(BaseConnectorCP(registry, 0, swapHandler, noyaOracle));

        console.log("FraxConnector deployed: %s", address(connector));

        // ------------------- add connector to registry -------------------
        address[] memory connectors = new address[](1);
        connectors[0] = address(connector);
        bool[] memory enabled = new bool[](1);
        enabled[0] = true;
        registry.addConnector(0, connectors, enabled);
        console.log("FraxConnector added to registry");
        // ------------------- add connector as eligable user for swap -------------------
        swapHandler.addEligibleUser(address(connector));
        console.log("FraxConnector added as eligible user for swap");
        // ------------------- addTokensToSupplyOrBorrow -------------------
        WETH_Oracle wethOracle = new WETH_Oracle();
        addTrustedTokens(vaultId, address(accountingManager), FRAX);
        addTrustedTokens(vaultId, address(accountingManager), WETH);

        addTokenToChainlinkOracle(address(WETH), address(0), address(wethOracle));
        addTokenToNoyaOracle(address(WETH), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(FRAX), address(0), address(FRAX_ETH_FEED));
        addTokenToNoyaOracle(address(FRAX), address(chainlinkOracle));

        addRoutesToNoyaOracle(address(FRAX), address(WETH), address(0));

        console.log("Tokens added to registry");
        registry.addTrustedPosition(
            0, connector.COLLATERAL_AND_DEBT_POSITION_TYPE(), address(connector), true, false, abi.encode(fraxPool), ""
        );
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(FRAX), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(WETH), "");
        console.log("Position added to registry");
        vm.stopPrank();
    }

    function testDepositFlow() public {
        console.log("-----------Frax Deposit Flow--------------");

        uint256 _amount = 100_000_000;

        uint256 _tvl = accountingManager.TVL();
        console.log("TVL %s", _tvl);

        _dealERC20(WETH, address(connector), _amount);
        _dealERC20(FRAX, address(connector), 10); // to repay the borrow fee

        vm.startPrank(address(owner));

        connector.borrowAndSupply(IFraxPair(fraxPool), 0, _amount / 2); // Covered coverage bug number 51

        _tvl = accountingManager.TVL();
        console.log("TVL %s", _tvl);

        vm.expectRevert();
        connector.repay(IFraxPair(fraxPool), _amount / 2);

        connector.borrowAndSupply(IFraxPair(fraxPool), 100, _amount / 2); // Covered coverage bug number 51, 52

        connector.verifyHealthFactor(IFraxPair(fraxPool));

        connector.borrowAndSupply(IFraxPair(fraxPool), 100, 0); // Covered coverage bug number 52

        connector.repay(IFraxPair(fraxPool), 196);
        uint256 currentCollateral = IFraxPair(fraxPool).userCollateralBalance(address(connector));
        connector.withdraw(IFraxPair(fraxPool), currentCollateral / 2); // Covered coverage bug number 54
        currentCollateral = IFraxPair(fraxPool).userCollateralBalance(address(connector));
        connector.withdraw(IFraxPair(fraxPool), currentCollateral); // Covered coverage bug number 54

        _tvl = accountingManager.TVL();
        console.log("TVL %s", _tvl);

        vm.stopPrank();
    }

    // function testDepositAndBorrowFlow() public {
    //     console.log("-----------Deposit And Borrow Flow--------------");
    //     uint256 _amount = 100_000_000;

    //     _dealWhale(baseToken, address(connector), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), 2000 * _amount);

    //     vm.startPrank(address(owner));

    //     connector.supply(USDC, 2000 * _amount);

    //     uint256 DaiAmount = 50 * 1e18;
    //     connector.borrow(DaiAmount, 2, DAI);

    //     uint256 _tvl = accountingManager.TVL();
    //     assertTrue(_tvl > 199_000_000_000 && _tvl < 200_100_000_000, "testDeposit: E6");

    //     connector.borrow(10 * 1e18, 2, DAI);

    //     connector.supply(DAI, 50 * 1e18);

    //     connector.withdrawCollateral(80 * 1e6, USDC);

    //     connector.repayWithCollateral(50 * 1e18, 2, DAI);

    //     connector.withdrawCollateral(_amount, USDC);
    //     (
    //         uint256 totalCollateralBase,
    //         uint256 totalDebtBase,
    //         uint256 availableBorrowsBase,
    //         uint256 currentLiquidationThreshold,
    //         uint256 ltv,
    //         uint256 healthFactor
    //     ) = IPool(pool).getUserAccountData(address(connector));
    //     console.log("totalCollateralBase %s", totalCollateralBase);
    //     console.log("totalDebtBase %s", totalDebtBase);

    //     vm.expectRevert();
    //     connector.borrow(_amount, 2, GHO);

    //     connector.repay(DAI, 5 * 1e18, 2);

    //     vm.stopPrank();
    // }

    // function testDepositAndRemovePosition() public {
    //     uint256 _amount = 100_000_000;
    //     _dealWhale(baseToken, address(connector), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), 2 * _amount);

    //     vm.startPrank(address(owner));

    //     connector.supply(USDC, 2 * _amount);

    //     connector.withdrawCollateral(2 * _amount - 5e4, USDC);

    //     (
    //         uint256 totalCollateralBase,
    //         uint256 totalDebtBase,
    //         uint256 availableBorrowsBase,
    //         uint256 currentLiquidationThreshold,
    //         uint256 ltv,
    //         uint256 healthFactor
    //     ) = IPool(pool).getUserAccountData(address(connector));
    //     console.log("totalCollateralBase %s", totalCollateralBase);
    //     console.log("totalDebtBase %s", totalDebtBase);

    //     assertTrue(totalCollateralBase < connector.DUST_LEVEL() * 1e7, "testDepositAndRemovePosition: E1");

    //     assertEq(connector.AAVE_POSITION_ID(), 1, "testDepositAndRemovePosition: E2");

    //     vm.stopPrank();
    // }
}
