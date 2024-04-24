// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../external/interfaces/UNIv3/INonfungiblePositionManager.sol";
import "../external/interfaces/UNIv3/IUniswapV3Factory.sol";
import "../helpers/BaseConnector.sol";

/**
 * @title UNIv3Connector
 * @notice Connector for UNIv3 protocol
 */
contract UNIv3Connector is BaseConnector, ERC721Holder {
    using SafeERC20 for IERC20;
    // ------------ state variables -------------- //

    INonfungiblePositionManager public immutable positionManager;
    IUniswapV3Factory public immutable factory;

    uint256 public constant UNI_LP_POSITION_TYPE = 5;

    event OpenPosition(MintParams p, uint256 tokenId);
    event DecreasePosition(DecreaseLiquidityParams p);
    event IncreasePosition(IncreaseLiquidityParams p);
    event CollectFees(uint256 tokenId);
    // ------------ Constructor -------------- //

    constructor(address _positionManager, address _factory, BaseConnectorCP memory baseConnectorParams)
        BaseConnector(baseConnectorParams)
    {
        positionManager = INonfungiblePositionManager(_positionManager);
        factory = IUniswapV3Factory(_factory);
    }

    // ------------ Connector functions -------------- //
    /**
     * @notice Open a new position in Uniswap V3
     * @param p - MintParams struct
     * @return tokenId - the id of the new position
     */
    function openPosition(MintParams memory p) external onlyManager nonReentrant returns (uint256 tokenId) {
        bytes32 positionId =
            registry.calculatePositionId(address(this), UNI_LP_POSITION_TYPE, abi.encode(p.token0, p.token1));
        p.recipient = address(this);
        // Approve NonfungiblePositionManager to spend `token0` and `token1`.
        _approveOperations(p.token0, address(positionManager), p.amount0Desired);
        _approveOperations(p.token1, address(positionManager), p.amount1Desired);

        // Supply liquidity to pool.
        (tokenId,,,) = positionManager.mint(p);
        bytes memory positionData = abi.encode(tokenId);
        registry.updateHoldingPosition(
            vaultId, positionId, positionData, abi.encode(p.tickLower, p.tickUpper, p.fee), false
        );
        _updateTokenInRegistry(p.token0);
        _updateTokenInRegistry(p.token1);
        emit OpenPosition(p, tokenId);
    }
    /**
     * @notice decrease a position in Uniswap V3
     * @param p - DecreaseLiquidityParams struct
     */

    function decreasePosition(DecreaseLiquidityParams memory p) external onlyManager nonReentrant {
        (uint128 currentLiquidity, address token0, address token1) = getCurrentLiquidity(p.tokenId);
        if (p.liquidity > currentLiquidity) {
            revert IConnector_InvalidAmount();
        }
        positionManager.decreaseLiquidity(p);
        _collectFees(p.tokenId);
        _updateTokenInRegistry(token0);
        _updateTokenInRegistry(token1);

        if (currentLiquidity == p.liquidity) {
            positionManager.burn(p.tokenId);
            bytes32 positionId =
                registry.calculatePositionId(address(this), UNI_LP_POSITION_TYPE, abi.encode(token0, token1));
            bytes memory positionData = abi.encode(p.tokenId);
            registry.updateHoldingPosition(vaultId, positionId, positionData, "", true);
        }
        emit DecreasePosition(p);
    }
    /**
     * @notice increase a position in Uniswap V3
     * @param p - IncreaseLiquidityParams struct
     */

    function increasePosition(IncreaseLiquidityParams memory p) external onlyManager nonReentrant {
        (, address token0, address token1) = getCurrentLiquidity(p.tokenId);
        // Approve NonfungiblePositionManager to spend `token0` and `token1`.
        _approveOperations(token0, address(positionManager), p.amount0Desired);
        _approveOperations(token1, address(positionManager), p.amount1Desired);
        positionManager.increaseLiquidity(p);
        _updateTokenInRegistry(token0);
        _updateTokenInRegistry(token1);
        emit IncreasePosition(p);
    }

    /// @notice Collects the fees associated with provided liquidity
    /// @dev The contract must hold the erc721 token before it can collect fees
    /// @param tokenIds The tokenIDs of the positions to collect fees from
    function collectAllFees(uint256[] memory tokenIds) public onlyManager nonReentrant {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            (, address token0, address token1) = getCurrentLiquidity(tokenIds[i]);
            _collectFees(tokenIds[i]);
            _updateTokenInRegistry(token0);
            _updateTokenInRegistry(token1);
            emit CollectFees(tokenIds[i]);
        }
    }

    // ------------ TVL functions -------------- //
    /**
     * @notice Get the Liquidity of a Uniswap V3 position
     * @param tokenId - the id of the position
     */
    function getCurrentLiquidity(uint256 tokenId) public view returns (uint128, address, address) {
        (,, address token0, address token1,,,, uint128 liquidity,,,,) = positionManager.positions(tokenId);
        return (liquidity, token0, token1);
    }

    // ------------ Internal functions -------------- //
    function _collectFees(uint256 tokenId) internal returns (uint256 amount0, uint256 amount1) {
        CollectParams memory params = CollectParams(tokenId, address(this), type(uint128).max, type(uint128).max);
        (amount0, amount1) = positionManager.collect(params);
    }

    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
        PositionBP memory positionInfo = registry.getPositionBP(vaultId, p.positionId);
        uint256 tokenId = abi.decode(p.data, (uint256));
        (address token0, address token1) = abi.decode(positionInfo.data, (address, address));
        uint256 amount0;
        uint256 amount1;
        (int24 tL, int24 tU, uint24 fee) = abi.decode(p.additionalData, (int24, int24, uint24));
        {
            IUniswapV3Pool pool = IUniswapV3Pool(factory.getPool(token0, token1, fee));
            bytes32 key = keccak256(abi.encodePacked(positionManager, tL, tU));

            (uint128 liquidity,,, uint128 tokensOwed0, uint128 tokensOwed1) = pool.positions(key);

            (uint160 sqrtPriceX96,,,,,,) = pool.slot0();
            (amount0, amount1) = LiquidityAmounts.getAmountsForLiquidity(
                sqrtPriceX96, TickMath.getSqrtRatioAtTick(tL), TickMath.getSqrtRatioAtTick(tU), liquidity
            );
            amount0 += tokensOwed0;
            amount1 += tokensOwed1;
        }

        tvl += valueOracle.getValue(token0, base, amount0);
        tvl += valueOracle.getValue(token1, base, amount1);
    }

    function _getUnderlyingTokens(uint256, bytes memory data) public pure override returns (address[] memory) {
        address[] memory tokens = new address[](2);
        (tokens[0], tokens[1]) = abi.decode(data, (address, address));
        return tokens;
    }
}
