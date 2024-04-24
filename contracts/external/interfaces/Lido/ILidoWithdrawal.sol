// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IERC721 } from "@openzeppelin/contracts-5.0/interfaces/IERC721.sol";
import "./ILido.sol";
import "./IWETH.sol";

interface ILidoWithdrawal is IERC721 {
    function requestWithdrawals(uint256[] calldata _amounts, address _owner)
        external
        returns (uint256[] memory requestIds);

    function claimWithdrawal(uint256 _requestId) external;
}
