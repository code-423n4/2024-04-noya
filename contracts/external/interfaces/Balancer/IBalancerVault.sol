// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./IBalancerPool.sol";

import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";
import "./IFlashLoanRecipient.sol";

interface IRewardPool {
    function deposit(uint256 assets, address receiver) external returns (uint256 shares);
    function withdrawAndUnwrap(uint256, bool) external returns (bool);
    function convertToAssets(uint256) external view returns (uint256);
    function getReward() external;
}

interface IBalancerVault {
    enum JoinKind {
        INIT,
        EXACT_TOKENS_IN_FOR_BPT_OUT,
        TOKEN_IN_FOR_EXACT_BPT_OUT,
        ALL_TOKENS_IN_FOR_EXACT_BPT_OUT
    }

    enum ExitKind {
        EXACT_BPT_IN_FOR_ONE_TOKEN_OUT,
        EXACT_BPT_IN_FOR_TOKENS_OUT,
        BPT_IN_FOR_EXACT_TOKENS_OUT,
        MANAGEMENT_FEE_TOKENS_OUT
    }

    struct JoinPoolRequest {
        address[] assets;
        uint256[] maxAmountsIn;
        bytes userData;
        bool fromInternalBalance;
    }

    struct ExitPoolRequest {
        address[] assets;
        uint256[] minAmountsOut;
        bytes userData;
        bool toInternalBalance;
    }

    function getPoolTokens(bytes32 poolId)
        external
        view
        returns (address[] memory tokens, uint256[] memory balances, uint256 lastChangeBlock);

    function joinPool(bytes32 poolId, address sender, address recipient, JoinPoolRequest memory request)
        external
        payable;

    function exitPool(bytes32 poolId, address sender, address payable recipient, ExitPoolRequest memory request)
        external;

    function getPool(bytes32 poolId) external view returns (address poolAddress);

    function flashLoan(
        IFlashLoanRecipient recipient,
        IERC20[] memory tokens,
        uint256[] memory amounts,
        bytes memory userData
    ) external;
}
