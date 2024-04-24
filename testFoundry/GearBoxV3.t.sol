// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "./utils/resources/MainnetAddresses.sol";

import "contracts/connectors/GearBoxV3.sol";

contract TestGearBox is testStarter, MainnetAddresses {
    Gearboxv3 connector;

    address public usdtCreditManager = 0x3EB95430FdB99439A86d3c6D7D01C3c561393556;
    address public creditFacade = 0x958cBC4AEA076640b5D9019c61e7F78F4F682c0C;

    function setUp() public {
        console.log("----------- Initialization -----------");
        // --------------------------------- set env ---------------------------------
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);
        deployEverythingNormal(USDC);

        connector = new Gearboxv3(BaseConnectorCP(registry, vaultId, swapHandler, noyaOracle));

        console.log("GearBoxV3 deployed: %s", address(connector));

        addConnectorToRegistry(vaultId, address(connector));

        // --------------------------------- set trusted tokens ---------------------------------

        addTrustedTokens(vaultId, address(accountingManager), USDT);

        registry.addTrustedPosition(0, 0, address(accountingManager), false, false, abi.encode(USDT), "");
        registry.addTrustedPosition(
            0, connector.GEARBOX_POSITION_ID(), address(connector), false, false, abi.encode(creditFacade), ""
        );
        vm.stopPrank();
    }

    function testOpenAndCloseFlow() public {
        vm.startPrank(owner);
        connector.openAccount(creditFacade, 0);
        vm.roll(block.number + 1);

        connector.closeAccount(creditFacade, address(0x581B66D4568fc6591af17D0295e48c874E904E97));
        vm.stopPrank();
    }

    function testDepositFlow() public {
        _dealERC20(USDT, owner, 100_000_000);
        _dealERC20(USDT, address(connector), 100_000_000);
        vm.startPrank(owner);
        connector.openAccount(creditFacade, 0);
        // vm.roll(block.number + 1);

        MultiCall[] memory calls = new MultiCall[](1);
        calls[0] = MultiCall(
            creditFacade, abi.encodeWithSelector(ICreditFacadeV3Multicall.addCollateral.selector, USDT, 10_000)
        );

        uint256 usdtBalance = IERC20(USDT).balanceOf(address(connector));
        connector.executeCommands(
            creditFacade, address(0x581B66D4568fc6591af17D0295e48c874E904E97), calls, address(USDT), 100_000_000
        ); // Covered coverage bug number 59

        uint256 usdtBalanceAfter = IERC20(USDT).balanceOf(address(connector));
        console.log("USDT Balance: %s", usdtBalance - usdtBalanceAfter);

        vm.expectRevert();
        connector.executeCommands(
            address(connector), address(0x581B66D4568fc6591af17D0295e48c874E904E97), calls, address(USDT), 100_000_000
        );

        uint256 tvl = accountingManager.TVL();
        console.log("TVL 2: %s", tvl);
        vm.stopPrank();
    }

    function testEnableFlow() public {
        _dealERC20(USDT, owner, 100_000_000);
        _dealERC20(USDT, address(connector), 100_000_000);
        vm.startPrank(owner);
        connector.openAccount(creditFacade, 0);
        // vm.roll(block.number + 1);

        MultiCall[] memory calls = new MultiCall[](1);
        calls[0] = MultiCall(creditFacade, abi.encodeWithSelector(ICreditFacadeV3Multicall.enableToken.selector, USDT));

        connector.executeCommands(
            creditFacade, address(0x581B66D4568fc6591af17D0295e48c874E904E97), calls, address(0), 0
        ); // Covered coverage bug number 59
    }
}
