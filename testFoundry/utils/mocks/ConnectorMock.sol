// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import {
    SwapAndBridgeHandler,
    SwapRequest,
    BridgeRequest
} from "contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol";

contract ConnectorMock {
    using SafeERC20 for IERC20;

    receive() external payable { }
    fallback() external payable { }
    constructor() { }

    /**
     * @notice Sends tokens to a trusted address
     * @param token The token address
     * @param amount The amount of tokens to send
     * @param caller The caller address (used to verify the caller is this contract in the swapHandler)
     * @param data Additional data used in the transfer
     * @return The actual amount of tokens sent
     * @dev This function is used to send tokens to trusted addresses (vault, accounting manager, swap handler)
     * @dev in case the caller is the accounting manager, the function will check with the watcher contract the number of tokens to withdraw
     * @dev in case the caller is a connector, the function will check if the caller is an active connector
     * @dev in case the caller is the swap handler, the function will check if the caller is a valid route
     */
    function sendTokensToTrustedAddress(address token, uint256 amount, address caller, bytes memory data)
        external
        returns (uint256)
    {
        IERC20(token).safeTransfer(msg.sender, amount);
        return amount;
    }

    function swap(
        address swapHandler,
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        bytes memory swapData,
        uint256 routeId
    ) external {
        SwapAndBridgeHandler(swapHandler).executeSwap(
            SwapRequest(address(this), routeId, amountIn, tokenIn, tokenOut, swapData, false, 0)
        );
    }

    function bridge(address swapHandler, BridgeRequest calldata bridgeRequest) external {
        SwapAndBridgeHandler(swapHandler).executeBridge(bridgeRequest);
    }
}
