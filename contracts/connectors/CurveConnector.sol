// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../helpers/BaseConnector.sol";
import "../external/interfaces/Curve/IRewardsGauge.sol";
import "../external/interfaces/Convex/IConvexBasicRewards.sol";
import { IDepositToken } from "../external/interfaces/Prisma/IDepositToken.sol";

struct PoolInfo {
    address pool;
    uint256 tokensSize;
    address lpToken;
    address gauge;
    address convexLPToken;
    address convexRewardPool;
    address prismaCurvePool;
    address prismaConvexPool;
    address[] tokens;
    address zap;
    uint256 defaultWithdrawIndex;
    address poolAddressIfDefaultWithdrawTokenIsAnotherPosition;
}

contract CurveConnector is BaseConnector {
    // ------------ state variables -------------- //
    IBooster public convexBooster;
    address public CVX;
    address public CRV;
    address public PRISMA;

    uint256 public constant CURVE_LP_POSITION = 4;

    event OpenCurvePosition(address pool, uint256 depositIndex, uint256 amount, uint256 minAmount);
    event DecreaseCurvePosition(address pool, uint256 withdrawIndex, uint256 amount, uint256 minAmount);
    event WithdrawFromConvexBooster(uint256 pid, uint256 amount);
    event WithdrawFromConvexRewardPool(address pool, uint256 amount);
    event WithdrawFromGauge(address pool, uint256 amount);
    event WithdrawFromPrisma(address depostiToken, uint256 amount);
    event HarvestRewards(address[] gauges);
    event HarvestPrismaRewards(address[] pools);
    event HarvestConvexRewards(address[] rewardsPools);

    // ------------ Constructor -------------- //

    constructor(
        address _convexBooster,
        address cvx,
        address crv,
        address prisma,
        BaseConnectorCP memory baseConnectorParams
    ) BaseConnector(baseConnectorParams) {
        require(_convexBooster != address(0));
        require(cvx != address(0));
        require(crv != address(0));
        require(prisma != address(0));
        convexBooster = IBooster(_convexBooster);
        CVX = cvx;
        CRV = crv;
        PRISMA = prisma;
    }

    // ------------ Connector functions -------------- //
    /**
     * @notice Deposit tokens into Curve gauge
     * @param pool - Curve pool address
     * @param amount - amount of tokens to deposit
     */
    function depositIntoGauge(address pool, uint256 amount) public onlyManager nonReentrant {
        PoolInfo memory poolInfo = _getPoolInfo(pool);

        _approveOperations(poolInfo.lpToken, poolInfo.gauge, amount);
        IRewardsGauge(poolInfo.gauge).deposit(amount);
    }
    /**
     * @notice Deposit tokens into Prisma Convex or Curve pool
     * @param pool - Curve pool address
     * @param amount - amount of tokens to deposit
     * @param curveOrConvex - true for curve, false for convex
     */

    function depositIntoPrisma(address pool, uint256 amount, bool curveOrConvex) public onlyManager nonReentrant {
        PoolInfo memory poolInfo = _getPoolInfo(pool);

        // approve depositToken to spend lpToken
        address lpToken = poolInfo.lpToken;
        address depostiToken = poolInfo.prismaCurvePool;
        if (!curveOrConvex) {
            depostiToken = poolInfo.prismaConvexPool;
        }
        _approveOperations(lpToken, depostiToken, amount);

        // stake LP in Prisma
        IDepositToken(depostiToken).deposit(address(this), amount);
    }
    /**
     * @notice Deposit tokens into Convex gauge
     * @param pool - Curve pool address
     * @param pid - convex pid
     * @param amount - amount of tokens to deposit
     * @param stake - stake or not
     */

    function depositIntoConvexBooster(address pool, uint256 pid, uint256 amount, bool stake) public onlyManager {
        PoolInfo memory poolInfo = _getPoolInfo(pool);

        _approveOperations(poolInfo.lpToken, address(convexBooster), amount);
        convexBooster.deposit(pid, amount, stake);
    }
    /**
     * @notice Deposit tokens into Curve pool
     * @param pool - Curve pool address
     * @param depositIndex - index of token to deposit
     * @param amount - amount of tokens to deposit
     * @param minAmount - minimum amount of LP tokens to mint
     */

    function openCurvePosition(address pool, uint256 depositIndex, uint256 amount, uint256 minAmount)
        public
        onlyManager
        nonReentrant
    {
        bytes32 positionId = registry.calculatePositionId(address(this), CURVE_LP_POSITION, abi.encode(pool));
        PositionBP memory p = registry.getPositionBP(vaultId, positionId);
        PoolInfo memory poolInfo = abi.decode(p.additionalData, (PoolInfo));
        address token = poolInfo.tokens[depositIndex];
        address poolAddress = (poolInfo.tokens.length > 2 && poolInfo.zap != address(0)) ? poolInfo.zap : pool;
        _approveOperations(token, poolAddress, amount);
        if (poolInfo.tokens.length == 2) {
            uint256[2] memory amounts;
            amounts[depositIndex] = amount;
            ICurveSwap(poolAddress).add_liquidity(amounts, minAmount);
        } else if (poolInfo.tokens.length == 3) {
            uint256[3] memory amounts;
            amounts[depositIndex] = amount;
            ICurveSwap(poolAddress).add_liquidity(amounts, minAmount);
        } else if (poolInfo.tokens.length == 4) {
            uint256[4] memory amounts;
            amounts[depositIndex] = amount;
            ICurveSwap(poolAddress).add_liquidity(amounts, minAmount);
        } else if (poolInfo.tokens.length == 5) {
            uint256[5] memory amounts;
            amounts[depositIndex] = amount;
            ICurveSwap(poolAddress).add_liquidity(amounts, minAmount);
        } else if (poolInfo.tokens.length == 6) {
            uint256[6] memory amounts;
            amounts[depositIndex] = amount;
            ICurveSwap(poolAddress).add_liquidity(amounts, minAmount);
        }
        emit OpenCurvePosition(pool, depositIndex, amount, minAmount);
        registry.updateHoldingPosition(vaultId, positionId, "", "", false);
    }
    /**
     * @notice Withdraw tokens from Curve pool
     * @param pool - Curve pool address
     * @param withdrawIndex - index of token to withdraw
     * @param amount - amount of LP tokens to withdraw
     * @param minAmount - minimum amount of tokens to receive
     */

    function decreaseCurvePosition(address pool, uint256 withdrawIndex, uint256 amount, uint256 minAmount)
        public
        onlyManager
        nonReentrant
    {
        PoolInfo memory poolInfo = _getPoolInfo(pool);
        address token = poolInfo.tokens[withdrawIndex];
        bytes32 positionId = registry.calculatePositionId(address(this), CURVE_LP_POSITION, abi.encode(pool));

        ICurveSwap(poolInfo.pool).remove_liquidity_one_coin(amount, int128(uint128(withdrawIndex)), minAmount);
        _updateTokenInRegistry(token);
        if (totalLpBalanceOf(poolInfo) == 0) {
            registry.updateHoldingPosition(vaultId, positionId, "", "", true);
        }
        emit DecreaseCurvePosition(pool, withdrawIndex, amount, minAmount);
    }
    /**
     * @notice Withdraw tokens from Convex gauge
     * @param pid - convex pid
     * @param amount - amount of tokens to withdraw
     */

    function withdrawFromConvexBooster(uint256 pid, uint256 amount) public onlyManager {
        convexBooster.withdraw(pid, amount);
        emit WithdrawFromConvexBooster(pid, amount);
    }

    /**
     * @notice Withdraw tokens from Convex reward pool
     * @param pool - Convex reward pool address
     * @param amount - amount of tokens to withdraw
     */
    function withdrawFromConvexRewardPool(address pool, uint256 amount) public onlyManager {
        IConvexBasicRewards(pool).withdraw(amount, true);
        emit WithdrawFromConvexRewardPool(pool, amount);
    }
    /**
     * @notice Withdraw tokens from Curve gauge
     * @param pool - Curve pool address
     * @param amount - amount of tokens to withdraw
     */

    function withdrawFromGauge(address pool, uint256 amount) public onlyManager {
        IRewardsGauge(pool).withdraw(amount);
        emit WithdrawFromGauge(pool, amount);
    }
    /**
     * @notice Withdraw tokens from Prisma Convex or Curve pool
     * @param depostiToken - Prisma pool address
     * @param amount - amount of tokens to withdraw
     */

    function withdrawFromPrisma(address depostiToken, uint256 amount) public onlyManager {
        IDepositToken(depostiToken).withdraw(address(this), amount);
        emit WithdrawFromPrisma(depostiToken, amount);
    }
    /**
     * @notice Harvest rewards from Curve gauge
     * @param gauges - array of Curve gauge addresses
     */

    function harvestRewards(address[] calldata gauges) public onlyManager nonReentrant {
        for (uint256 i = 0; i < gauges.length; i++) {
            IRewardsGauge(gauges[i]).claim_rewards(address(this));
        }
        _updateTokenInRegistry(CRV);
        emit HarvestRewards(gauges);
    }
    /**
     * @notice Harvest rewards from Prisma Convex or Curve pool
     * @param pools - array of Curve pool addresses
     */

    function harvestPrismaRewards(address[] calldata pools) public onlyManager nonReentrant {
        for (uint256 i = 0; i < pools.length; i++) {
            IDepositToken(pools[i]).claimReward(address(this));
        }
        _updateTokenInRegistry(PRISMA);
        _updateTokenInRegistry(CRV);
        _updateTokenInRegistry(CVX);
        emit HarvestPrismaRewards(pools);
    }
    /**
     * @notice Harvest rewards from Convex reward pool
     * @param rewardsPools - array of Convex reward pool addresses
     */

    function harvestConvexRewards(address[] calldata rewardsPools) public onlyManager nonReentrant {
        for (uint256 i = 0; i < rewardsPools.length; i++) {
            IConvexBasicRewards baseRewardPool = IConvexBasicRewards(rewardsPools[i]);
            baseRewardPool.getReward(address(this), true);
        }
        _updateTokenInRegistry(CVX);
        _updateTokenInRegistry(CRV);
        emit HarvestConvexRewards(rewardsPools);
    }

    // ------------ internal functions -------------- //
    function _getPoolInfo(address pool) internal view returns (PoolInfo memory) {
        bytes32 positionId = registry.calculatePositionId(address(this), CURVE_LP_POSITION, abi.encode(pool));
        PositionBP memory p = registry.getPositionBP(vaultId, positionId);
        return abi.decode(p.additionalData, (PoolInfo));
    }

    // ------------ TVL functions -------------- //
    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
        PositionBP memory PTI = registry.getPositionBP(vaultId, p.positionId);
        PoolInfo memory poolInfo = abi.decode(PTI.additionalData, (PoolInfo));
        uint256 lpBalance = totalLpBalanceOf(poolInfo);
        (uint256 amount, address token) = LPToUnder(poolInfo, lpBalance);
        return _getValue(token, base, amount);
    }
    /**
     * @notice Get underlying tokens of Curve pool LP token
     * @param info - Curve pool info
     * @param balance - LP token balance
     * @return underlyingAssetAmount - amount of underlying asset in DefaultWithdrawIndex token
     */

    function LPToUnder(PoolInfo memory info, uint256 balance) public view returns (uint256, address) {
        if (balance == 0) return (0, info.tokens[info.defaultWithdrawIndex]);
        uint256 underlyingAssetAmount =
            estimateWithdrawAmount(ICurveSwap(info.pool), balance, info.defaultWithdrawIndex);
        if (info.poolAddressIfDefaultWithdrawTokenIsAnotherPosition != address(0)) {
            return
                LPToUnder(_getPoolInfo(info.poolAddressIfDefaultWithdrawTokenIsAnotherPosition), underlyingAssetAmount);
        }
        return (underlyingAssetAmount, info.tokens[info.defaultWithdrawIndex]);
    }

    /**
     * @notice Estimate amount of token to withdraw from Curve pool
     * @param curvePool - Curve pool address
     * @param amount - amount of LP tokens to withdraw
     * @param index - index of token to withdraw
     * @return amount - amount of token to withdraw
     */
    function estimateWithdrawAmount(ICurveSwap curvePool, uint256 amount, uint256 index)
        public
        view
        returns (uint256)
    {
        int128 tokenIndex = int128(uint128(index));
        return curvePool.calc_withdraw_one_coin(amount, tokenIndex);
    }
    /**
     * @notice Get total LP token balance of Curve pool
     * @param info - Curve pool info
     * @return totalLpBalance - total LP token balance
     */

    function totalLpBalanceOf(PoolInfo memory info) public view returns (uint256) {
        uint256 lpBalance = balanceOfLPToken(info);
        uint256 rewardBalance = balanceOfRewardPool(info);
        uint256 convexRewardBalance = balanceOfConvexRewardPool(info);
        uint256 prismaBalance = balanceOfPrisma(info.prismaCurvePool);
        uint256 prismaConvexBalance = balanceOfPrisma(info.prismaConvexPool);
        return lpBalance + rewardBalance + convexRewardBalance + prismaBalance + prismaConvexBalance;
    }
    /**
     * @notice Get total LP token balance of Convex reward pool
     * @param info - Curve pool info
     * @return totalLpBalance - total LP token balance
     */

    function balanceOfConvexRewardPool(PoolInfo memory info) public view returns (uint256) {
        if (info.convexRewardPool == address(0)) return 0;
        return IConvexBasicRewards(info.convexRewardPool).balanceOf(address(this));
    }
    /**
     * @notice Get total LP token balance of Curve pool
     * @param info - Curve pool info
     * @return totalLpBalance - total LP token balance
     */

    function balanceOfLPToken(PoolInfo memory info) public view returns (uint256) {
        return IERC20(info.lpToken).balanceOf(address(this));
    }
    /**
     * @notice Get total LP token balance of Curve gauge
     * @param info - Curve pool info
     * @return totalLpBalance - total LP token balance of this contract in Curve gauge
     */

    function balanceOfRewardPool(PoolInfo memory info) public view returns (uint256) {
        if (info.gauge == address(0)) return 0;
        return IRewardsGauge(info.gauge).balanceOf(address(this));
    }
    /**
     * @notice Get total LP token balance of Prisma pool
     * @param prismaPool - Prisma pool address
     * @return totalLpBalance - total LP token balance of this contract in Prisma pool
     */

    function balanceOfPrisma(address prismaPool) public view returns (uint256) {
        if (prismaPool == address(0)) return 0;
        return IDepositToken(prismaPool).balanceOf(address(this));
    }
}
