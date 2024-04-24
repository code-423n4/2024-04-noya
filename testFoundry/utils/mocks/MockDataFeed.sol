// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import { AggregatorV3Interface } from "contracts/interface/valueOracle/AggregatorV3Interface.sol";

contract MockData {
    int256 public mockAnswer;
    uint256 public mockUpdatedAt;
    uint256 public constant decimals = 1e8;

    constructor() { }

    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        roundId = 0;
        answer = mockAnswer;
        startedAt = 0;
        updatedAt = mockUpdatedAt;
        answeredInRound = 0;
    }

    function latestAnswer() external view returns (int256 answer) {
        answer = mockAnswer;
    }

    function setAnswer(int256 ans, uint256 time) external {
        mockAnswer = ans;
        mockUpdatedAt = time;
    }
}
