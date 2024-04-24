// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../helpers/BaseConnector.sol";
import "../external/interfaces/Aerodrome/IPool.sol";
import "../external/interfaces/Aerodrome/IRouter.sol";
import "../external/interfaces/Aerodrome/IVoter.sol";
import "../external/interfaces/Aerodrome/IGauge.sol";

struct DepositData {
    address pool;
    uint256 amount0;
    uint256 amount1;
    uint256 min0Min;
    uint256 min1Min;
    uint256 deadline;
}

struct WithdrawData {
    address pool;
    uint256 amountLiquidity;
    uint256 min0Min;
    uint256 min1Min;
    uint256 deadline;
}

contract AerodromeConnector is BaseConnector {
    using SafeERC20 for IERC20;

    // ------------ state variables -------------- //
    uint256 public constant AERODROME_POSITION_TYPE = 1;

    IRouter aerodromeRouter;
    IVoter voter;

    event Supply(address pool, uint256 amount0, uint256 amount1);
    event Withdraw(address pool, uint256 amountLiquidity);
    // ------------ Constructor -------------- //

    constructor(address _router, address _voter, BaseConnectorCP memory baseConnectorParams)
        BaseConnector(baseConnectorParams)
    {
        require(_router != address(0));
        aerodromeRouter = IRouter(_router);
        voter = IVoter(_voter);
    }

    // ------------ Connector functions -------------- //
    /**
     * @notice Supply tokens to Aerodrome
     * @param data - DepositData struct
     */
    function supply(DepositData memory data) public onlyManager nonReentrant {
        bytes32 positionId = registry.calculatePositionId(address(this), AERODROME_POSITION_TYPE, abi.encode(data.pool));
        _approveOperations(IPool(data.pool).token0(), address(aerodromeRouter), data.amount0);
        _approveOperations(IPool(data.pool).token1(), address(aerodromeRouter), data.amount1);
        aerodromeRouter.addLiquidity(
            IPool(data.pool).token0(),
            IPool(data.pool).token1(),
            IPool(data.pool).stable(),
            data.amount0,
            data.amount1,
            data.min0Min,
            data.min1Min,
            address(this),
            data.deadline
        );
        registry.updateHoldingPosition(vaultId, positionId, "", "", false);
        _updateTokenInRegistry(IPool(data.pool).token0());
        _updateTokenInRegistry(IPool(data.pool).token1());

        emit Supply(data.pool, data.amount0, data.amount1);
    }

    /**
     * @notice Withdraw tokens from Aerodrome pool
     * @param data - WithdrawData struct
     */
    function withdraw(WithdrawData memory data) public onlyManager nonReentrant {
        bytes32 positionId = registry.calculatePositionId(address(this), AERODROME_POSITION_TYPE, abi.encode(data.pool));
        _approveOperations(data.pool, address(aerodromeRouter), data.amountLiquidity);
        aerodromeRouter.removeLiquidity(
            IPool(data.pool).token0(),
            IPool(data.pool).token1(),
            IPool(data.pool).stable(),
            data.amountLiquidity,
            data.min0Min,
            data.min1Min,
            address(this),
            data.deadline
        );
        if (IERC20(data.pool).balanceOf(address(this)) == 0) {
            registry.updateHoldingPosition(vaultId, positionId, "", "", true);
        }
        _updateTokenInRegistry(IPool(data.pool).token0());
        _updateTokenInRegistry(IPool(data.pool).token1());
        emit Withdraw(data.pool, data.amountLiquidity);
    }

    function stake(address pool, uint256 liquidity) public onlyManager nonReentrant {
        address gauge = voter.gauges(pool);
        IERC20(pool).forceApprove(address(gauge), liquidity);
        IGauge(gauge).deposit(liquidity, address(this));
    }

    function unstake(address pool, uint256 liquidity) public onlyManager nonReentrant {
        address gauge = voter.gauges(pool);
        IGauge(gauge).withdraw(liquidity);
    }

    function claim(address pool) public onlyManager nonReentrant {
        address gauge = voter.gauges(pool);
        IGauge(gauge).getReward(address(this));
        _updateTokenInRegistry(IGauge(gauge).rewardToken());
    }

    function _getUnderlyingTokens(uint256 p, bytes memory data) public view override returns (address[] memory) {
        address[] memory tokens = new address[](2);
        (address pool) = abi.decode(data, (address));
        tokens[0] = IPool(pool).token0();
        tokens[1] = IPool(pool).token1();
        return tokens;
    }

    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256) {
        PositionBP memory pBP = registry.getPositionBP(vaultId, p.positionId);
        (address pool) = abi.decode(pBP.data, (address));
        uint256 balance = IERC20(pool).balanceOf(address(this));
        uint256 totalSupply = IERC20(pool).totalSupply();
        (uint256 reserve0, uint256 reserve1,) = IPool(pool).getReserves();
        uint256 amount0 = balance * reserve0 / totalSupply;
        uint256 amount1 = balance * reserve1 / totalSupply;
        return _getValue(IPool(pool).token0(), base, amount0) + _getValue(IPool(pool).token1(), base, amount1);
    }
}
