// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IBalancerPool {
    function getPoolId() external view returns (bytes32);

    function getNormalizedWeights() external returns (uint256[] memory);

    function totalSupply() external returns (uint256);
}
