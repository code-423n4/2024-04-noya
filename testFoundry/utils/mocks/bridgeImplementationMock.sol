// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "contracts/interface/SwapHandler/ISwapAndBridgeImplementation.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "contracts/interface/ITokenTransferCallBack.sol";

contract BridgeImplementationMock is ISwapAndBridgeImplementation {
    using SafeERC20 for IERC20;

    function performSwapAction(address caller, SwapRequest calldata _request)
        external
        payable
        override
        returns (uint256)
    {
        revert("BridgeImplementationMock: performSwapAction not implemented");
    }

    function verifySwapData(SwapRequest calldata _request) external view override returns (bool) {
        return true;
    }

    function performBridgeAction(address caller, BridgeRequest calldata _request) external payable override {
        address from = _request.from;
        uint256 routeId = _request.routeId;
        uint256 amount = _request.amount;
        IERC20 token = IERC20(_request.inputToken);
        ITokenTransferCallBack(from).sendTokensToTrustedAddress(address(token), amount, caller, abi.encode(routeId));
        token.safeTransfer(_request.receiverAddress, amount);
    }

    function verifyBridgeData(BridgeRequest calldata _request) external view override returns (bool) {
        return true;
    }
}
