// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.8.20;

interface ICamelotPair {
    function precisionMultiplier0() external pure returns (uint256);

    function precisionMultiplier1() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint16 token0feePercent, uint16 token1FeePercent);

    function getAmountOut(uint256 amountIn, address tokenIn) external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to) external returns (uint256 amount0, uint256 amount1);

    function stableSwap() external view returns (bool);
}
