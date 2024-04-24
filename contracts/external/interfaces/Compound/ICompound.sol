// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";

interface IComet is IERC20 {
    struct AssetInfo {
        uint8 offset;
        address asset;
        address priceFeed;
        uint64 scale;
        uint64 borrowCollateralFactor;
        uint64 liquidateCollateralFactor;
        uint64 liquidationFactor;
        uint128 supplyCap;
    }

    struct TotalsCollateral {
        uint128 totalSupplyAsset;
        uint128 _reserved;
    }

    struct UserBasic {
        int104 principal;
        uint64 baseTrackingIndex;
        uint64 baseTrackingAccrued;
        uint16 assetsIn;
    }

    function userBasic(address user) external view returns (UserBasic memory);

    function numAssets() external view returns (uint8);

    function getAssetInfo(uint8 i) external view returns (AssetInfo memory);

    function userCollateral(address user, address asset) external view returns (uint128 collateral, uint128 reserves);

    /// @notice The address of the base token contract
    function baseToken() external view returns (address);

    /// @notice The address of the price feed for the base token
    function baseTokenPriceFeed() external view returns (address);

    /**
     * @notice Query the current negative base balance of an account or zero
     * @dev Note: uses updated interest indices to calculate
     * @param account The account whose balance to query
     * @return The present day base balance magnitude of the account, if negative
     */
    function borrowBalanceOf(address account) external view returns (uint256);

    /**
     * @notice Query the current collateral balance of an account
     * @param account The account whose balance to query
     * @param asset The collateral asset to check the balance for
     * @return The collateral balance of the account
     */
    function collateralBalanceOf(address account, address asset) external view returns (uint128);

    /**
     * @dev Determine index of asset that matches given address and return assetInfo
     */
    function getAssetInfoByAddress(address asset) external view returns (AssetInfo memory);

    /**
     * @notice Get the current price from a feed
     * @param priceFeed The address of a price feed
     * @return The price, scaled by `PRICE_SCALE`
     */
    function getPrice(address priceFeed) external view returns (uint256);

    function baseScale() external view returns (uint256);

    function accrualDescaleFactor() external view returns (uint256);

    /**
     * @notice Get the total amount of debt
     * @dev Note: uses updated interest indices to calculate
     * @return The amount of debt
     *
     */
    function totalBorrow() external view returns (uint256);

    /**
     * @notice Get the total amount of given token
     * @param asset The collateral asset to check the total for
     * @return The total collateral balance
     */
    function totalsCollateral(address asset) external view returns (TotalsCollateral memory);

    /**
     * @notice Get the total number of tokens in circulation
     * @dev Note: uses updated interest indices to calculate
     * @return The supply of tokens
     *
     */
    function totalSupply() external view returns (uint256);

    /**
     * @notice Supply an amount of asset to the protocol
     * @param asset The asset to supply
     * @param amount The quantity to supply
     */
    function supply(address asset, uint256 amount) external;

    /**
     * @notice Withdraw an amount of asset from the protocol
     * @param asset The asset to withdraw
     * @param amount The quantity to withdraw
     */
    function withdraw(address asset, uint256 amount) external;
}

interface IRewards {
    struct RewardOwed {
        address token;
        uint256 owed;
    }

    struct RewardConfig {
        address token;
        uint64 rescaleFactor;
        bool shouldUpscale;
    }
    /**
     * @notice Calculates the amount of a reward token owed to an account
     * @param comet The protocol instance
     * @param account The account to check rewards for
     */

    function getRewardOwed(address comet, address account) external returns (RewardOwed memory);
    function rewardConfig(address comet) external view returns (RewardConfig memory);
    /**
     * @notice Claim rewards of token type from a comet instance to owner address
     * @param comet The protocol instance
     * @param src The owner to claim for
     * @param shouldAccrue Whether or not to call accrue first
     */
    function claim(address comet, address src, bool shouldAccrue) external;

    error Absurd();
    error AlreadyInitialized();
    error BadAsset();
    error BadDecimals();
    error BadDiscount();
    error BadMinimum();
    error BadPrice();
    error BorrowTooSmall();
    error BorrowCFTooLarge();
    error InsufficientReserves();
    error LiquidateCFTooLarge();
    error NoSelfTransfer();
    error NotCollateralized();
    error NotForSale();
    error NotLiquidatable();
    error Paused();
    error SupplyCapExceeded();
    error TimestampTooLarge();
    error TooManyAssets();
    error TooMuchSlippage();
    error TransferInFailed();
    error TransferOutFailed();
    error Unauthorized();
}
