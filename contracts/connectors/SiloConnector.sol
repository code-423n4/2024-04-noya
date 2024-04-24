// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../helpers/BaseConnector.sol";
import "../external/interfaces/Silo/ISilo.sol";
import "../external/libraries/Silo/SolvencyV2.sol";

contract SiloConnector is BaseConnector {
    ISiloRepository public siloRepository;
    uint256 public constant SILO_LP_ID = 11;

    event Deposit(address siloToken, address dToken, uint256 amount, bool oC);
    event Withdraw(address siloToken, address wToken, uint256 amount, bool oC, bool closePosition);
    event Borrow(address siloToken, address bToken, uint256 amount);
    event Repay(address siloToken, address rToken, uint256 amount);

    constructor(address SR, BaseConnectorCP memory baseConnectorParams) BaseConnector(baseConnectorParams) {
        require(SR != address(0));

        siloRepository = ISiloRepository(SR);
        MINIMUM_HEALTH_FACTOR = 5e17;

        minimumHealthFactor = MINIMUM_HEALTH_FACTOR;
    }
    /**
     * @notice Deposit tokens to Silo
     * @param siloToken - Silo token address
     * @param dToken - token to deposit
     * @param amount - amount to deposit
     * @param oC - open a position
     */

    function deposit(address siloToken, address dToken, uint256 amount, bool oC) external onlyManager nonReentrant {
        ISilo silo = ISilo(siloRepository.getSilo(siloToken));
        _approveOperations(dToken, address(silo), amount);
        silo.deposit(dToken, amount, oC);
        _updateTokenInRegistry(dToken);
        registry.updateHoldingPosition(
            vaultId, registry.calculatePositionId(address(this), SILO_LP_ID, abi.encode(siloToken)), "", "", false
        );
        emit Deposit(siloToken, dToken, amount, oC);
    }

    /**
     * @notice Withdraw tokens from Silo
     * @param siloToken - Silo token address
     * @param wToken - token to withdraw
     * @param amount - amount to withdraw
     * @param oC - open a position
     * @param closePosition - close position (here to save gas if the position is not empty)
     */
    function withdraw(address siloToken, address wToken, uint256 amount, bool oC, bool closePosition)
        external
        onlyManager
        nonReentrant
    {
        ISilo silo = ISilo(siloRepository.getSilo(siloToken));
        silo.withdraw(wToken, amount, oC);
        _updateTokenInRegistry(wToken);
        if (closePosition && isSiloEmpty(silo)) {
            registry.updateHoldingPosition(
                vaultId, registry.calculatePositionId(address(this), SILO_LP_ID, abi.encode(siloToken)), "", "", true
            );
        }
        if (!SolvencyV2.isSolvent(silo, address(this), minimumHealthFactor)) {
            revert IConnector_LowHealthFactor(0);
        }
        emit Withdraw(siloToken, wToken, amount, oC, closePosition);
    }

    function getData(address siloToken)
        public
        view
        returns (uint256 userLTV, uint256 LiquidationThreshold, bool isSolvent)
    {
        return SolvencyV2.getData(ISilo(siloRepository.getSilo(siloToken)), address(this), minimumHealthFactor);
    }
    /**
     * @notice Borrow tokens from Silo
     * @param siloToken - Silo token address
     * @param bToken - token to borrow
     * @param amount - amount to borrow
     */

    function borrow(address siloToken, address bToken, uint256 amount) external onlyManager nonReentrant {
        ISilo silo = ISilo(siloRepository.getSilo(siloToken));
        silo.borrow(bToken, amount);
        _updateTokenInRegistry(bToken);
        emit Borrow(siloToken, bToken, amount);
    }
    /**
     * @notice Repay tokens to Silo
     * @param siloToken - Silo token address
     * @param rToken - token to repay
     * @param amount - amount to repay
     */

    function repay(address siloToken, address rToken, uint256 amount) external onlyManager nonReentrant {
        ISilo silo = ISilo(siloRepository.getSilo(siloToken));
        _approveOperations(rToken, address(silo), amount);
        silo.repay(rToken, amount);
        _updateTokenInRegistry(rToken);
        if (!SolvencyV2.isSolvent(silo, address(this), minimumHealthFactor)) {
            revert IConnector_LowHealthFactor(0);
        }
        emit Repay(siloToken, rToken, amount);
    }

    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
        PositionBP memory bp = registry.getPositionBP(vaultId, p.positionId);
        (address siloToken) = abi.decode(bp.data, (address));
        ISilo silo = ISilo(siloRepository.getSilo(siloToken));
        (address[] memory assets, IBaseSilo.AssetStorage[] memory assetsS) = silo.getAssetsWithState();
        uint256 totalDepositAmount = 0;
        uint256 totalBAmount = 0;
        for (uint256 i = 0; i < assets.length; i++) {
            uint256 depositAmount = IERC20(assetsS[i].collateralToken).balanceOf(address(this));
            depositAmount += IERC20(assetsS[i].collateralOnlyToken).balanceOf(address(this));
            uint256 borrowAmount = IERC20(assetsS[i].debtToken).balanceOf(address(this));
            if (depositAmount == 0 && borrowAmount == 0) {
                continue;
            }
            uint256 price = _getValue(assets[i], base, 1e18);
            totalDepositAmount += depositAmount * price / 1e18;
            totalBAmount += borrowAmount * price / 1e18;
        }
        tvl = totalDepositAmount - totalBAmount;
    }

    function isSiloEmpty(ISilo silo) public view returns (bool) {
        (, IBaseSilo.AssetStorage[] memory assetsS) = silo.getAssetsWithState();
        for (uint256 i = 0; i < assetsS.length; i++) {
            if (
                IERC20(assetsS[i].collateralToken).balanceOf(address(this))
                    + IERC20(assetsS[i].collateralOnlyToken).balanceOf(address(this)) > 0
            ) {
                return false;
            }
        }
        return true;
    }

    function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {
        (address siloToken) = abi.decode(data, (address));
        ISilo silo = ISilo(siloRepository.getSilo(siloToken));
        (address[] memory assets,) = silo.getAssetsWithState();
        return assets;
    }
}
