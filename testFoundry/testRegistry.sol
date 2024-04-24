pragma solidity ^0.8.20;

import "./utils/testStarter.sol";
import "./utils/resources/OptimismAddresses.sol";
import "./utils/mocks/ConnectorMock2.sol";

contract TestRegistry is testStarter, OptimismAddresses {
    function setUp() public {
        console.log("----------- Initialization -----------");
        // --------------------------------- set env ---------------------------------
        string memory OPT_RPC_URL = "https://optimism-mainnet.infura.io/v3/6175c5e376b9460eaa23997ac6eccabc";

        uint256 optFork = vm.createFork(OPT_RPC_URL, 116_357_148);
        vm.selectFork(optFork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- set accounts ---------------------------------
        owner = address(0xB54c2435Dc58Fd6F172BecEe6B2F95b9423f9E79);
        alice = address(0xE9DD92FeC168e0b4FCffEEf6F602E5575E8F12b4);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);

        deployEverythingNormal(USDC);

        // ------------------- addTokensToSupplyOrBorrow -------------------
        address[] memory tokens = new address[](2);
        tokens[0] = address(USDC);
        tokens[1] = DAI;
        registry.updateConnectorTrustedTokens(0, address(accountingManager), tokens, true);
        console.log("Tokens added to registry");
        vm.stopPrank();
    }

    function testRegistry() public {
        console.log("----------- Test Registry -----------");
        vm.startPrank(owner);

        HoldingPI[] memory positions = registry.getHoldingPositions(0);
        console.log("Positions: %s", positions.length);
        address[] memory tokens = new address[](2);
        tokens[0] = address(USDC);
        tokens[1] = DAI;
        registry.addVault(
            10, address(accountingManager), baseToken, owner, owner, owner, owner, address(watchers), owner, tokens
        );

        vm.expectRevert();
        registry.addVault(
            12, address(accountingManager), address(0), owner, owner, owner, owner, address(watchers), owner, tokens
        );

        vm.expectRevert();
        registry.addVault(
            12, address(accountingManager), baseToken, address(0), owner, owner, owner, address(watchers), owner, tokens
        );

        vm.expectRevert();
        registry.addVault(
            12, address(accountingManager), baseToken, owner, address(0), owner, owner, address(watchers), owner, tokens
        );

        vm.expectRevert();
        registry.addVault(
            12, address(accountingManager), baseToken, owner, owner, owner, address(0), address(watchers), owner, tokens
        );

        vm.expectRevert();
        registry.addVault(12, address(0), baseToken, owner, owner, owner, owner, address(watchers), owner, tokens);

        vm.expectRevert();
        registry.addVault(
            12, address(accountingManager), baseToken, owner, owner, owner, owner, address(0), owner, tokens
        );

        registry.addTrustedPosition(10, 15, address(accountingManager), false, false, abi.encode(USDC), "");
        console.log("getToken trusted", registry.isTokenTrusted(10, USDT, address(accountingManager)));
        vm.expectRevert();
        registry.addTrustedPosition(10, 0, address(accountingManager), false, false, abi.encode(USDT), "");
        registry.addTrustedPosition(10, 16, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(10, 0, address(accountingManager), true, false, abi.encode(DAI), "");

        vm.expectRevert();
        registry.addTrustedPosition(10, 15, address(accountingManager), false, false, abi.encode(USDC), "");

        registry.removeTrustedPosition(
            10, registry.calculatePositionId(address(accountingManager), 15, abi.encode(USDC))
        );

        bytes32 positionId = registry.calculatePositionId(address(accountingManager), 23, abi.encode(USDC));
        vm.expectRevert();
        registry.removeTrustedPosition(10, positionId);

        positionId = registry.calculatePositionId(address(accountingManager), 16, abi.encode(USDC));
        bytes32 positionId2 = registry.calculatePositionId(address(accountingManager), 0, abi.encode(DAI));
        bytes32 positionId3 = registry.calculatePositionId(address(accountingManager), 3, abi.encode(DAI));

        vm.expectRevert();
        uint256 index = registry.updateHoldingPosition(10, positionId, "", "", true);

        addConnectorToRegistry(10, owner);

        vm.expectRevert();
        registry.updateHoldingPosition(10, positionId3, "", "", false);

        index = registry.updateHoldingPosition(10, positionId, "", "", true);
        assertEq(index, type(uint256).max);
        console.log(
            "get position trusted", registry.isPositionTrustedForConnector(10, positionId2, address(accountingManager))
        );
        console.log("get position trusted", registry.isPositionTrustedForConnector(10, positionId2, address(owner)));

        vm.expectRevert();
        index = registry.updateHoldingPosition(10, positionId2, "", "", false);

        registry.updateHoldingPosition(10, positionId, "", "", false);

        HoldingPI memory info = registry.getHoldingPosition(10, 1);

        assertEq(info.positionId, positionId);

        assertEq(registry.isPositionTrusted(10, positionId), true);

        vm.expectRevert();
        registry.removeTrustedPosition(10, positionId);

        address[] memory connectors = new address[](1);
        connectors[0] = address(accountingManager);
        bool[] memory isTrusted = new bool[](1);
        isTrusted[0] = false;
        registry.addConnector(10, connectors, isTrusted);
        vm.expectRevert();
        registry.addTrustedPosition(10, 0, address(accountingManager), false, false, abi.encode(WETH), "");

        vm.stopPrank();
    }

    function testPositinos() public {
        vm.startPrank(owner);

        address[] memory tokens = new address[](0);
        registry.addVault(
            10, address(accountingManager), baseToken, owner, owner, owner, owner, address(watchers), owner, tokens
        );
        ConnectorMock2 mock = new ConnectorMock2(address(registry), 10);
        addConnectorToRegistry(10, address(mock));
        registry.addTrustedPosition(10, 1, address(mock), false, false, "", "");
        for (uint256 i = 0; i < 19; i++) {
            mock.addPositionToRegistry(abi.encode(i));
        }
        vm.expectRevert();
        mock.addPositionToRegistry("22");

        vm.expectRevert();
        registry.setMaxNumHoldingPositions(45);

        registry.setMaxNumHoldingPositions(24);

        assertEq(registry.maxNumHoldingPositions(), 24);
    }

    function testErrors() public {
        vm.startPrank(owner);

        vm.expectRevert();
        registry.addVault(
            vaultId,
            address(accountingManager),
            baseToken,
            owner,
            owner,
            owner,
            owner,
            address(watchers),
            owner,
            new address[](0)
        );
        vm.expectRevert();
        registry.addVault( // Covered coverage bug number 9
            10,
            address(accountingManager),
            baseToken,
            address(0),
            owner,
            owner,
            owner,
            address(watchers),
            owner,
            new address[](0)
        );
        vm.expectRevert();
        registry.changeVaultAddresses(vaultId, address(0), owner, owner, owner, address(watchers), address(owner)); // Covered coverage bug number 10
        vm.expectRevert();
        registry.changeVaultAddresses(vaultId, owner, address(0), owner, owner, address(watchers), address(owner)); // Covered coverage bug number 10

        vm.expectRevert();
        registry.changeVaultAddresses(vaultId, owner, owner, owner, address(0), address(watchers), address(owner)); // Covered coverage bug number 10

        vm.expectRevert();
        registry.changeVaultAddresses(vaultId, owner, owner, owner, owner, address(0), address(owner)); // Covered coverage bug number 10

        vm.stopPrank();
    }
}
