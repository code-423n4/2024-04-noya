// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./Keepers.sol";

contract Watchers is Keepers {
    constructor(address[] memory _owners, uint8 _threshold) Keepers(_owners, _threshold) { }
    function verifyRemoveLiquidity(uint256 withdrawAmount, uint256 sentAmount, bytes memory data) external view { }
}
