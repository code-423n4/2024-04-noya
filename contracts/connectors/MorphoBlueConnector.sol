// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../helpers/BaseConnector.sol";
import "../external/interfaces/Morpho/IMorpho.sol";
import "../external/libraries/Morpho/SharesMathLib.sol";

contract MorphoBlueConnector is BaseConnector {
    using SafeERC20 for IERC20;
    using SharesMathLib for uint256;
    // ------------ state variables -------------- //

    IMorpho public immutable morphoBlue;
    uint256 constant ORACLE_PRICE_SCALE = 1e36;
    uint256 public constant MORPHO_POSITION_ID = 1;

    event Supply(uint256 amount, Id id, bool sOrC);
    event Withdraw(uint256 amount, Id id, bool sOrC);
    event Borrow(uint256 amount, Id id);
    event Repay(uint256 amount, Id id);

    // ------------ Constructor -------------- //
    constructor(address MB, BaseConnectorCP memory baseCP) BaseConnector(baseCP) {
        require(MB != address(0));
        morphoBlue = IMorpho(MB);
    }

    // ------------ Connector functions -------------- //
    /**
     * @notice Supply tokens to MorphoBlue
     * @param amount - amount of tokens to supply
     * @param id - market id
     * @param sOrC - supply or collateral
     */
    function supply(uint256 amount, Id id, bool sOrC) external onlyManager nonReentrant {
        MarketParams memory params = morphoBlue.idToMarketParams(id);
        if (sOrC) {
            _approveOperations(params.loanToken, address(morphoBlue), amount);
            morphoBlue.supply(params, amount, 0, address(this), "");
            _updateTokenInRegistry(params.loanToken);
        } else {
            _approveOperations(params.collateralToken, address(morphoBlue), amount);
            morphoBlue.supplyCollateral(params, amount, address(this), "");
            _updateTokenInRegistry(params.collateralToken);
        }
        registry.updateHoldingPosition(
            vaultId, registry.calculatePositionId(address(this), MORPHO_POSITION_ID, abi.encode(id)), "", "", false
        );
        emit Supply(amount, id, sOrC);
    }
    /**
     * @notice Withdraw tokens from MorphoBlue
     * @param amount - amount of tokens to withdraw
     * @param id - market id
     * @param sOrC - supply or collateral
     */

    function withdraw(uint256 amount, Id id, bool sOrC) external onlyManager nonReentrant {
        MarketParams memory params = morphoBlue.idToMarketParams(id);
        if (sOrC) {
            morphoBlue.withdraw(params, amount, 0, address(this), address(this));
        } else {
            morphoBlue.withdrawCollateral(params, amount, address(this), address(this));
        }
        Position memory p = morphoBlue.position(id, address(this));
        if (p.collateral == 0 && p.supplyShares == 0) {
            registry.updateHoldingPosition(
                vaultId, registry.calculatePositionId(address(this), MORPHO_POSITION_ID, abi.encode(id)), "", "", true
            );
        }
        _updateTokenInRegistry(params.collateralToken);
        emit Withdraw(amount, id, sOrC);
    }
    /**
     * @notice Borrow tokens from MorphoBlue
     * @param amount - amount of tokens to borrow
     * @param id - market id
     */

    function borrow(uint256 amount, Id id) external onlyManager nonReentrant {
        MarketParams memory market = morphoBlue.idToMarketParams(id);
        morphoBlue.borrow(market, amount, 0, address(this), address(this));
        if (getHealthFactor(id, morphoBlue.market(id)) < minimumHealthFactor) {
            revert IConnector_LowHealthFactor(getHealthFactor(id, morphoBlue.market(id)));
        }
        _updateTokenInRegistry(market.loanToken);
        emit Borrow(amount, id);
    }
    /**
     * @notice Repay tokens to MorphoBlue
     * @param amount - amount of tokens to repay
     * @param id - market id
     */

    function repay(uint256 amount, Id id) public onlyManager nonReentrant {
        MarketParams memory params = morphoBlue.idToMarketParams(id);
        _approveOperations(params.loanToken, address(morphoBlue), amount);
        morphoBlue.repay(params, amount, 0, address(this), "");
        _updateTokenInRegistry(params.loanToken);
        emit Repay(amount, id);
    }
    /**
     * @notice get Health Factor of a market
     * @param _id - market id
     * @param _market - market struct
     */

    function getHealthFactor(Id _id, Market memory _market) public view returns (uint256) {
        MarketParams memory market = morphoBlue.idToMarketParams(_id);
        Position memory p = morphoBlue.position(_id, address(this));
        uint256 borrowAmount = uint256(p.borrowShares).toAssetsUp(_market.totalBorrowAssets, _market.totalBorrowShares);
        if (borrowAmount == 0) return type(uint256).max;

        // get collateralAmount in borrowAmount for LTV calculations
        return market.lltv * convertCToL(p.collateral, market.oracle, market.collateralToken) / borrowAmount;
    }

    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
        PositionBP memory positionInfo = registry.getPositionBP(vaultId, p.positionId);
        if (positionInfo.positionTypeId == MORPHO_POSITION_ID) {
            Id id = abi.decode(positionInfo.data, (Id));
            MarketParams memory params = morphoBlue.idToMarketParams(id);
            Market memory market = morphoBlue.market(id);
            Position memory pos = morphoBlue.position(id, address(this));
            uint256 borrowAmount =
                uint256(pos.borrowShares).toAssetsUp(market.totalBorrowAssets, market.totalBorrowShares);
            uint256 supplyAmount =
                uint256(pos.supplyShares).toAssetsUp(market.totalSupplyAssets, market.totalSupplyShares);
            tvl = _getValue(
                params.loanToken,
                base,
                supplyAmount + borrowAmount + convertCToL(pos.collateral, params.oracle, params.collateralToken)
            );
        }
    }

    function convertCToL(uint256 amount, address marketOracle, address collateral) public view returns (uint256) {
        return amount * IOracle(marketOracle).price() / ORACLE_PRICE_SCALE;
    }

    function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {
        Id id = abi.decode(data, (Id));
        MarketParams memory params = morphoBlue.idToMarketParams(id);
        address[] memory tokens = new address[](2);
        tokens[0] = params.loanToken;
        tokens[1] = params.collateralToken;
        return tokens;
    }
}
