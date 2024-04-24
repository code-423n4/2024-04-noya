    // SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.20;

import "./IStargateLPStaking.sol";

interface IStargatePool {
    function amountLPtoLD(uint256 _amountLP) external view returns (uint256);

    function token() external view returns (address);
}

interface IStargateRouter {
    function addLiquidity(uint256 _poolId, uint256 _amountLD, address _to) external;

    function instantRedeemLocal(uint16 _srcPoolId, uint256 _amountLP, address _to) external returns (uint256);
}
