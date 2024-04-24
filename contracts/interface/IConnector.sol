// SPDX-License-Identifier: Apache-2.0
import "./ITokenTransferCallBack.sol";

pragma solidity 0.8.20;

/**
 * @Title: HoldingPI
 * @dev This struct is used to store the information of an holding position that we have
 * @param positionId The id of the position in trustedPositionsBP mapping
 * @param data Additional data that the connector needs to manage the position
 */
struct HoldingPI {
    address calculatorConnector;
    address ownerConnector;
    bytes32 positionId;
    bytes data;
    bytes additionalData;
    uint256 positionTimestamp;
}

interface IConnector is ITokenTransferCallBack {
    event ValueOracleUpdated(address _oracle);
    event SwapHandlerUpdated(address _addr);
    event MinimumHealthFactorUpdated(uint256 _minimumHealthFactor);
    event TransferTokensToTrustedAddress(address token, uint256 amount, address caller, bytes data);
    event TransferPositionToConnector(address[] tokens, uint256[] amounts, address connector, bytes data);
    event UpdateTokenInRegistry(address token, bool remove);
    event AddLiquidity(address[] tokens, uint256[] amounts, bytes data);
    event SwapHoldings(address tokenIn, address tokenOut, uint256 amountIn, bytes data);

    error IConnector_InvalidAddress(address addr);
    error IConnector_InvalidPositionType(address connector, uint256 positionTypeId, bytes data);
    error IConnector_InvalidInput();
    error IConnector_RouteDisabled();
    error IConnector_InvalidAmount();
    error IConnector_InvalidTarget(address target);
    error IConnector_UntrustedToken(address token);
    error IConnector_InsufficientDepositAmount(uint256 amount, uint256 expectedAmount);
    error IConnector_InvalidPosition(bytes32 positionId);
    error IConnector_LowHealthFactor(uint256 healthFactor);
    error IConnector_BridgeTransactionNotApproved(bytes32 txn);
    error IConnector_InvalidDestinationChain();
    error IConnector_InvalidSender();

    function addLiquidity(address[] memory tokens, uint256[] memory amounts, bytes memory data) external;

    function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) external view returns (address[] memory);

    function getPositionTVL(HoldingPI memory, address) external view returns (uint256);
}
