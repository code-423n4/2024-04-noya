// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "contracts/connectors/SNXConnector.sol";
import "contracts/helpers/valueOracle/oracles/WETH_Oracle.sol";

import "./utils/resources/MainnetAddresses.sol";

contract TestSNXV3Connector is testStarter, MainnetAddresses {
    SNXV3Connector connector;

    function setUp() public {
        console.log("----------- Initialization -----------");
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);
        deployEverythingNormal(USDC);

        connector = new SNXV3Connector(SNXv3Core, BaseConnectorCP(registry, vaultId, swapHandler, noyaOracle));

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

        // registry.addTrustedPosition(
        //     vaultId, connector.SNX_POSITION_ID(), address(connector), true, false, abi.encode(USDC), ""
        // );
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(CRVUSD), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(WETH), "");

        addTokenToChainlinkOracle(address(WETH), address(840), address(WETH_USD_FEED));
        addTokenToNoyaOracle(address(WETH), address(chainlinkOracle));

        console.log("Positions added to registry");
    }

    function test_Data() public {
        // connector.getPreferredPool();
    }
}
