//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";

struct AddLiquidityParams {
    uint8 kind;
    int32 pos;
    bool isDelta;
    uint128 deltaA;
    uint128 deltaB;
}

struct RemoveLiquidityParams {
    uint128 binId;
    uint128 amount;
}

struct BinDelta {
    uint128 deltaA;
    uint128 deltaB;
    uint256 deltaLpBalance;
    uint128 binId;
    uint8 kind;
    int32 lowerTick;
    bool isActive;
}

interface IMaverickPool {
    function tokenA() external view returns (address);

    function tokenB() external view returns (address);
}
