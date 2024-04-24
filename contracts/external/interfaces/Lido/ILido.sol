// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IERC20Permit } from "@openzeppelin/contracts-5.0/token/ERC20/extensions/IERC20Permit.sol";
import { IERC20 } from "@openzeppelin/contracts-5.0/interfaces/IERC20.sol";

interface ILido is IERC20Permit, IERC20 {
    function submit(address _refferal) external payable returns (uint256);
}
