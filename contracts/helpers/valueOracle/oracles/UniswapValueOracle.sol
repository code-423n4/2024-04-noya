// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "../../../external/libraries/uniswap/OracleLibrary.sol";
import "@openzeppelin/contracts-5.0/access/Ownable.sol";
import "../../../interface/valueOracle/INoyaValueOracle.sol";
import "../../../accountingManager/Registry.sol";

/// @title UniswapValueOracle
/// @notice This contract is used to get the Value of a token from Uniswap V3
contract UniswapValueOracle is INoyaValueOracle {
    // Mapping from asset to base to pool address
    mapping(address => mapping(address => address)) public assetToBaseToPool;
    // Address of the Uniswap V3 factory
    address public factory;
    PositionRegistry public registry;
    // Period for the oracle
    uint32 public period = 1800;

    event NewPeriod(uint32 period);
    event PoolsForAsset(address indexed asset, address indexed base, address indexed pool);

    modifier onlyMaintainer() {
        if (!registry.hasRole(registry.MAINTAINER_ROLE(), msg.sender)) revert INoyaValueOracle_Unauthorized(msg.sender);
        _;
    }

    /// @notice Constructor
    /// @param _factory The address of the Uniswap V3 factory
    constructor(address _factory, PositionRegistry _registry) {
        factory = _factory;
        registry = _registry;
    }

    /// @notice Sets the period for the oracle
    /// @param _period The new period
    function setPeriod(uint32 _period) external onlyMaintainer {
        if (_period == 0) revert INoyaValueOracle_InvalidInput();
        period = _period;
        emit NewPeriod(_period);
    }

    /// @notice Adds a pool for a token
    /// @param tokenIn The address of the token
    /// @param baseToken The address of the base token
    /// @param fee The fee tier of the pool
    function addPool(address tokenIn, address baseToken, uint24 fee) external onlyMaintainer {
        address pool = IUniswapV3Factory(factory).getPool(tokenIn, baseToken, fee);
        require(pool != address(0), "pool doesn't exist");
        assetToBaseToPool[tokenIn][baseToken] = pool;
        emit PoolsForAsset(tokenIn, baseToken, pool);
    }

    /// @notice Gets the value of a token in terms of the base currency
    /// @param tokenIn The address of the token
    /// @param baseToken The address of the base token
    /// @param amount The amount of the token
    /// @return _amountOut The value of the token in terms of the base currency
    function getValue(address tokenIn, address baseToken, uint256 amount) public view returns (uint256 _amountOut) {
        uint128 amountIn128 = uint128(amount);
        address pool = assetToBaseToPool[tokenIn][baseToken];
        if (pool == address(0)) {
            pool = assetToBaseToPool[baseToken][tokenIn];
        }
        if (pool == address(0)) revert INoyaOracle_ValueOracleUnavailable(tokenIn, baseToken);

        // Code copied from OracleLibrary.sol, consult()
        uint32[] memory secondsAgos = new uint32[](2);
        secondsAgos[0] = period;
        secondsAgos[1] = 0;

        // Get the tick cumulatives from the pool for the periods
        (int56[] memory tickCumulatives,) = IUniswapV3Pool(pool).observe(secondsAgos);

        // Calculate the delta of the tick cumulatives
        int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];

        // Calculate the time-weighted average tick
        // int56 / uint32 = int24
        int24 timeWeightedAverageTick = int24(tickCumulativesDelta / int56(int32(period)));
        if (tickCumulativesDelta < 0 && (tickCumulativesDelta % int56(int32(period)) != 0)) {
            timeWeightedAverageTick--;
        }
        _amountOut = OracleLibrary.getQuoteAtTick(timeWeightedAverageTick, amountIn128, tokenIn, baseToken);
    }
}
