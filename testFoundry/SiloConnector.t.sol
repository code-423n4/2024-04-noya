// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "contracts/connectors/SiloConnector.sol";
import "contracts/helpers/valueOracle/oracles/WETH_Oracle.sol";

import "./utils/resources/MainnetAddresses.sol";

contract TestSiloConnector is testStarter, MainnetAddresses {
    SiloConnector connector;

    address siloRepository = 0xd998C35B7900b344bbBe6555cc11576942Cf309d;

    function setUp() public {
        console.log("----------- Initialization -----------");
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);
        deployEverythingNormal(USDC);

        connector = new SiloConnector(siloRepository, BaseConnectorCP(registry, vaultId, swapHandler, noyaOracle));

        console.log("SiloConnector deployed: %s", address(connector));

        addConnectorToRegistry(vaultId, address(connector));

        addTrustedTokens(vaultId, address(accountingManager), WETH);
        addTrustedTokens(vaultId, address(accountingManager), XAI);
        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTrustedTokens(vaultId, address(accountingManager), DAI);
        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        addTrustedTokens(vaultId, address(accountingManager), CRVUSD);
        addTokenToChainlinkOracle(address(CRVUSD), address(840), address(CRVUSD_USD_FEED));
        addTokenToNoyaOracle(address(CRVUSD), address(chainlinkOracle));

        addRoutesToNoyaOracle(address(WETH), address(USDC), address(840));

        console.log("Tokens added to registry");

        registry.addTrustedPosition(
            vaultId, connector.SILO_LP_ID(), address(connector), true, false, abi.encode(USDC), ""
        );
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(CRVUSD), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(WETH), "");

        addTokenToChainlinkOracle(address(WETH), address(840), address(WETH_USD_FEED));
        addTokenToNoyaOracle(address(WETH), address(chainlinkOracle));

        console.log("Positions added to registry");
    }

    function test_depositAndBorrow() public {
        console.log("----------- deposit -----------");
        uint256 _amount = 6_000_000_000;

        _dealWhale(baseToken, address(connector), USDC_Whale, _amount);
        _dealERC20(WETH, address(connector), 1);

        vm.startPrank(address(owner));

        connector.deposit(USDC, USDC, _amount, true);
        uint256 tvl = accountingManager.TVL();
        assertTrue(isCloseTo(tvl, _amount, 100));

        console.log("----------- borrow -----------");

        connector.borrow(USDC, WETH, 1e18);

        tvl = accountingManager.TVL();
        assertTrue(isCloseTo(tvl, _amount, 100));

        assertEq(IERC20(WETH).balanceOf(address(connector)), 1_000_000_000_000_000_001);

        (uint256 userLTV, uint256 LiquidationThreshold,) = connector.getData(USDC);

        assertEq(userLTV, 484_771_810_514_386_084);
        assertEq(LiquidationThreshold, 950_000_000_000_000_000);

        vm.expectRevert();
        connector.withdraw(USDC, USDC, _amount / 5, true, true); // health factor // Covered coverage bug number 37

        connector.repay(USDC, WETH, 1_000_000_000_000_000_001);
        (userLTV, LiquidationThreshold,) = connector.getData(USDC);

        assertEq(userLTV, 0);
        assertEq(LiquidationThreshold, 0);

        connector.withdraw(USDC, USDC, _amount / 2, true, true);

        connector.withdraw(USDC, USDC, _amount / 4, true, false); //  Covered coverage bug number 36 , 37

        connector.updateMinimumHealthFactor(4e70);

        connector.withdraw(USDC, USDC, _amount / 4, true, true);

        tvl = accountingManager.TVL();
        assertTrue(isCloseTo(tvl, _amount, 100));

        vm.stopPrank();
    }

    function test_depositAndBorrow2() public {
        console.log("----------- deposit -----------");
        uint256 _amount = 6_000_000_000;

        _dealWhale(baseToken, address(connector), USDC_Whale, _amount);
        _dealERC20(WETH, address(connector), 1);

        vm.startPrank(address(owner));

        connector.deposit(USDC, USDC, _amount, true);
        connector.borrow(USDC, WETH, 18e17);

        vm.expectRevert();
        connector.repay(USDC, WETH, 1001);

        vm.stopPrank();
    }
}
