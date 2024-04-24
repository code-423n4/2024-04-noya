// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

interface ILiFi {
    /// Structs ///

    struct BridgeData {
        bytes32 transactionId;
        string bridge;
        string integrator;
        address referrer;
        address sendingAssetId;
        address receiver;
        uint256 minAmount;
        uint256 destinationChainId;
        bool hasSourceSwaps;
        bool hasDestinationCall;
    }

    struct SwapData {
        address callTo;
        address approveTo;
        address sendingAssetId;
        address receivingAssetId;
        uint256 fromAmount;
        bytes callData;
        bool requiresDeposit;
    }

    function extractBridgeData(bytes calldata data) external pure returns (BridgeData memory bridgeData);

    function extractGenericSwapParameters(bytes calldata data)
        external
        pure
        returns (address, uint256, address, address, uint256);
}
