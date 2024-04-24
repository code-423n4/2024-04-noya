// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/governance/TimelockController.sol";

contract NoyaTimeLock is TimelockController {
    constructor(uint256 minDelay, address[] memory proposers, address[] memory executors, address owner)
        TimelockController(minDelay, proposers, executors, owner)
    { }
}
