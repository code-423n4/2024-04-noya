//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

interface IveMAV {
    function stake(uint256 amount, uint256 duration, bool doDelegation) external;

    function unstake(uint256 lockupId) external;

    function balanceOf(address account) external view returns (uint256);
}
