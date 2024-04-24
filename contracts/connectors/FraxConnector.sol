// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../helpers/BaseConnector.sol";
import "../external/interfaces/Frax/IFraxPair.sol";

struct FraxPoolInfo {
    address collateralContract;
    address assetContract;
    bool isActive;
}

struct FraxBorrowRequest {
    address poolAddress;
    uint256 amount;
}

contract FraxConnector is BaseConnector {
    using SafeERC20 for IERC20;
    // ------------ state variables -------------- //

    uint256 public COLLATERAL_AND_DEBT_POSITION_TYPE = 1;

    event BorrowAndSupply(address pool, uint256 borrowAmount, uint256 collateralAmount);
    event Withdraw(address pool, uint256 withdrawAmount);
    event Repay(address pool, uint256 sharesToRepay);
    // ------------ Constructor -------------- //

    constructor(BaseConnectorCP memory baseConnectorParams) BaseConnector(baseConnectorParams) { }

    // ------------ Connector functions -------------- //
    /**
     * @notice Supply tokens to FraxPair
     * @param pool - FraxPair address
     * @param borrowAmount - amount of tokens to borrow
     * @param collateralAmount - amount of collateral to supply
     */
    function borrowAndSupply(IFraxPair pool, uint256 borrowAmount, uint256 collateralAmount)
        external
        onlyManager
        nonReentrant
    {
        bytes32 positionId =
            registry.calculatePositionId(address(this), COLLATERAL_AND_DEBT_POSITION_TYPE, abi.encode(pool));
        IERC20 token = IERC20(pool.collateralContract());
        if (collateralAmount > 0) {
            _approveOperations(address(token), address(pool), collateralAmount);
        }
        if (borrowAmount > 0) {
            pool.borrowAsset(borrowAmount, collateralAmount, address(this));
            _updateTokenInRegistry(pool.asset());
        } else if (collateralAmount > 0) {
            pool.addCollateral(collateralAmount, address(this));
        }
        if (collateralAmount > 0) {
            _updateTokenInRegistry(address(token));
        }
        registry.updateHoldingPosition(vaultId, positionId, "", "", false);
        verifyHealthFactor(pool);
        emit BorrowAndSupply(address(pool), borrowAmount, collateralAmount);
    }
    /**
     * @notice withdraw tokens from FraxPair or borrow more tokens
     * @param pool - FraxPair address
     * @param withdrawAmount - amount of collateral to withdraw
     */

    function withdraw(IFraxPair pool, uint256 withdrawAmount) public onlyManager nonReentrant {
        uint256 currentCollateral = pool.userCollateralBalance(address(this));
        if (withdrawAmount == currentCollateral) {
            bytes32 positionId =
                registry.calculatePositionId(address(this), COLLATERAL_AND_DEBT_POSITION_TYPE, abi.encode(pool));

            registry.updateHoldingPosition(vaultId, positionId, "", "", true);
        }
        pool.removeCollateral(withdrawAmount, address(this));
        _updateTokenInRegistry(pool.collateralContract());
        verifyHealthFactor(pool);
        emit Withdraw(address(pool), withdrawAmount);
    }

    /**
     * @notice Repay tokens to FraxPair to reduce debt
     * @param pool - FraxPair address
     * @param sharesToRepay - amount of shares to repay
     */
    function repay(IFraxPair pool, uint256 sharesToRepay) public onlyManager nonReentrant {
        uint256 repayTokenAmount = pool.toBorrowAmount(sharesToRepay, true);
        uint256 sharesOwed = pool.userBorrowShares(address(this));
        address asset = pool.asset();
        if (sharesToRepay > sharesOwed) {
            revert IConnector_InvalidInput();
        }
        _approveOperations(asset, address(pool), repayTokenAmount);
        IFraxPair(pool).repayAsset(sharesToRepay, address(this));
        _updateTokenInRegistry(asset);
        emit Repay(address(pool), sharesToRepay);
    }
    /**
     * @notice Verify health factor of the borrower
     * @param pool - FraxPair address
     */

    function verifyHealthFactor(IFraxPair pool) public view {
        // Check health factor is still satisfactory
        uint256 exchangeRate = pool.exchangeRateInfo().exchangeRate;
        // Check if borrower is insolvent after this borrow tx, revert if they are
        uint256 healthFactor = _getHealthFactor(pool, exchangeRate);
        if (minimumHealthFactor > healthFactor) {
            revert IConnector_LowHealthFactor(healthFactor);
        }
    }

    /**
     * @notice The ```_getHealthFactor``` function returns the current health factor of a respective position given an exchange rate
     * @param _fraxlendPair The specified Fraxlend Pair
     * @param _exchangeRate The exchange rate, i.e. the amount of collateral to buy 1e18 asset
     * @return currentHF The health factor of the position atm
     */
    function _getHealthFactor(IFraxPair _fraxlendPair, uint256 _exchangeRate) internal view virtual returns (uint256) {
        // calculate the borrowShares
        uint256 borrowerShares = _fraxlendPair.userBorrowShares(address(this));
        uint256 _borrowerAmount = _fraxlendPair.toBorrowAmount(borrowerShares, true);
        if (_borrowerAmount == 0) return type(uint256).max;
        uint256 _collateralAmount = _fraxlendPair.userCollateralBalance(address(this));
        if (_collateralAmount == 0) return 0;
        (uint256 LTV_PRECISION,,,, uint256 EXCHANGE_PRECISION,,,) = _fraxlendPair.getConstants();
        uint256 currentPositionLTV =
            (((_borrowerAmount * _exchangeRate) * LTV_PRECISION) / EXCHANGE_PRECISION) / _collateralAmount;

        // get maxLTV from fraxlendPair
        uint256 fraxlendPairMaxLTV = _fraxlendPair.maxLTV();
        if (currentPositionLTV == 0) return type(uint256).max; // loan is small

        // // convert LTVs to HF
        uint256 currentHF = (fraxlendPairMaxLTV * 1e18) / currentPositionLTV;

        // // compare HF to current HF.
        return currentHF;
    }

    function _getUnderlyingTokens(uint256 p, bytes memory data) public view override returns (address[] memory) {
        address[] memory tokens = new address[](2);
        (address pool) = abi.decode(data, (address));
        tokens[0] = IFraxPair(pool).collateralContract();
        tokens[1] = IFraxPair(pool).asset();
        return tokens;
    }

    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
        PositionBP memory positionInfo = registry.getPositionBP(vaultId, p.positionId);
        IFraxPair pool = IFraxPair(abi.decode(positionInfo.data, (address)));
        uint256 collateralAmount = pool.userCollateralBalance(address(this));
        uint256 borrowerShares = pool.userBorrowShares(address(this));
        uint256 _borrowerAmount = pool.toBorrowAmount(borrowerShares, true);

        uint256 borrowValue = _getValue(pool.asset(), base, _borrowerAmount);
        uint256 collateralValue = _getValue(pool.collateralContract(), base, collateralAmount);
        if (collateralValue > borrowValue) {
            return collateralValue - borrowValue;
        }
        return tvl;
    }
}
