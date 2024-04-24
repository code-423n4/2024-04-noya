// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import { LZHelperSender } from "contracts/helpers/LZHelpers/LZHelperSender.sol";
import { LZHelperReceiver } from "contracts/helpers/LZHelpers/LZHelperReceiver.sol";
import "contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol";
import "contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol";
import "./utils/mocks/LZEndpointMock.sol";

import "./utils/testStarter.sol";
import "./utils/resources/OptimismAddresses.sol";
import { OptionsBuilder } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";
import "./utils/mocks/bridgeImplementationMock.sol";

contract TestOmnichain is testStarter, OptimismAddresses {
    using OptionsBuilder for bytes;

    LZHelperSender lzHelperSender;
    LZHelperReceiver lzHelperReceiver;
    EndpointV2Mock lzEndpointMockA;
    EndpointV2Mock lzEndpointMockB;
    OmnichainManagerNormalChain omnichainManagerNormalChain;
    OmnichainManagerBaseChain omnichainManagerBaseChain;
    PositionRegistry registryB;

    BridgeImplementationMock bridgeImplementationMock;

    function setUp() public {
        console.log("----------- Initialization -----------");
        // --------------------------------- set env --------------------------------
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);
        deployEverythingNormal(USDC);

        lzEndpointMockA = new EndpointV2Mock(1);
        lzEndpointMockB = new EndpointV2Mock(2);
        lzHelperSender = new LZHelperSender(address(lzEndpointMockA), owner);
        lzHelperReceiver = new LZHelperReceiver(address(lzEndpointMockB), owner);
        registryB = new PositionRegistry(owner, owner, owner, address(0));

        omnichainManagerNormalChain = new OmnichainManagerNormalChain(
            payable(address(lzHelperSender)), BaseConnectorCP(registryB, vaultId, swapHandler, noyaOracle)
        );
        omnichainManagerBaseChain = new OmnichainManagerBaseChain(
            1e3, payable(address(lzHelperReceiver)), BaseConnectorCP(registry, vaultId, swapHandler, noyaOracle)
        );

        addConnectorToRegistry(vaultId, address(omnichainManagerBaseChain));
        console.log("registry NormalChain deployed: %s", address(registryB));

        console.log("OmnichainManagerNormalChain deployed: %s", address(omnichainManagerNormalChain));
        console.log("OmnichainManagerBaseChain deployed: %s", address(omnichainManagerBaseChain));
        registryB.addVault(
            vaultId,
            address(omnichainManagerNormalChain),
            baseToken,
            owner,
            owner,
            owner,
            owner,
            address(watchers),
            owner,
            new address[](0)
        );
        address[] memory trustedTokens = new address[](1);
        trustedTokens[0] = baseToken;
        registryB.updateConnectorTrustedTokens(vaultId, address(omnichainManagerNormalChain), trustedTokens, true);
        registryB.addTrustedPosition(
            vaultId, 0, address(omnichainManagerNormalChain), false, false, abi.encode(baseToken), ""
        );
        registryB.addTrustedPosition(
            vaultId, 10, address(omnichainManagerNormalChain), false, false, abi.encode(baseToken), ""
        );
        lzEndpointMockA.setDestLzEndpoint(address(lzHelperReceiver), address(lzEndpointMockB));
        lzEndpointMockB.setDestLzEndpoint(address(lzHelperSender), address(lzEndpointMockA));
        lzHelperSender.addVaultInfo(vaultId, block.chainid, address(omnichainManagerNormalChain));
        vm.expectRevert();
        lzHelperSender.setChainInfo(block.chainid, 1, address(0));
        lzHelperSender.setChainInfo(block.chainid, 1, address(lzHelperReceiver));
        vm.expectRevert();
        lzHelperReceiver.addVaultInfo(vaultId, block.chainid, address(0));
        lzHelperReceiver.addVaultInfo(vaultId, block.chainid, address(omnichainManagerBaseChain));
        lzHelperReceiver.setChainInfo(block.chainid, 1, address(lzHelperSender));

        lzHelperSender.setPeer(1, bytes32(uint256(uint160(address(lzHelperReceiver)))));
        lzHelperReceiver.setPeer(1, bytes32(uint256(uint160(address(lzHelperSender)))));

        lzHelperSender.updateMessageSetting(createLzReceiveOption(1e6, 0));

        addTrustedTokens(vaultId, address(accountingManager), baseToken);
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(baseToken), "");
        registry.addTrustedPosition(
            vaultId,
            omnichainManagerBaseChain.OMNICHAIN_POSITION_ID(),
            address(omnichainManagerBaseChain),
            false,
            false,
            abi.encode(10),
            ""
        );

        vm.deal(address(lzHelperSender), 10 ether);

        bridgeImplementationMock = new BridgeImplementationMock();

        RouteData[] memory _routeData = new RouteData[](1);
        _routeData[0].route = address(bridgeImplementationMock);
        _routeData[0].isEnabled = true;
        _routeData[0].isBridge = true;

        swapHandler.addRoutes(_routeData);
    }

    function testMessaging() public {
        console.log("----------- Messaging -----------");
        assertEq(omnichainManagerNormalChain.getTVL(), 0, "TVL should be 0");
        uint256 _amount = 100_000_000;
        _dealWhale(baseToken, address(omnichainManagerNormalChain), USDC_Whale, _amount);
        vm.startPrank(owner);
        console.log(address(omnichainManagerNormalChain.registry()));
        (,,, address keeperContract,, address emergencyManager) = registryB.getGovernanceAddresses(vaultId);
        console.log("keeperContract: %s", keeperContract);

        omnichainManagerNormalChain.updateTokenInRegistry(baseToken);
        assertEq(omnichainManagerNormalChain.getTVL(), _amount, "TVL should be _amount");
        omnichainManagerNormalChain.updateTVLInfo();

        vm.expectRevert();
        lzHelperSender.updateTVL(1, 10, 0);

        vm.expectRevert();
        omnichainManagerBaseChain.updateTVL(1, 10, 0);

        omnichainManagerBaseChain.getPositionTVL(
            HoldingPI({
                positionId: registryB.calculatePositionId(address(accountingManager), 0, abi.encode(baseToken)),
                data: hex"",
                additionalData: "",
                positionTimestamp: 0,
                calculatorConnector: address(omnichainManagerBaseChain),
                ownerConnector: address(accountingManager)
            }),
            address(baseToken)
        );

        omnichainManagerNormalChain.getPositionTVL(
            HoldingPI({
                positionId: registryB.calculatePositionId(address(omnichainManagerNormalChain), 10, abi.encode(baseToken)),
                data: hex"",
                additionalData: "",
                positionTimestamp: 0,
                calculatorConnector: address(omnichainManagerNormalChain),
                ownerConnector: address(omnichainManagerNormalChain)
            }),
            address(baseToken)
        ); // Covered coverage bug number 70
        console.log("----------- accountinmanager tvl ----------- %s", accountingManager.TVL());
        assertEq(accountingManager.TVL(), _amount, "TVL should be _amount");
        vm.stopPrank();
    }

    function testOmnichain() public {
        console.log("----------- Test Bridging -----------");
        uint256 _amount = 100_000_000;
        _dealWhale(baseToken, address(omnichainManagerBaseChain), USDC_Whale, _amount);
        vm.startPrank(owner);
        BridgeRequest memory request = BridgeRequest(
            10, address(omnichainManagerBaseChain), 2, _amount, baseToken, address(omnichainManagerNormalChain), ""
        );
        vm.expectRevert();
        omnichainManagerBaseChain.startBridgeTransaction(request);
        omnichainManagerBaseChain.updateBridgeTransactionApproval(keccak256(abi.encode(request)));
        omnichainManagerBaseChain.updateBridgeTransactionApproval(keccak256(abi.encode(request)));
        omnichainManagerBaseChain.updateBridgeTransactionApproval(keccak256(abi.encode(request)));

        vm.expectRevert();
        omnichainManagerBaseChain.startBridgeTransaction(request);

        vm.warp(block.timestamp + 31 minutes);
        vm.expectRevert();
        omnichainManagerBaseChain.startBridgeTransaction(request);

        vm.expectRevert();
        omnichainManagerBaseChain.updateChainInfo(10, address(0));

        omnichainManagerBaseChain.updateChainInfo(10, address(omnichainManagerNormalChain));

        request.from = address(owner);
        omnichainManagerBaseChain.updateBridgeTransactionApproval(keccak256(abi.encode(request)));
        vm.warp(block.timestamp + 31 minutes);

        vm.expectRevert();
        omnichainManagerBaseChain.startBridgeTransaction(request); // Covered coverage bug number 69

        request.from = address(omnichainManagerBaseChain);

        omnichainManagerBaseChain.startBridgeTransaction(request);

        // vm.stopPrank();
    }

    function createLzReceiveOption(uint128 _gas, uint128 _value) public pure returns (bytes memory) {
        return OptionsBuilder.newOptions().addExecutorLzReceiveOption(_gas, _value);
    }
}
