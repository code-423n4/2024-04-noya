// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/utils/Strings.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";

import "contracts/helpers/BaseConnector.sol";
import "./utils/testStarter.sol";
import "./utils/resources/OptimismAddresses.sol";

contract TestBaseConnector is testStarter, OptimismAddresses {
    // using SafeERC20 for IERC20;

    BaseConnector connector;
    BaseConnector connector2;

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
        connector = new BaseConnector(BaseConnectorCP(registry, 0, swapHandler, noyaOracle));
        connector2 = new BaseConnector(BaseConnectorCP(registry, 0, swapHandler, noyaOracle));

        console.log("connector deployed: %s", address(connector));
        console.log("connector2 deployed: %s", address(connector2));
        // ------------------- add connector to registry -------------------
        addConnectorToRegistry(vaultId, address(connector));
        addConnectorToRegistry(vaultId, address(connector2));
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
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(WETH), "");
        console.log("Positions added to registry");
        vm.stopPrank();
    }

    function testSetterFunctions() public {
        console.log("-----------Setter functions in base connector--------------");
        vm.startPrank(owner);
        deployNoyaOracle();
        connector.updateValueOracle(address(noyaOracle));
        assertEq(address(connector.valueOracle()), address(noyaOracle));

        deploySwapHandler();
        connector.updateSwapHandler(payable(address(swapHandler)));
        assertEq(address(connector.swapHandler()), address(swapHandler));
        vm.expectRevert();
        connector.updateMinimumHealthFactor(2e9);
        connector.updateMinimumHealthFactor(2e18);

        address[] memory tokens = connector.getUnderlyingTokens(0, abi.encode(USDC));
        assertEq(tokens.length, 1);
        assertEq(tokens[0], address(USDC));
    }

    function testTransferPosition() public {
        uint256 _amount = 10 * 1e6;
        _dealWhale(baseToken, address(connector), USDC_Whale, _amount);
        vm.startPrank(owner);
        address[] memory tokens = new address[](1);
        tokens[0] = USDC;
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = _amount;
        bytes memory data = "";

        connector.transferPositionToAnotherConnector(tokens, amounts, data, address(connector2));

        assertTrue(IERC20(USDC).balanceOf(address(connector2)) == _amount, "E1");
    }

    function testSwap() public {
        uint256 _amount = 10 * 1e6;
        _dealWhale(baseToken, address(connector), USDC_Whale, _amount);
        vm.startPrank(owner);
        lifiImplementation.addHandler(address(connector), true); // testing the lifi implementation setters
        lifiImplementation.addChain(1, true);
        lifiImplementation.addBridgeBlacklist("bridgeName", true);
        assertTrue(IERC20(USDC).balanceOf(address(connector)) == _amount, "E1");
        bytes memory _data =
            hex"4630a0d8a6415413036551ad38d46771c2f8d48ccc78b350b59ef68ffae5280615bfe29b00000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000001000000000000000000000000001a83c6Cb0bF880F81E5b5e536DC2A3da33a778300000000000000000000000000000000000000000000000000008c40ad08baf93000000000000000000000000000000000000000000000000000000000000016000000000000000000000000000000000000000000000000000000000000000086c6966692d617069000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002a30783030303030303030303030303030303030303030303030303030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000001111111254eeb25477b68fb85ed929f73a9605820000000000000000000000001111111254eeb25477b68fb85ed929f73a9605820000000000000000000000000b2c639c533813f4aa9d7837caf62653d097ff850000000000000000000000004200000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000098968000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000c8e449022e00000000000000000000000000000000000000000000000000000000009896800000000000000000000000000000000000000000000000000008c40ad08baf9300000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000002000000000000000000000000d28f71e383e93c570d3edfe82ebbceb35ec6c41280000000000000000000000095d9d28606ee55de7667f0f176ebfc3215cfd9c02e9b3012000000000000000000000000000000000000000000000000";

        bytes memory _data_corrupted =
            hex"4620a0d8a6415413036551ad38d46771c2f8d48ccc78b350b59ef68ffae5280615bfe29b00000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000001000000000000000000000000001a83c6Cb0bF880F81E5b5e536DC2A3da33a778300000000000000000000000000000000000000000000000000008c40ad08baf93000000000000000000000000000000000000000000000000000000000000016000000000000000000000000000000000000000000000000000000000000000086c6966692d617069000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002a30783030303030303030303030303030303030303030303030303030303030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000001111111254eeb25477b68fb85ed929f73a9605820000000000000000000000001111111254eeb25477b68fb85ed929f73a9605820000000000000000000000000b2c639c533813f4aa9d7837caf62653d097ff850000000000000000000000004200000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000098968000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000c8e449022e00000000000000000000000000000000000000000000000000000000009896800000000000000000000000000000000000000000000000000008c40ad08baf9300000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000002000000000000000000000000d28f71e383e93c570d3edfe82ebbceb35ec6c41280000000000000000000000095d9d28606ee55de7667f0f176ebfc3215cfd9c02e9b3012000000000000000000000000000000000000000000000000";

        address[] memory tokensIn = new address[](1);
        address[] memory tokensOut = new address[](1);
        uint256[] memory amountsIn = new uint256[](1);
        bytes[] memory swapData = new bytes[](1);
        uint256[] memory routeIds = new uint256[](1);

        tokensIn[0] = USDC;
        tokensOut[0] = WETH;
        amountsIn[0] = _amount;

        swapData[0] = _data_corrupted;
        routeIds[0] = 0;

        vm.expectRevert();
        connector.swapHoldings(tokensIn, tokensOut, amountsIn, swapData, routeIds);

        amountsIn[0] = 0;
        swapData[0] = _data;

        vm.expectRevert();
        connector.swapHoldings(tokensIn, tokensOut, amountsIn, swapData, routeIds);

        amountsIn[0] = _amount;
        routeIds[0] = 1;

        vm.expectRevert();
        connector.swapHoldings(tokensIn, tokensOut, amountsIn, swapData, routeIds);
        routeIds[0] = 0;

        connector.swapHoldings(tokensIn, tokensOut, amountsIn, swapData, routeIds);

        assertTrue(IERC20(WETH).balanceOf(address(connector)) > 0, "E2");
        assertTrue(IERC20(USDC).balanceOf(address(connector)) == 0, "E3");

        // SwapRequest memory _swapRequest;
        // _swapRequest.from = owner;
        // _swapRequest.routeId = 0;
        // _swapRequest.amount = _amount;
        // _swapRequest.inputToken = USDC;
        // _swapRequest.outputToken = WETH;
        // _swapRequest.data = _data;

        // _swapRequest.checkForSlippage = false;
        // _swapRequest.minAmount = 0;

        vm.stopPrank();
    }
}
