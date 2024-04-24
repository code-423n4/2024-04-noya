// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "./utils/resources/MainnetAddresses.sol";

import "contracts/connectors/LidoConnector.sol";

contract TestLidoConnector is testStarter, MainnetAddresses {
    LidoConnector connector;

    function setUp() public {
        console.log("----------- Initialization -----------");
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);
        deployEverythingNormal(WETH);

        // --------------------------------- init connector ---------------------------------
        connector =
            new LidoConnector(steth, unstETH, steth, WETH, BaseConnectorCP(registry, vaultId, swapHandler, noyaOracle));
        console.log("LidoConnector deployed: %s", address(connector));

        // ------------------- add connector to registry -------------------
        addConnectorToRegistry(vaultId, address(connector));
        console.log("LidoConnector added to registry");

        addTrustedTokens(vaultId, address(accountingManager), WETH);
        addTrustedTokens(vaultId, address(accountingManager), steth);
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(steth), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(WETH), "");
        registry.addTrustedPosition(
            vaultId, connector.LIDO_WITHDRAWAL_REQUEST_ID(), address(connector), false, false, "", ""
        );

        addTokenToChainlinkOracle(address(steth), address(WETH), address(STETH_ETH_FEED));
        addTokenToNoyaOracle(address(WETH), address(chainlinkOracle));
    }

    function test_depositFlow() public {
        uint256 amount = 100 ether;

        _dealERC20(WETH, address(connector), amount);
        vm.startPrank(owner);

        uint256 stethAmount = IERC20(steth).balanceOf(address(connector));
        connector.deposit(amount);
        uint256 stethAmountAfter = IERC20(steth).balanceOf(address(connector));
        assertTrue(stethAmountAfter > stethAmount);

        connector.requestWithdrawals(stethAmountAfter - stethAmount);

        uint256 tvl = accountingManager.TVL();
        assertTrue(isCloseTo(tvl, amount, 100));
        vm.expectRevert();
        connector.claimWithdrawal(26_847);
    }
}
