// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IERC20 } from "@openzeppelin/contracts-5.0/interfaces/IERC20.sol";

interface IBorrowerOperations {
    struct TroveManagerData {
        address collateralToken;
        uint16 index;
    }

    function addColl(address, address, uint256, address, address) external;

    function openTrove(address, address, uint256, uint256, uint256, address, address) external;

    function closeTrove(address troveManager, address account) external;

    function adjustTrove(address, address, uint256, uint256, uint256, uint256, bool, address, address) external;

    function setDelegateApproval(address _delegate, bool _isApproved) external;

    function troveManagersData(address troveManager) external view returns (TroveManagerData memory);
}
