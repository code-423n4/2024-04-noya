// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IFraxPair {
    struct ExchangeRateInfo {
        uint32 lastTimestamp;
        uint224 exchangeRate;
    }

    function addCollateral(uint256 _collateralAmount, address _borrower) external;
    function addInterest()
        external
        returns (uint256 _interestEarned, uint256 _feesAmount, uint256 _feesShare, uint64 _newRate);
    function asset() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function borrowAsset(uint256 _borrowAmount, uint256 _collateralAmount, address _receiver)
        external
        returns (uint256 _shares);
    function changeFee(uint32 _newFee) external;
    function cleanLiquidationFee() external view returns (uint256);
    function collateralContract() external view returns (address);
    function currentRateInfo()
        external
        view
        returns (uint64 lastBlock, uint64 feeToProtocolRate, uint64 lastTimestamp, uint64 ratePerSec);
    function removeCollateral(uint256 _collateralAmount, address _receiver) external;
    function repayAsset(uint256 _shares, address _borrower) external returns (uint256 _amountToRepay);
    function repayAssetWithCollateral(
        address _swapperAddress,
        uint256 _collateralToSwap,
        uint256 _amountAssetOutMin,
        address[] memory _path
    ) external returns (uint256 _amountAssetOut);
    function toAssetAmount(uint256 _shares, bool _roundUp) external view returns (uint256);
    function toBorrowAmount(uint256 _shares, bool _roundUp, bool _previewInterest)
        external
        view
        returns (uint256 _amount);
    function toBorrowAmount(uint256 _shares, bool _roundUp) external view returns (uint256);
    function toBorrowShares(uint256 _amount, bool _roundUp, bool _previewInterest)
        external
        view
        returns (uint256 _shares);
    function userBorrowShares(address) external view returns (uint256);
    function userCollateralBalance(address) external view returns (uint256);
    function exchangeRateInfo() external view returns (ExchangeRateInfo memory exchangeRateInfo);
    function getConstants()
        external
        view
        returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256);
    function maxLTV() external view returns (uint256 maxLTV);
}
