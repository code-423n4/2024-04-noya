// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "./utils/resources/BaseAddresses.sol";
import "contracts/connectors/AerodromeConnector.sol";

contract TestAerodromeConnector is testStarter, BaseAddresses {
    AerodromeConnector connector;

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
        connector = new AerodromeConnector(
            aerodromeRouter, aerodromeVoter, BaseConnectorCP(registry, 0, swapHandler, noyaOracle)
        );

        console.log("AerodromeConnector deployed: %s", address(connector));

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
        registry.addTrustedPosition(
            vaultId,
            connector.AERODROME_POSITION_TYPE(),
            address(connector),
            true,
            false,
            abi.encode(aerodrome_USDC_DAI_Pool),
            ""
        );
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        console.log("Positions added to registry");
        vm.stopPrank();
    }

    function testDeposit() public {
        console.log("-----------Aerodrome Deposit Flow--------------");
        uint256 _amountUSDC = 85e6;
        uint256 _amountDAI = 100e18;
        _dealWhale(baseToken, address(connector), USDC_Whale, _amountUSDC);
        _dealERC20(DAI, address(connector), _amountDAI);
        vm.startPrank(owner);
        connector.supply(DepositData(aerodrome_USDC_DAI_Pool, _amountDAI, _amountUSDC, 0, 0, block.timestamp + 1));

        uint256 _tvl = accountingManager.TVL();
        console.log("TVL %s", _tvl);
        assertTrue(isCloseTo(_tvl, 185e6, 100), "testDeposit: E1");
        uint256 _balance = IERC20(aerodrome_USDC_DAI_Pool).balanceOf(address(connector));

        connector.withdraw(WithdrawData(aerodrome_USDC_DAI_Pool, _balance / 2, 0, 0, block.timestamp + 1));
        _balance = IERC20(aerodrome_USDC_DAI_Pool).balanceOf(address(connector));

        connector.withdraw(WithdrawData(aerodrome_USDC_DAI_Pool, _balance, 0, 0, block.timestamp + 1)); // Cover coverage bug number 13

        _tvl = accountingManager.TVL();
        console.log("TVL %s", _tvl);
        assertTrue(isCloseTo(_tvl, 185e6, 100), "testDeposit: E1");

        vm.stopPrank();
    }

    // function testDepositError() public {
    //     console.log("-----------Aerodrome Deposit Flow--------------");
    //     uint256 _amountUSDC = 85e6;
    //     uint256 _amountDAI = 100e18;
    //     _dealWhale(baseToken, address(connector), USDC_Whale, _amountUSDC);
    //     _dealERC20(DAI, address(connector), _amountDAI);
    //     vm.startPrank(owner);
    //     vm.expectRevert();
    //     connector.supply(aerodrome_USDC_DAI_Pool, _amountDAI, _amountUSDC, 0,0,);
    // }
}
