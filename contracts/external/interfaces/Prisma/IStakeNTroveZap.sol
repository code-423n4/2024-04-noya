// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IERC20 } from "@openzeppelin/contracts-5.0/interfaces/IERC20.sol";
import { IBorrowerOperations } from "./IBorrowerOperations.sol";

interface IStakeNTroveZap {
    struct TroveManagerData {
        address collateralToken;
        uint16 index;
    }

    function addColl(address, uint256, address, address) external;

    function openTrove(
        address troveManager,
        uint256 _maxFeePercentage,
        uint256 ethAmount,
        uint256 _debtAmount,
        address _upperHint,
        address _lowerHint
    ) external;

    function borrowerOps() external view returns (IBorrowerOperations);
    function adjustTrove(address, uint256, uint256, uint256, bool, address, address) external;

    function troveManagersData(address troveManager) external view returns (TroveManagerData memory);
}
