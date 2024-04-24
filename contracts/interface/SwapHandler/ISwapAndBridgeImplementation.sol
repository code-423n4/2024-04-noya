// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./ILiFi.sol";

struct SwapRequest {
    address from;
    uint256 routeId;
    uint256 amount;
    address inputToken;
    address outputToken;
    bytes data;
    bool checkForSlippage;
    uint256 minAmount;
}

struct BridgeRequest {
    uint256 destChainId;
    address from;
    uint256 routeId;
    uint256 amount;
    address inputToken;
    address receiverAddress;
    bytes data;
}

interface ISwapAndBridgeImplementation {
    // ------------------------- Events ------------------------- //

    event Forwarded(address lifi, address token, uint256 amount, bytes data);
    event Swapped(uint256 amountIn, uint256 amountOut, address toToken);

    // ------------------------- Errors ------------------------- //

    error SpenderIsInvalid();
    error FailedToForward(bytes);
    error InvalidSelector();
    error InvalidReceiver(address receiverInData, address receiverInRequest);
    error InvalidBridge();
    error InvalidMinAmount();
    error InvalidInputToken();
    error InvalidOutputToken();
    error InvalidAmount();

    error BridgeBlacklisted();
    error InvalidChainId();
    error InvalidFromToken();
    error InvalidToChainId();

    function performSwapAction(address caller, SwapRequest calldata _request) external payable returns (uint256);

    function verifySwapData(SwapRequest calldata _request) external view returns (bool);

    function performBridgeAction(address caller, BridgeRequest calldata _request) external payable;

    function verifyBridgeData(BridgeRequest calldata _request) external view returns (bool);
}
