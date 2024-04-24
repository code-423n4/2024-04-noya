// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "./utils/resources/MainnetAddresses.sol";

import "contracts/connectors/CompoundConnector.sol";

contract TestCompoundConnector is testStarter, MainnetAddresses {
    // using SafeERC20 for IERC20;

    CompoundConnector connector;

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
        connector = new CompoundConnector(BaseConnectorCP(registry, 0, swapHandler, noyaOracle));

        console.log("CompoundConnector deployed: %s", address(connector));
        addConnectorToRegistry(vaultId, address(connector));
        // ------------------- add BalancerConnector as eligable user for swap -------------------
        addTrustedTokens(vaultId, address(accountingManager), WETH);
        addTrustedTokens(vaultId, address(accountingManager), DAI);
        addTrustedTokens(vaultId, address(accountingManager), COMP);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(WETH), address(840), address(WETH_USD_FEED));
        addTokenToNoyaOracle(address(WETH), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(COMP), address(840), address(COMP_USD_FEED));
        addTokenToNoyaOracle(address(COMP), address(chainlinkOracle));

        addRoutesToNoyaOracle(address(DAI), address(USDC), address(840));
        addRoutesToNoyaOracle(address(WETH), address(USDC), address(840));
        addRoutesToNoyaOracle(address(COMP), address(USDC), address(840));

        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(WETH), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(COMP), "");

        registry.addTrustedPosition(
            vaultId, connector.COMPOUND_LP(), address(connector), true, false, abi.encode(cUSDC), ""
        );
        vm.stopPrank();
    }

    function testProcessFlow() public {
        console.log("-----------Base Workflow--------------");
        uint256 _amount = 1 * 1e18;
        console.log("  Balance before deposit: %s USDC", _amount / 1e6);
        address _asset = WETH;

        // _dealWhale(address(USDC), address(connector), USDC_Whale, _amount);
        _dealERC20(WETH, address(connector), _amount);

        // --------------------------------- statr prank with owner ---------------------------------
        vm.startPrank(owner);
        // --------------------------------- add liquidity ---------------------------------
        connector.supply(cUSDC, _asset, _amount);

        // console.log("(V) %s USDC deposited to Connector", _amount / 1e6);

        // // -------------------------- claim rewards -------------------------
        uint256 tvl = accountingManager.TVL(); // Cover coverage bug number 22
        uint256 colBalance = connector.getCollBlanace(IComet(cUSDC), false);

        console.log("  Connector tvl: %s USDC", tvl);
        console.log("  value:         %s USDC", noyaOracle.getValue(WETH, USDC, _amount));
        assertTrue(isCloseTo(tvl, noyaOracle.getValue(WETH, USDC, _amount), 100), "testProcessFlow: E1");

        skip(5 days);

        connector.claimRewards(cometRewards, cUSDC);

        // // -------------------------- borrow base token -------------------------

        connector.withdrawOrBorrow(cUSDC, _asset, _amount / 2);
        connector.withdrawOrBorrow(cUSDC, _asset, _amount / 2); // Cover coverage bug number 21

        vm.stopPrank();
    }

    function testSupplyAndBorrowFlow() public {
        console.log("-----------Base Workflow--------------");
        uint256 _amount = 10 * 1e18;
        console.log("  Balance before deposit: %s WETH", _amount);
        address _asset = WETH;

        _dealWhale(address(USDC), address(connector), USDC_Whale, 50e6);
        _dealERC20(WETH, address(connector), _amount);

        // --------------------------------- statr prank with owner ---------------------------------
        vm.startPrank(owner);
        // --------------------------------- add liquidity ---------------------------------
        connector.supply(cUSDC, _asset, _amount);

        // // -------------------------- borrow base token -------------------------

        // connector.withdrawOrBorrow(cUSDC, _asset, _amount / 2);
        // connector.withdrawOrBorrow(cUSDC, _asset, _amount / 2);

        uint256 colBalance = connector.getCollBlanace(IComet(cUSDC), true);

        vm.expectRevert();
        connector.supply(cUSDC, FRAX, _amount); // Cover coverage bug number 19

        vm.expectRevert();
        connector.withdrawOrBorrow(cUSDC, FRAX, 1); // Cover coverage bug number 20

        vm.expectRevert();
        connector.withdrawOrBorrow(cUSDC, USDC, 100e6);

        addTrustedTokens(vaultId, address(accountingManager), USDC);
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");

        connector.withdrawOrBorrow(cUSDC, USDC, 100e6);

        vm.expectRevert();
        connector.withdrawOrBorrow(cUSDC, USDC, 100e6);

        uint256 tvl = accountingManager.TVL();
        console.log("  Connector tvl: %s USDC", tvl);
        vm.stopPrank();
    }
}
