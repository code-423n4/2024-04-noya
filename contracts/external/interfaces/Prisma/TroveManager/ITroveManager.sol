// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

interface ITroveManager {
    function getTroveCollAndDebt(address _borrower) external view returns (uint256, uint256);

    function debtToken() external view returns (address);

    function getNominalICR(address _borrower) external view returns (uint256);
}
