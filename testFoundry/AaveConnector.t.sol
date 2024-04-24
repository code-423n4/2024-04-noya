// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/utils/Strings.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";

import { AaveConnector, BaseConnectorCP } from "contracts/connectors/AaveConnector.sol";
import { IPool } from "contracts/external/interfaces/Aave/IPool.sol";
import "./utils/testStarter.sol";
import "./utils/resources/OptimismAddresses.sol";

contract TestAaveConnector is testStarter, OptimismAddresses {
    // using SafeERC20 for IERC20;

    AaveConnector connector;

    function setUp() public {
        console.log("----------- Initialization -----------");
        // --------------------------------- set env --------------------------------
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);

        deployEverythingNormal(USDC);

        // --------------------------------- init connector ---------------------------------
        connector = new AaveConnector(aavePool, address(840), BaseConnectorCP(registry, 0, swapHandler, noyaOracle));

        console.log("AaveConnector deployed: %s", address(connector));
        // ------------------- add connector to registry -------------------
        addConnectorToRegistry(vaultId, address(connector));
        // ------------------- addTokensToSupplyOrBorrow -------------------
        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTrustedTokens(vaultId, address(accountingManager), DAI);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        addRoutesToNoyaOracle(address(DAI), address(USDC), address(840));

        console.log("Tokens added to registry");
        registry.addTrustedPosition(vaultId, connector.AAVE_POSITION_ID(), address(connector), true, false, "", "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        console.log("Positions added to registry");
        vm.stopPrank();
    }

    // scenario: deposit to Aave
    // 1. deposit to Aave
    // 2. check TVL
    function testAaveDepositFlow() public {
        console.log("-----------Aave Deposit Flow--------------");
        uint256 _amount = 200_000_000;
        _dealWhale(baseToken, address(connector), USDC_Whale, _amount);
        vm.startPrank(address(owner));

        (address accountingManagerAddress,) = registry.getVaultAddresses(0);
        assertEq(accountingManagerAddress, address(accountingManager), "testAaveDepositFlow: E1");

        connector.updateTokenInRegistry(USDC);

        HoldingPI[] memory positions = registry.getHoldingPositions(0);
        assertEq(positions.length, 2, "testAaveDepositFlow: E2");
        bytes32 positionId = registry.calculatePositionId(address(accountingManager), 0, abi.encode(USDC));

        uint256 _tvl = accountingManager.TVL();
        assertEq(_tvl, _amount, "testAaveDepositFlow: E4");

        // ------------------- deposit to USDC market -------------------

        assertTrue(IERC20(baseToken).balanceOf(address(connector)) == _amount, "testVaultDepositFlow: E5");

        connector.supply(USDC, _amount / 2);

        positions = registry.getHoldingPositions(0);
        assertEq(positions.length, 3, "testAaveDepositFlow: E6");
        uint256 index =
            registry.getHoldingPositionIndex(0, positionId, address(connector), abi.encode(address(connector)));
        assertEq(index, 1, "testAaveDepositFlow: E7");

        connector.supply(USDC, _amount / 2);

        positions = registry.getHoldingPositions(0);
        assertEq(positions.length, 2, "testAaveDepositFlow: E8");
        index = registry.getHoldingPositionIndex(0, positionId, address(connector), "");
        assertEq(index, 0, "testAaveDepositFlow: E3");

        vm.expectRevert();
        connector.borrow(1, 2, USDCe); // Cover coverage bug number 11

        _tvl = accountingManager.TVL();
        assertTrue(isCloseTo(_tvl, 200_200_000, 20), "testDeposit: E6");
    }

    function testHealthFactor() public {
        console.log("-----------Deposit And Borrow Flow--------------");
        uint256 _amount = 100_000_000;

        _dealWhale(baseToken, address(connector), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), 2000 * _amount);

        vm.startPrank(address(owner));

        connector.supply(USDC, _amount);
        connector.updateMinimumHealthFactor(1e19);

        uint256 DaiAmount = 60 * 1e18;
        vm.expectRevert(); // health factor is less than 1
        connector.borrow(DaiAmount, 2, DAI);

        connector.borrow(1 * 1e18, 2, DAI);

        vm.expectRevert(); // health factor is less than 1
        connector.withdrawCollateral(90 * 1e6, USDC);

        vm.stopPrank();
    }

    function testDepositAndBorrowFlow() public {
        console.log("-----------Deposit And Borrow Flow--------------");
        uint256 _amount = 100_000_000;

        _dealWhale(baseToken, address(connector), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), 2000 * _amount);

        vm.startPrank(address(owner));

        connector.supply(USDC, 2000 * _amount);

        uint256 DaiAmount = 50 * 1e18;
        connector.borrow(DaiAmount, 2, DAI);

        HoldingPI[] memory positions = registry.getHoldingPositions(vaultId);
        for (uint256 i = 0; i < positions.length; i++) {
            console.log("positionId %s", positions[i].calculatorConnector);
        }

        uint256 _tvl = connector._getPositionTVL(positions[1], USDC);
        uint256 _tvl2 = accountingManager.TVL();
        console.log("TVL %s", _tvl2);
        assertTrue(_tvl > 199_000_000_000 && _tvl < 200_100_000_000, "testDeposit: E6");

        connector.borrow(10 * 1e18, 2, DAI);

        connector.supply(DAI, 50 * 1e18);

        connector.withdrawCollateral(80 * 1e6, USDC);

        connector.repayWithCollateral(50 * 1e18, 2, DAI);

        connector.withdrawCollateral(_amount, USDC);
        (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        ) = IPool(aavePool).getUserAccountData(address(connector));
        console.log("totalCollateralBase %s", totalCollateralBase);
        console.log("totalDebtBase %s", totalDebtBase);

        vm.expectRevert();
        connector.borrow(_amount, 2, GHO);

        connector.repay(DAI, 5 * 1e18, 2);

        vm.stopPrank();
    }

    function testDepositAndRemovePosition() public {
        uint256 _amount = 100_000_000;
        _dealWhale(baseToken, address(connector), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), 2 * _amount);

        vm.startPrank(address(owner));

        connector.supply(USDC, 2 * _amount);

        connector.withdrawCollateral(1, USDC);
        connector.withdrawCollateral(2 * _amount - 5e4, USDC); // Cover coverage bug number 12

        (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        ) = IPool(aavePool).getUserAccountData(address(connector));
        console.log("totalCollateralBase %s", totalCollateralBase);
        console.log("totalDebtBase %s", totalDebtBase);

        assertTrue(totalCollateralBase < connector.DUST_LEVEL() * 1e7, "testDepositAndRemovePosition: E1");

        assertEq(connector.AAVE_POSITION_ID(), 1, "testDepositAndRemovePosition: E2");

        vm.stopPrank();
    }
}
