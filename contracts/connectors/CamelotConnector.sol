// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";

import "../helpers/BaseConnector.sol";
import "../external/interfaces/Camelot/ICamelotRouter.sol";
import "../external/interfaces/Camelot/ICamelotFactory.sol";
import "../external/interfaces/Camelot/ICamelotPair.sol";

struct CamelotAddLiquidityParams {
    address tokenA;
    address tokenB;
    uint256 amountA;
    uint256 amountB;
    uint256 minAmountA;
    uint256 minAmountB;
    uint256 deadline;
}

struct CamelotRemoveLiquidityParams {
    address tokenA;
    address tokenB;
    uint256 amountLiquidty;
    uint256 minAmountA;
    uint256 minAmountB;
    uint256 deadline;
}

contract CamelotConnector is BaseConnector {
    ICamelotRouter public router;
    ICamelotFactory public factory;

    uint256 public constant CAMELOT_POSITION_ID = 1;

    constructor(address _router, address _factory, BaseConnectorCP memory baseCP) BaseConnector(baseCP) {
        require(_router != address(0));
        require(_factory != address(0));
        router = ICamelotRouter(_router);
        factory = ICamelotFactory(_factory);
    }

    function addLiquidityInCamelotPool(CamelotAddLiquidityParams calldata p) external onlyManager nonReentrant {
        _approveOperations(p.tokenA, address(router), p.amountA);
        _approveOperations(p.tokenB, address(router), p.amountB);
        router.addLiquidity(
            p.tokenA, p.tokenB, p.amountA, p.amountB, p.minAmountA, p.minAmountB, address(this), p.deadline
        );
        _updateTokenInRegistry(p.tokenA);
        _updateTokenInRegistry(p.tokenB);
        registry.updateHoldingPosition(
            vaultId,
            registry.calculatePositionId(address(this), CAMELOT_POSITION_ID, abi.encode(p.tokenA, p.tokenB)),
            "",
            "",
            false
        );
    }
    /*
    * @notice: Remove liquidity from Maverick pool
    * @param: p - parameters for removing liquidity
    * @dev: eth pool index : 0(tokenA), 1(tokenB), other(there is no eth in the pool)
    */

    function removeLiquidityFromCamelotPool(CamelotRemoveLiquidityParams calldata p)
        external
        onlyManager
        nonReentrant
    {
        address pool = factory.getPair(p.tokenA, p.tokenB);
        _approveOperations(pool, address(router), p.amountLiquidty);
        router.removeLiquidity(
            p.tokenA, p.tokenB, p.amountLiquidty, p.minAmountA, p.minAmountB, address(this), p.deadline
        );
        _updateTokenInRegistry(p.tokenA);
        _updateTokenInRegistry(p.tokenB);
        if (IERC20(pool).balanceOf(address(this)) == 0) {
            registry.updateHoldingPosition(
                vaultId,
                registry.calculatePositionId(address(this), CAMELOT_POSITION_ID, abi.encode(p.tokenA, p.tokenB)),
                "",
                "",
                true
            );
        }
    }

    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
        (address tokenA, address tokenB) =
            abi.decode(registry.getPositionBP(vaultId, p.positionId).data, (address, address));
        address pool = factory.getPair(tokenA, tokenB);
        uint256 totalSupply = IERC20(pool).totalSupply();
        (uint256 reserves0, uint256 reserves1,,) = ICamelotPair(pool).getReserves();

        uint256 balanceThis = IERC20(pool).balanceOf(address(this));
        return balanceThis * (_getValue(tokenA, base, reserves0) + _getValue(tokenB, base, reserves1)) / totalSupply;
    }

    function _getUnderlyingTokens(uint256 id, bytes memory data) public view override returns (address[] memory) {
        (address tokenA, address tokenB) = abi.decode(data, (address, address));
        address[] memory tokens = new address[](2);
        tokens[0] = tokenA;
        tokens[1] = tokenB;
        return tokens;
    }
}
