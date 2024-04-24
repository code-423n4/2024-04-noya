// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../helpers/BaseConnector.sol";
import { IPool } from "../external/interfaces/Aave/IPool.sol";

/*
    * @title AaveConnector
    * @notice Connector for Aave protocol
    */
contract AaveConnector is BaseConnector {
    using SafeERC20 for IERC20;
    // ------------ state variables -------------- //
    /**
     * @notice Aave pool address
     */

    address immutable pool;
    /**
     * @notice Aave pool base token
     */
    address immutable poolBaseToken;

    uint256 public constant AAVE_POSITION_ID = 1;

    event Supply(address supplyToken, uint256 amount);
    event Borrow(address borrowToken, uint256 amount);
    event Repay(address repayToken, uint256 amount, uint256 i);
    event RepayWithCollateral(address repayToken, uint256 amount, uint256 i);
    event WithdrawCollateral(address collateral, uint256 amount);

    // ------------ Constructor -------------- //
    constructor(address _pool, address _poolBaseToken, BaseConnectorCP memory baseConnectorParams)
        BaseConnector(baseConnectorParams)
    {
        require(_pool != address(0));
        require(_poolBaseToken != address(0));
        poolBaseToken = _poolBaseToken;
        pool = _pool;
    }

    // ------------ Connector functions -------------- //
    /**
     * @notice Supply tokens to Aave
     */
    function supply(address supplyToken, uint256 amount) external onlyManager nonReentrant {
        _approveOperations(supplyToken, pool, amount);
        IPool(pool).supply(supplyToken, amount, address(this), 0);
        registry.updateHoldingPosition(
            vaultId, registry.calculatePositionId(address(this), AAVE_POSITION_ID, ""), "", "", false
        );
        _updateTokenInRegistry(supplyToken);
        emit Supply(supplyToken, amount);
    }

    /**
     * @notice Borrow tokens from Aave
     * @param _amount - amount to borrow
     * @param _borrowAsset - asset to borrow
     * @param _interestRateMode - Stable: 1, Variable: 2
     */
    function borrow(uint256 _amount, uint256 _interestRateMode, address _borrowAsset)
        external
        onlyManager
        nonReentrant
    {
        if (!registry.isTokenTrusted(vaultId, _borrowAsset, address(this))) {
            revert IConnector_UntrustedToken(_borrowAsset);
        }
        IPool(pool).borrow(_borrowAsset, _amount, _interestRateMode, 0, address(this));
        // get the health factor
        (,,,,, uint256 healthFactor) = IPool(pool).getUserAccountData(address(this));
        if (healthFactor < minimumHealthFactor) revert IConnector_LowHealthFactor(healthFactor);
        _updateTokenInRegistry(_borrowAsset);
        emit Borrow(_borrowAsset, _amount);
    }

    /**
     * @notice Repays onBehalfOf's debt amount of asset which has a rateMode.
     */
    function repay(address asset, uint256 amount, uint256 i) external onlyManager nonReentrant {
        _approveOperations(asset, pool, amount);
        IPool(pool).repay(asset, amount, i, address(this));
        _updateTokenInRegistry(asset);
        emit Repay(asset, amount, i);
    }

    function repayWithCollateral(uint256 _amount, uint256 i, address _borrowAsset) external onlyManager {
        IPool(pool).repayWithATokens(_borrowAsset, _amount, i);
        emit RepayWithCollateral(_borrowAsset, _amount, i);
    }

    /**
     * @notice Withdraw collateral from Aave
     * @notice This function is used when we want to withdraw some of the collateral
     * @notice It doesn't allow the health factor to go below the minimum health factor
     * @param _collateralAmount - amount to withdraw
     * @param _collateral - collateral to withdraw
     */
    function withdrawCollateral(uint256 _collateralAmount, address _collateral) external onlyManager nonReentrant {
        IPool(pool).withdraw(_collateral, _collateralAmount, address(this));
        // get the health factor
        (uint256 totalCollateralBase,,,,, uint256 healthFactor) = IPool(pool).getUserAccountData(address(this));
        if (healthFactor < minimumHealthFactor) revert IConnector_LowHealthFactor(healthFactor);
        _updateTokenInRegistry(_collateral);
        if (totalCollateralBase <= DUST_LEVEL * 1e7) {
            registry.updateHoldingPosition(
                vaultId, registry.calculatePositionId(address(this), AAVE_POSITION_ID, ""), "", "", true
            );
        }
        emit WithdrawCollateral(_collateral, _collateralAmount);
    }

    function _getPositionTVL(HoldingPI memory, address base) public view override returns (uint256 tvl) {
        (uint256 totalCollateralBase, uint256 totalDebtBase,,,,) = IPool(pool).getUserAccountData(address(this));
        uint256 poolBaseAmount = totalCollateralBase - totalDebtBase;
        return valueOracle.getValue(poolBaseToken, base, poolBaseAmount);
    }

    function _getUnderlyingTokens(uint256, bytes memory) public pure override returns (address[] memory) {
        return new address[](0);
    }
}
