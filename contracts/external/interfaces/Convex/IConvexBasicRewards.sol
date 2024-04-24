// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./IBooster.sol";

interface IConvexBasicRewards {
    struct EarnedData {
        address token;
        uint256 amount;
    }

    function stakeFor(address, uint256) external returns (bool);

    function balanceOf(address) external view returns (uint256);

    function earned(address) external view returns (uint256);

    function getReward(address _account, bool _claimExtras) external returns (bool);

    function withdrawAll(bool) external returns (bool);

    function withdraw(uint256, bool) external returns (bool);

    function withdrawAndUnwrap(uint256, bool) external returns (bool);

    function getReward() external returns (bool);

    function stake(uint256) external returns (bool);
}
