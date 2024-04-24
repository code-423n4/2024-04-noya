// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

interface ITokenTransferCallBack {
    function sendTokensToTrustedAddress(address token, uint256 amount, address caller, bytes calldata data)
        external
        returns (uint256);
}
