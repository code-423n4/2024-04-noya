// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "./IPAllActionTypeV3.sol";

interface IPActionSwapPTV3 {
    event SwapPtAndSy(
        address indexed caller,
        address indexed market,
        address indexed receiver,
        int256 netPtToAccount,
        int256 netSyToAccount
    );

    event SwapPtAndToken(
        address indexed caller,
        address indexed market,
        address indexed token,
        address receiver,
        int256 netPtToAccount,
        int256 netTokenToAccount,
        uint256 netSyInterm
    );

    function swapExactTokenForPt(
        address receiver,
        address market,
        uint256 minPtOut,
        ApproxParams calldata guessPtOut,
        TokenInput calldata input,
        LimitOrderData calldata limit
    ) external payable returns (uint256 netPtOut, uint256 netSyFee, uint256 netSyInterm);

    function swapExactSyForPt(
        address receiver,
        address market,
        uint256 exactSyIn,
        uint256 minPtOut,
        ApproxParams calldata guessPtOut,
        LimitOrderData calldata limit
    ) external returns (uint256 netPtOut, uint256 netSyFee);

    function swapExactPtForToken(
        address receiver,
        address market,
        uint256 exactPtIn,
        TokenOutput calldata output,
        LimitOrderData calldata limit
    ) external returns (uint256 netTokenOut, uint256 netSyFee, uint256 netSyInterm);

    function swapExactPtForSy(
        address receiver,
        address market,
        uint256 exactPtIn,
        uint256 minSyOut,
        LimitOrderData calldata limit
    ) external returns (uint256 netSyOut, uint256 netSyFee);
}
