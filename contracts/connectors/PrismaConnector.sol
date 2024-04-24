// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import { SafeERC20 } from "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

import { IBorrowerOperations } from "../external/interfaces/Prisma/IBorrowerOperations.sol";
import { ITroveManager } from "../external/interfaces/Prisma/TroveManager/ITroveManager.sol";
import { IStakeNTroveZap } from "../external/interfaces/Prisma/IStakeNTroveZap.sol";
import "../helpers/BaseConnector.sol";

contract PrismaConnector is BaseConnector {
    using SafeERC20 for IERC20;

    uint256 public constant PRISMA_POSITION_ID = 10;

    event OpenTrove(address zap, address tm, uint256 maxFee, uint256 dAmount, uint256 bAmount);
    event AddColl(address zap, address tm, uint256 amountIn);
    event AdjustTrove(address zap, address tm, uint256 mFee, uint256 wAmount, uint256 bAmount, bool isBorrowing);
    event CloseTrove(address zap, address troveManager);

    /**
     * @notice Constructs the PrismaConnector contract with initial setup
     * @param baseConnectorParams Struct containing essential parameters for the base connector
     */
    constructor(BaseConnectorCP memory baseConnectorParams) BaseConnector(baseConnectorParams) { }
    /**
     * @notice Approves or revokes the zap contract to operate on behalf of the borrower operations contract
     * @param zap The address of the StakeNTroveZap contract
     * @param tm The address of the TroveManager contract
     * @param approve True to approve, false to revoke
     */

    function approveZap(IStakeNTroveZap zap, address tm, bool approve) public onlyManager nonReentrant {
        if (approve) {
            bytes32 positionId = registry.calculatePositionId(address(this), PRISMA_POSITION_ID, abi.encode(zap, tm));

            if (!registry.isPositionTrustedForConnector(vaultId, positionId, address(this))) {
                revert IConnector_InvalidPosition(positionId);
            }
        }
        IBorrowerOperations(zap.borrowerOps()).setDelegateApproval(address(zap), approve);
    }
    /**
     * @notice Opens a new trove with specified parameters using the zap contract
     * @param zap The address of the StakeNTroveZap contract used for interaction
     * @param tm The address of the TroveManager contract
     * @param maxFee Maximum fee for the operation
     * @param dAmount The amount of collateral to deposit
     * @param bAmount The amount of borrowing
     */

    function openTrove(IStakeNTroveZap zap, address tm, uint256 maxFee, uint256 dAmount, uint256 bAmount)
        public
        onlyManager
        nonReentrant
    {
        bytes32 positionId = registry.calculatePositionId(address(this), PRISMA_POSITION_ID, abi.encode(zap, tm));
        PositionBP memory positionInfo = registry.getPositionBP(vaultId, positionId);
        address collateral = abi.decode(positionInfo.additionalData, (address));
        address debTtoken = ITroveManager(tm).debtToken();
        _approveOperations(collateral, address(zap), dAmount);
        zap.openTrove(tm, maxFee, dAmount, bAmount, address(this), address(this));
        registry.updateHoldingPosition(vaultId, positionId, "", "", false);
        _updateTokenInRegistry(collateral);
        _updateTokenInRegistry(debTtoken);
        emit OpenTrove(address(zap), tm, maxFee, dAmount, bAmount);
    }

    /**
     * @notice Adds collateral to an existing trove
     * @param zapContract The address of the StakeNTroveZap contract
     * @param tm The address of the TroveManager
     * @param amountIn The amount of collateral to add
     */
    function addColl(IStakeNTroveZap zapContract, address tm, uint256 amountIn) public onlyManager nonReentrant {
        bytes32 positionId =
            registry.calculatePositionId(address(this), PRISMA_POSITION_ID, abi.encode(zapContract, tm));
        PositionBP memory positionInfo = registry.getPositionBP(vaultId, positionId);
        if (registry.getHoldingPositionIndex(vaultId, positionId, address(this), "") == 0) {
            revert IConnector_InvalidPosition(positionId);
        }
        address collateral = abi.decode(positionInfo.additionalData, (address));
        _approveOperations(collateral, address(zapContract), amountIn);
        zapContract.addColl(tm, amountIn, address(this), address(this));
        emit AddColl(address(zapContract), tm, amountIn);
    }

    /**
     * @notice Adjusts an existing trove, allowing for collateral withdrawal, debt repayment, or borrowing
     * @param zapContract The address of the StakeNTroveZap contract
     * @param tm The address of the TroveManager
     * @param mFee The maximum fee for the operation
     * @param wAmount The amount of collateral to withdraw
     * @param bAmount The amount of debt to repay or borrow
     * @param isBorrowing Set to true if the operation involves borrowing
     */
    function adjustTrove(
        IStakeNTroveZap zapContract,
        address tm,
        uint256 mFee,
        uint256 wAmount,
        uint256 bAmount,
        bool isBorrowing
    ) public onlyManager nonReentrant {
        bytes32 positionId =
            registry.calculatePositionId(address(this), PRISMA_POSITION_ID, abi.encode(zapContract, tm));
        if (registry.getHoldingPositionIndex(vaultId, positionId, address(this), "") == 0) {
            revert IConnector_InvalidPosition(positionId);
        }
        IBorrowerOperations borrowerOps = zapContract.borrowerOps();
        if (bAmount > 0 && !isBorrowing) {
            _approveOperations(ITroveManager(tm).debtToken(), address(borrowerOps), bAmount);
        }
        borrowerOps.adjustTrove(tm, address(this), mFee, 0, wAmount, bAmount, isBorrowing, address(this), address(this));
        _updateTokenInRegistry(ITroveManager(tm).debtToken());
        // get health factor
        uint256 healthFactor = ITroveManager(tm).getNominalICR(address(this));
        if (minimumHealthFactor > healthFactor) {
            revert IConnector_LowHealthFactor(healthFactor);
        }
        emit AdjustTrove(address(zapContract), tm, mFee, wAmount, bAmount, isBorrowing);
    }

    /**
     * @notice Closes an existing trove
     * @param zapContract The address of the StakeNTroveZap contract
     * @param troveManager The address of the TroveManager
     */
    function closeTrove(IStakeNTroveZap zapContract, address troveManager) public onlyManager nonReentrant {
        bytes32 positionId =
            registry.calculatePositionId(address(this), PRISMA_POSITION_ID, abi.encode(zapContract, troveManager));
        IBorrowerOperations borrowerOperations = zapContract.borrowerOps();
        borrowerOperations.closeTrove(troveManager, address(this));
        registry.updateHoldingPosition(vaultId, positionId, "", "", true);
        emit CloseTrove(address(zapContract), troveManager);
    }
    /**
     * @notice Calculates the Total Value Locked (TVL) of a given position in the specified base token
     * @param p The holding position information
     * @param base The address of the base currency to calculate the TVL in
     * @return tvl The TVL of the position in the base currency
     * @dev The TVL is calculated as the value of the collateral minus the value of the debt
     */

    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
        PositionBP memory positionInfo = registry.getPositionBP(vaultId, p.positionId);
        if (positionInfo.positionTypeId == PRISMA_POSITION_ID) {
            (address zap, address troveManager) = abi.decode(positionInfo.data, (address, address));
            IBorrowerOperations borrowerOperations = IStakeNTroveZap(zap).borrowerOps();
            address collateral = borrowerOperations.troveManagersData(troveManager).collateralToken;
            address debTtoken = ITroveManager(troveManager).debtToken();
            (uint256 collateralBalance, uint256 debtBalance) =
                ITroveManager(troveManager).getTroveCollAndDebt(address(this));
            return _getValue(collateral, base, collateralBalance) - _getValue(debTtoken, base, debtBalance);
        }
    }
    /**
     * @notice Returns the addresses of the underlying tokens involved in a position
     * @param data Additional data required to identify the position
     * @return An array of addresses of the underlying tokens
     * @dev the tokens are returned in the order of collateral, debt token
     */

    function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {
        (address zap, address troveManager) = abi.decode(data, (address, address));
        IBorrowerOperations borrowerOperations = IStakeNTroveZap(zap).borrowerOps();
        address collateral = borrowerOperations.troveManagersData(troveManager).collateralToken;
        address debTtoken = ITroveManager(troveManager).debtToken();
        address[] memory tokens = new address[](2);
        tokens[0] = collateral;
        tokens[1] = debTtoken;
        return tokens;
    }
}
