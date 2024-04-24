// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IERC20 } from "@openzeppelin/contracts-5.0/interfaces/IERC20.sol";

interface IDepositToken is IERC20 {
    function deposit(address receiver, uint256 amount) external returns (bool);

    function withdraw(address receiver, uint256 amount) external returns (bool);

    function lpToken() external view returns (address);

    function claimReward(address) external returns (uint256, uint256, uint256);
}
