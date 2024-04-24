// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "contracts/connectors/SiloConnector.sol";
import "contracts/connectors/BalancerFlashLoan.sol";
import "contracts/helpers/valueOracle/oracles/WETH_Oracle.sol";

import "./utils/resources/MainnetAddresses.sol";

contract TestSiloFlashLoan is testStarter, MainnetAddresses {
    SiloConnector connector;
    BalancerFlashLoan balancerFlashLoan;

    address siloRepository = 0xd998C35B7900b344bbBe6555cc11576942Cf309d;

    function setUp() public {
        console.log("----------- Initialization -----------");
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);
        deployEverythingNormal(USDC);

        connector = new SiloConnector(siloRepository, BaseConnectorCP(registry, vaultId, swapHandler, noyaOracle));
        balancerFlashLoan = new BalancerFlashLoan(balancerVault, registry);
        registry.setFlashLoanAddress(address(balancerFlashLoan));

        console.log("SiloConnector deployed: %s", address(connector));

        addConnectorToRegistry(vaultId, address(connector));

        addTrustedTokens(vaultId, address(accountingManager), WETH);
        addTrustedTokens(vaultId, address(accountingManager), XAI);
        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTrustedTokens(vaultId, address(accountingManager), USDT);
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

        registry.addTrustedPosition(
            vaultId, connector.SILO_LP_ID(), address(connector), true, false, abi.encode(USDT), ""
        );
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDT), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(CRVUSD), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(WETH), "");

        addTokenToChainlinkOracle(address(WETH), address(840), address(WETH_USD_FEED));
        addTokenToNoyaOracle(address(WETH), address(chainlinkOracle));

        console.log("Positions added to registry");
    }

    function test_depositAndBorrow2() public {
        console.log("----------- deposit -----------");
        uint256 _amount = 10_000 * 1e6;

        _dealWhale(baseToken, address(connector), USDC_Whale, _amount);
        _dealERC20(USDT, address(connector), 10_000 * 1e18);
        vm.startPrank(address(owner));

        connector.deposit(USDC, USDC, _amount, true);
        connector.borrow(USDC, WETH, 18e17);

        address[] memory callAddresses = new address[](4);
        bytes[] memory callDatas = new bytes[](4);
        uint256[] memory gasAmounts = new uint256[](4);

        IERC20[] memory assets = new IERC20[](1);
        assets[0] = IERC20(WETH);
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 18e17;

        callAddresses[0] = address(connector);
        callDatas[0] = abi.encodeWithSelector(connector.repay.selector, USDC, WETH, 18e17 + 1);
        gasAmounts[0] = type(uint256).max;

        callAddresses[1] = address(connector);
        callDatas[1] = abi.encodeWithSelector(connector.withdraw.selector, USDC, USDC, _amount, true, true);
        gasAmounts[1] = type(uint256).max;

        callAddresses[2] = address(connector);
        callDatas[2] = abi.encodeWithSelector(connector.deposit.selector, USDT, USDT, 10_000 * 1e18, true);
        gasAmounts[2] = type(uint256).max;

        callAddresses[3] = address(connector);
        callDatas[3] = abi.encodeWithSelector(connector.borrow.selector, USDT, WETH, 18e17);
        gasAmounts[3] = type(uint256).max;

        bytes memory flashLoanData = abi.encode(vaultId, address(connector), callAddresses, callDatas, gasAmounts);
        balancerFlashLoan.makeFlashLoan(assets, amounts, flashLoanData);

        vm.stopPrank();
    }
}
