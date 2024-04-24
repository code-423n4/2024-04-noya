// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

contract WETH_Oracle {
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (0, 1e18, 0, block.timestamp, 0);
    }
}
