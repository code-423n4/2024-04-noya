// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../helpers/BaseConnector.sol";
import { IComet, IRewards } from "../external/interfaces/Compound/ICompound.sol";

contract CompoundConnector is BaseConnector {
    uint256 public COMPOUND_LP = 2;

    event Supply(address market, address asset, uint256 amount);
    event WithdrawOrBorrow(address market, address asset, uint256 amount);
    event ClaimRewards(address rewardContract, address market);

    /**
     * Constructor *********************************
     */
    constructor(BaseConnectorCP memory baseConnectorParams) BaseConnector(baseConnectorParams) { }

    /**
     * Restricted Functions *********************************
     */

    /**
     * @notice Supply tokens to Compound
     * @param market - Compound market address
     * @param asset - asset to supply
     * @param amount - amount to supply
     */
    function supply(address market, address asset, uint256 amount) external onlyManager nonReentrant {
        _approveOperations(asset, market, amount);
        if (!registry.isTokenTrusted(vaultId, asset, address(this))) revert IConnector_UntrustedToken(asset);
        IComet(market).supply(asset, amount);
        registry.updateHoldingPosition(
            vaultId, registry.calculatePositionId(address(this), COMPOUND_LP, abi.encode(market)), "", "", false
        );
        _updateTokenInRegistry(asset);
        emit Supply(market, asset, amount);
    }

    /**
     * @notice Borrow or withdraw tokens from Compound
     * @param _market - Compound market address
     * @param asset - asset to borrow
     * @param amount - amount to borrow
     * @dev If the health factor is below the minimum health factor, the transaction will revert.
     * @dev based on the tokens that we deposited, will be borrowed or withdrawn
     */
    function withdrawOrBorrow(address _market, address asset, uint256 amount) external onlyManager nonReentrant {
        IComet(_market).withdraw(asset, amount);
        if (!registry.isTokenTrusted(vaultId, asset, address(this))) revert IConnector_UntrustedToken(asset);
        uint256 healthFactor = getAccountHealthFactor(IComet(_market));
        if (healthFactor < minimumHealthFactor) revert IConnector_LowHealthFactor(healthFactor);
        if (getCollBlanace(IComet(_market), false) == 0) {
            registry.updateHoldingPosition(
                vaultId, registry.calculatePositionId(address(this), COMPOUND_LP, abi.encode(_market)), "", "", true
            );
        }
        _updateTokenInRegistry(asset);
        emit WithdrawOrBorrow(_market, asset, amount);
    }

    /// @notice Claim additional rewards
    function claimRewards(address rewardContract, address market) external onlyManager nonReentrant {
        address rewardToken = IRewards(rewardContract).rewardConfig(market).token;
        IRewards(rewardContract).claim(address(market), address(this), true);
        _updateTokenInRegistry(rewardToken);
        emit ClaimRewards(rewardContract, market);
    }

    /**
     * @notice Returns an accounts health factor for a given comet.
     * @dev Returns type(uint256).max if no debt is owed.
     */
    function getAccountHealthFactor(IComet comet) public view returns (uint256) {
        // Get the amount of base debt owed adjusted for price.
        uint256 borrowBalanceInBase = getBorrowBalanceInBase(comet);
        if (borrowBalanceInBase == 0) return type(uint256).max;
        return getCollBlanace(comet, true) * 1e18 / borrowBalanceInBase;
    }
    /**
     * @notice Returns the borrow balance in base token for the given comet.
     */

    function getBorrowBalanceInBase(IComet comet) public view returns (uint256 borrowBalanceInVirtualBase) {
        uint256 borrowBalanceInBase = comet.borrowBalanceOf(address(this));
        if (borrowBalanceInBase == 0) return 0;
        address basePriceFeed = comet.baseTokenPriceFeed();
        uint256 basePriceInVirtualBase = comet.getPrice(basePriceFeed);
        borrowBalanceInVirtualBase = (borrowBalanceInBase * basePriceInVirtualBase) / comet.baseScale();
    }
    /**
     * @notice Returns the collateral balance in base token for the given comet.
     */

    function getCollBlanace(IComet comet, bool riskAdjusted) public view returns (uint256 CollValue) {
        IComet.UserBasic memory userBasic = comet.userBasic(address(this));
        uint16 assetsIn = userBasic.assetsIn;
        uint256 basePrice = comet.getPrice(comet.baseTokenPriceFeed());
        uint256 baseScale = comet.baseScale();
        if (userBasic.principal > 0) {
            uint256 principalInBase = uint256(uint104(userBasic.principal));
            CollValue += principalInBase;
        }
        uint8 numberOfAssets = comet.numAssets();

        // Iterate through assets, and determine the risk adjusted collateral value.
        for (uint8 i; i < numberOfAssets; ++i) {
            if (isInAsset(assetsIn, i)) {
                IComet.AssetInfo memory info = comet.getAssetInfo(i);

                // Check if we have a collateral balance.
                (uint256 collateralBalance,) = comet.userCollateral(address(this), info.asset);

                // Get the value of collateral in virtual base.
                uint256 collateralPriceInVirtualBase = comet.getPrice(info.priceFeed);

                uint256 collateralValueInVirtualBase =
                    collateralBalance * collateralPriceInVirtualBase * baseScale / info.scale / basePrice;
                if (riskAdjusted) CollValue += collateralValueInVirtualBase * info.liquidateCollateralFactor / 1e18;
                else CollValue += collateralValueInVirtualBase;
            } // else user collateral is zero.
        }
    }

    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256) {
        address market = abi.decode(registry.getPositionBP(vaultId, p.positionId).data, (address));

        uint256 positiveBalance = getCollBlanace(IComet(market), false);
        uint256 negativeBalance = getBorrowBalanceInBase(IComet(market));
        uint256 balance = positiveBalance - negativeBalance;
        return (valueOracle.getValue(IComet(market).baseToken(), base, balance));
    }

    function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {
        return new address[](0);
    }

    /**
     * @dev Whether user has a non-zero balance of an asset, given assetsIn flags
     */
    function isInAsset(uint16 assetsIn, uint8 assetOffset) public pure returns (bool) {
        return (assetsIn & (uint16(1) << assetOffset) != 0);
    }
}
