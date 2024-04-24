// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "contracts/helpers/BaseConnector.sol";
import "contracts/accountingManager/NoyaFeeReceiver.sol";
import "./utils/resources/OptimismAddresses.sol";
import "contracts/governance/Keepers.sol";

contract TestAccountingBranches is testStarter, OptimismAddresses {
    using SafeERC20 for IERC20;

    address connector;
    NoyaFeeReceiver managementFeeReceiver;
    NoyaFeeReceiver performanceFeeReceiver;
    address withdrawFeeReceiver = bob;

    uint256 privateKey1 = 0x99ba14aff4aba765903a41b48aacdf600b6fcdb2b0c2424cd2f8f2c089f20476;
    uint256 privateKey2 = 0x68ab62e784b873b929e98fc6b6696abcc624cf71af05bf8d88b4287e9b58ab99;
    uint256 privateKey3 = 0x952b55e8680117e6de5bde1d3e7902baa89bfde931538a5bb42ba392ef3464a4;
    uint256 privateKey4 = 0x885f1d08ebc23709517fedbec64418e4a09ac1e47e976c868fd8c93de0f88f09;

    function setUp() public {
        // --------------------------------- set env --------------------------------
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);

        deployEverythingNormal(USDC);

        // --------------------------------- init connector ---------------------------------
        connector = address(new BaseConnector(BaseConnectorCP(registry, 0, swapHandler, noyaOracle)));

        // ------------------- add connector to registry -------------------
        addConnectorToRegistry(vaultId, connector);
        console.log("AaveConnector added to registry");

        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTrustedTokens(vaultId, address(accountingManager), DAI);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        console.log("Tokens added to registry");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        console.log("Positions added to registry");

        managementFeeReceiver = new NoyaFeeReceiver(address(accountingManager), baseToken, owner);
        performanceFeeReceiver = new NoyaFeeReceiver(address(accountingManager), baseToken, owner);

        accountingManager.updateValueOracle(noyaOracle);
        vm.stopPrank();
    }

    function testAccountingBranches() public {
        // --------------------------------- deploy the contracts ---------------------------------
        uint256 _amount = 10e6;
        _dealWhale(baseToken, address(accountingManager), USDC_Whale, _amount);

        vm.startPrank(owner);

        // ------------------- add connector to registry -------------------

        accountingManager.sendTokensToTrustedAddress(USDC, _amount, owner, "");

        addConnectorToRegistry(vaultId, owner);

        accountingManager.sendTokensToTrustedAddress(USDC, _amount, owner, "");

        assertEq(IERC20(USDC).balanceOf(owner), _amount);
    }

    function testAccountingPositionTVL() public {
        vm.startPrank(owner);
        addConnectorToRegistry(vaultId, owner);
        registry.addTrustedPosition(vaultId, 15, address(accountingManager), false, false, abi.encode(USDC), "");

        accountingManager.getPositionTVL( //// Covered coverage bug number 5
            HoldingPI({
                calculatorConnector: address(accountingManager),
                positionId: registry.calculatePositionId(address(accountingManager), 15, abi.encode(USDC)),
                ownerConnector: address(accountingManager),
                data: "",
                additionalData: "",
                positionTimestamp: 0
            }),
            address(USDC)
        );
    }

    function testAccountingERC4625Functions() public {
        vm.startPrank(owner);
        vm.expectRevert();
        accountingManager.withdraw(10, owner, owner);
        vm.startPrank(owner);
        vm.expectRevert();
        accountingManager.mint(10, owner);
        vm.startPrank(owner);
        vm.expectRevert();
        accountingManager.redeem(10, owner, owner);
        vm.startPrank(owner);
        vm.expectRevert();
        accountingManager.deposit(10, owner);
    }
}
