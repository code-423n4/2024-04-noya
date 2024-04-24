pragma solidity 0.8.20;

interface IPendleStaticRouter {
    function swapExactYtForSyStatic(address market, uint256 exactYtIn)
        external
        view
        returns (
            uint256 netSyOut,
            uint256 netSyFee,
            uint256 priceImpact,
            uint256 exchangeRateAfter,
            // extra-info
            uint256 netSyOwedInt,
            uint256 netPYToRepaySyOwedInt,
            uint256 netPYToRedeemSyOutInt
        );
}
