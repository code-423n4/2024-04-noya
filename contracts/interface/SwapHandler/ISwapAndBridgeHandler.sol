// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./ISwapAndBridgeImplementation.sol";

///@notice RouteData stores information for a route

struct RouteData {
    address route;
    bool isEnabled;
    bool isBridge;
}

interface ISwapAndBridgeHandler {
    //
    // Events
    //
    event NewRouteAdded(uint256 routeID, address route, bool isEnabled, bool isBridge);

    event RouteUpdate(uint256 routeID, bool isEnabled);
    event ExecutionCompleted(
        uint256 routeID, uint256 inputAmount, uint256 outputAmount, address inputToken, address outputToken
    );

    //
    // Errors
    //
    error RouteAlreadyExists();
    error RouteNotFound();
    error invalidAddress();
    error RouteDisabled();
    error SlippageExceedsTolerance();
    error SpenderIsInvalid();
    error InvalidAmount();
    error RouteNotAllowedForThisAction();

    function executeSwap(SwapRequest calldata _swapRequest) external payable returns (uint256 _amountOut);

    function executeBridge(BridgeRequest calldata _bridgeRequest) external payable;

    function routes(uint256 _routeId) external view returns (address route, bool isEnabled, bool isBridge);
}
