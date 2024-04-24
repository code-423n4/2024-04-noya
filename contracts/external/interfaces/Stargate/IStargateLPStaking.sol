// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.20;

struct UserInfo {
    uint256 amount; // How many LP tokens the user has provided.
    uint256 rewardDebt; // Reward debt. See explanation below.
}
// Info of each pool.

struct PoolInfo {
    address lpToken; // Address of LP token contract.
    uint256 allocPoint; // How many allocation points assigned to this pool, to distribute per block.
    uint256 lastRewardTime; // Last time that distribution occurs.
    uint256 accEmissionPerShare; // Accumulated Emissions per share, times 1e12. See below.
}

interface IStargateLPStaking {
    function stargate() external view returns (address);

    function poolInfo(uint256 _pid) external view returns (PoolInfo memory);

    function userInfo(uint256 _pid, address _user) external view returns (UserInfo memory);

    function pendingEmissionToken(uint256 _pid, address _user) external view returns (uint256);

    function deposit(uint256 _pid, uint256 _amount) external;

    function withdraw(uint256 _pid, uint256 _amount) external;

    function emergencyWithdraw(uint256 _pid) external;
}
