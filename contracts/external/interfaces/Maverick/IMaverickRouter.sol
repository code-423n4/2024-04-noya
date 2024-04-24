//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "./IMaverickPool.sol";
import "./IMaverickPosition.sol";
import "./IMaverickReward.sol";
import "./IPositionInspector.sol";
import "./IveMAV.sol";

interface IMaverickRouter {
    function position() external view returns (IMaverickPosition);

    function removeLiquidity(
        IMaverickPool,
        address,
        uint256,
        RemoveLiquidityParams[] calldata,
        uint256,
        uint256,
        uint256
    ) external returns (uint256 tokenAAmount, uint256 tokenBAmount, BinDelta[] memory binDeltas);

    function addLiquidityToPool(IMaverickPool, uint256, AddLiquidityParams[] calldata, uint256, uint256, uint256)
        external
        payable
        returns (uint256, uint256, uint256, BinDelta[] memory);
}
