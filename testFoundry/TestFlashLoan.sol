// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import { testStarter } from "./utils/testStarter.sol";

import "forge-std/Test.sol";
import "forge-std/console.sol";
import { Vm } from "forge-std/Vm.sol";

import "./utils/resources/MainnetAddresses.sol";
import "./utils/resources/OptimismAddresses.sol";

import { ConnectorMock2 } from "./utils/mocks/ConnectorMock2.sol";

import { BalancerFlashLoan, IERC20 } from "contracts/connectors/BalancerFlashLoan.sol";

import { AaveConnector, BaseConnectorCP } from "contracts/connectors/AaveConnector.sol";

contract TestFlashLoan is testStarter, OptimismAddresses {
    // using SafeERC20 for IERC20;

    AaveConnector connector;
    BalancerFlashLoan balancerFlashLoan;

    function setUp() public {
        console.log("----------- Initialization -----------");
        // --------------------------------- set env --------------------------------
        uint256 fork = vm.createFork(RPC_URL, 117_307_857);
        vm.selectFork(fork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);

        deployEverythingNormal(USDC);

        // --------------------------------- init connector ---------------------------------
        connector = new AaveConnector(aavePool, address(840), BaseConnectorCP(registry, 0, swapHandler, noyaOracle));
        balancerFlashLoan = new BalancerFlashLoan(balancerVault, registry);

        registry.setFlashLoanAddress(address(balancerFlashLoan));

        console.log("AaveConnector deployed: %s", address(connector));
        // ------------------- add connector to registry -------------------
        addConnectorToRegistry(vaultId, address(connector));
        addConnectorToRegistry(vaultId, address(balancerFlashLoan));
        // ------------------- addTokensToSupplyOrBorrow -------------------
        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTrustedTokens(vaultId, address(accountingManager), DAI);
        addTrustedTokens(vaultId, address(accountingManager), WETH);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(WETH), address(840), address(ETH_USD_FEED));
        addTokenToNoyaOracle(address(WETH), address(chainlinkOracle));
        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        addRoutesToNoyaOracle(address(DAI), address(USDC), address(840));
        addRoutesToNoyaOracle(address(WETH), address(USDC), address(840));

        console.log("Tokens added to registry");
        registry.addTrustedPosition(vaultId, connector.AAVE_POSITION_ID(), address(connector), true, false, "", "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(WETH), "");
        console.log("Positions added to registry");
        vm.stopPrank();
    }

    function testFlashLoan() public {
        // scenario: deposit to Aave
        // 1. deposit to Aave
        // 2. check TVL
        console.log("-----------Aave Deposit Flow--------------");
        uint256 _amount = 10 * 1e6;
        _dealWhale(baseToken, address(connector), USDC_Whale, _amount);
        vm.startPrank(address(owner));

        (address accountingManagerAddress,) = registry.getVaultAddresses(0);
        assertEq(accountingManagerAddress, address(accountingManager), "testAaveDepositFlow: E1");
        connector.updateTokenInRegistry(USDC);
        connector.supply(USDC, _amount);
        connector.borrow(5e18, 2, DAI);
        connector.supply(DAI, 5e18);

        console.log("USDC balance: %s", IERC20(USDC).balanceOf(address(connector)));
        console.log("DAI balance: %s", IERC20(DAI).balanceOf(address(connector)));

        IERC20[] memory assets = new IERC20[](1);
        assets[0] = IERC20(DAI);
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 5e18;

        address[] memory callAddresses = new address[](5);
        bytes[] memory callDatas = new bytes[](5);
        uint256[] memory gasAmounts = new uint256[](5);
        // payBack the loan
        callAddresses[0] = address(connector);
        callDatas[0] = abi.encodeWithSelector(connector.repay.selector, DAI, 5e18, 2);
        gasAmounts[0] = type(uint256).max;

        callAddresses[1] = address(connector);
        callDatas[1] = abi.encodeWithSelector(connector.withdrawCollateral.selector, _amount, USDC);
        gasAmounts[1] = type(uint256).max;

        callAddresses[2] = address(connector);
        {
            bytes memory _data =
                hex"4630a0d8a6415413036551ad38d46771c2f8d48ccc78b350b59ef68ffae5280615bfe29b00000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000001000000000000000000000000001a83c6Cb0bF880F81E5b5e536DC2A3da33a778300000000000000000000000000000000000000000000000000008c40ad08baf93000000000000000000000000000000000000000000000000000000000000016000000000000000000000000000000000000000000000000000000000000000086c6966692d617069000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002a30783030303030303030303030303030303030303030303030303030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000001111111254eeb25477b68fb85ed929f73a9605820000000000000000000000001111111254eeb25477b68fb85ed929f73a9605820000000000000000000000000b2c639c533813f4aa9d7837caf62653d097ff850000000000000000000000004200000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000098968000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000c8e449022e00000000000000000000000000000000000000000000000000000000009896800000000000000000000000000000000000000000000000000008c40ad08baf9300000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000002000000000000000000000000d28f71e383e93c570d3edfe82ebbceb35ec6c41280000000000000000000000095d9d28606ee55de7667f0f176ebfc3215cfd9c02e9b3012000000000000000000000000000000000000000000000000";

            address[] memory tokensIn = new address[](1);
            address[] memory tokensOut = new address[](1);
            uint256[] memory amountsIn = new uint256[](1);
            bytes[] memory swapData = new bytes[](1);
            uint256[] memory routeIds = new uint256[](1);

            tokensIn[0] = USDC;
            tokensOut[0] = WETH;
            amountsIn[0] = _amount;
            swapData[0] = _data;
            routeIds[0] = 0;
            callDatas[2] = abi.encodeWithSelector(
                connector.swapHoldings.selector, tokensIn, tokensOut, amountsIn, swapData, routeIds
            );
        }
        gasAmounts[2] = type(uint256).max;

        callAddresses[3] = address(connector);
        callDatas[3] = abi.encodeWithSelector(connector.supply.selector, WETH, 2_473_282_968_630_821);
        gasAmounts[3] = type(uint256).max;

        callAddresses[4] = address(connector);
        callDatas[4] = abi.encodeWithSelector(connector.borrow.selector, 5e48, 2, DAI);
        gasAmounts[4] = type(uint256).max;

        bytes memory flashLoanData = abi.encode(vaultId, address(connector), callAddresses, callDatas, gasAmounts);
        vm.expectRevert();
        balancerFlashLoan.makeFlashLoan(assets, amounts, flashLoanData); // Cover coverage bug number 16

        callDatas[4] = abi.encodeWithSelector(connector.borrow.selector, 5e18, 2, DAI);
        flashLoanData = abi.encode(vaultId, address(connector), callAddresses, callDatas, gasAmounts);
        balancerFlashLoan.makeFlashLoan(assets, amounts, flashLoanData);

        flashLoanData = abi.encode(vaultId, address(owner), callAddresses, callDatas, gasAmounts);
        balancerFlashLoan.makeFlashLoan(assets, amounts, flashLoanData); // Cover coverage bug number 17
    }

    function testErrors() public {
        ConnectorMock2 connectorMock = new ConnectorMock2(address(registry), 0);
        _dealERC20(DAI, address(connectorMock), 10);

        IERC20[] memory tokens = new IERC20[](1);
        tokens[0] = IERC20(DAI);
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 5e18;
        uint256[] memory feeAmounts = new uint256[](1);

        vm.expectRevert();
        balancerFlashLoan.receiveFlashLoan(tokens, amounts, feeAmounts, ""); // Cover coverage bug number 15
        bytes memory flashLoanData =
            abi.encode(vaultId, address(owner), new address[](0), new bytes[](0), new uint256[](0));

        vm.expectRevert();
        balancerFlashLoan.makeFlashLoan(tokens, amounts, flashLoanData);

        vm.startPrank(address(owner));

        addConnectorToRegistry(vaultId, address(connectorMock));

        address[] memory callAddresses = new address[](1);
        bytes[] memory callDatas = new bytes[](1);
        uint256[] memory gasAmounts = new uint256[](1);
        // payBack the loan
        callAddresses[0] = address(connectorMock);
        callDatas[0] = abi.encodeWithSelector(
            connectorMock.sendTokensToTrustedAddress.selector, DAI, 10, address(balancerFlashLoan), abi.encode(10, 10)
        );
        gasAmounts[0] = type(uint256).max;

        flashLoanData = abi.encode(vaultId, address(connectorMock), callAddresses, callDatas, gasAmounts);
        vm.expectRevert();
        balancerFlashLoan.makeFlashLoan(tokens, amounts, flashLoanData); // Cover coverage bug number 18
    }
}
