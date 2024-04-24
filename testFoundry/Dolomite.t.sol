// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/utils/Strings.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";

import "contracts/connectors/Dolomite.sol";
import "./utils/testStarter.sol";
import "./utils/resources/ArbitrumAddresses.sol";

contract TestDolomiteConnector is testStarter, ArbitrumAddresses {
    // using SafeERC20 for IERC20;

    DolomiteConnector connector;

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
        connector = new DolomiteConnector(
            depositWithdrawalProxy,
            dolomiteMargin,
            BorrowPositionProxy,
            BaseConnectorCP(registry, 0, swapHandler, noyaOracle)
        );

        console.log("DolomiteConnector deployed: %s", address(connector));
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
        registry.addTrustedPosition(vaultId, connector.DOL_POSITION_ID(), address(connector), true, false, "", "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        console.log("Positions added to registry");
        vm.stopPrank();
    }

    // scenario: deposit to Aave
    // 1. deposit to Aave
    // 2. check TVL
    function testDolomitDepositFlow() public {
        console.log("-----------Aave Deposit Flow--------------");
        uint256 _amount = 200 * 1e18;
        _dealERC20(DAI, address(connector), _amount);
        vm.startPrank(address(owner));

        connector.deposit(1, _amount);

        uint256 t = accountingManager.TVL();
        console.log("TVL: %s", t);

        connector.withdraw(1, _amount / 2);
        connector.withdraw(1, _amount / 2);
    }
}
