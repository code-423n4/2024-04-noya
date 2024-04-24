// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../interface/IConnector.sol";

/**
 * @Title: TrustedPositionInfo
 * @dev This struct is used to store the information of a trusted position
 * @param calculatorConnector The address of the connector that owns the position
 * @param positionTypeId The id of the position type (defined by the connector)
 * @param isDebt A boolean indicating if the position is a debt position
 * @param data Additional data that the connector needs to manage the position (e.g. address of the pool in curve connector, )
 */
struct PositionBP {
    address calculatorConnector;
    uint256 positionTypeId;
    bool onlyOwner;
    bool isEnabled;
    bool isDebt;
    bytes data;
    bytes additionalData;
}

/**
 * @Title: ConnectorData
 * @dev This struct is used to store the information of a connector
 * @param connectorAddress The address of the connector
 * @param enabled A boolean indicating if the connector is enabled
 * @param isPositionUsed A mapping of positionIds that the connector is using
 * @param holdingPositions An array of HoldingPI that the connector is holding
 * @param trustedTokens A mapping of additional tokens that the connector is allowed to hold
 */
struct ConnectorData {
    bool enabled;
    mapping(address => bool) trustedTokens;
}

/**
 * @Title: Vault
 * @dev This struct is used to store the information of a vault
 * @param accountManager The address of the account manager contract
 * @param vaultManager The address of the vault manager contract
 * @param baseToken The address of the base token of the vault (e.g. USDC for USD vaults, WETH for ETH vaults, etc.) (we use this token to calculate the value of the vault shares)
 * @param trustedTokens A mapping of trusted tokens
 * @param connectors A mapping of connectors
 * @param governer The address of the governer (This address is authorized to change the maintainer, watcher, strategyManager and emergencyManager)
 * @param maintainer The address of the maintainer (This address is responsible for adding whitelisted chains, pools, bridges and other settings)
 * @param maintainerWithoutTimeLock The address of the maintainer without time lock ()
 * @param strategyManager The address of the strategy manager (This address is responsible for executing the strategies)
 * @param keeperContract The address of the keeper contract
 * @param watcherContract The address of the watcher contract
 * @param enabled A boolean indicating if the vault is enabled
 */
struct Vault {
    address accountManager;
    address baseToken;
    mapping(address => ConnectorData) connectors;
    mapping(bytes32 => PositionBP) trustedPositionsBP;
    mapping(bytes32 => uint256) isPositionUsed;
    HoldingPI[] holdingPositions;
    address governer;
    address maintainer;
    address maintainerWithoutTimeLock;
    address keeperContract;
    address watcherContract;
    address emergency;
    bool enabled;
}

interface IPositionRegistry {
    event VaultAdded(uint256 v, address _accountingManager, address _baseToken, address[] _trustedTokens);
    event VaultAddressesChanged(
        uint256 v,
        address _governer,
        address _maintainer,
        address _maintainerWithoutTimelock,
        address _keeperContract,
        address _watcherContract,
        address _emergency
    );
    event ConnectorAdded(uint256 v, address _connectorAddress);
    event ConnectorTrustedTokensUpdated(uint256 v, address _connectorAddress, address[] _tokens, bool trusted);
    event TrustedPositionAdded(
        uint256 vaultId,
        bytes32 positionId,
        address calculatorConnector,
        uint256 _positionTypeId,
        bool onlyOwner,
        bool _isDebt,
        bytes _data
    );
    event TrustedPositionRemoved(uint256 vaultId, bytes32 positionId);
    event HoldingPositionUpdated(
        uint256 vaultId,
        bytes32 _positionId,
        bytes _data,
        bytes additionalData,
        bool removePosition,
        uint256 positionIndex
    );
    event updateFlashloanAddress(address newFlashloan, address oldFlashloan);

    // -------------------- ERRORS --------------------

    error UnauthorizedAccess();
    error TokenNotTrusted(address token);
    error NotExist();
    error InvalidPosition(bytes32 positionId);
    error AlreadyExists();
    error CannotRemovePosition(uint256 v, bytes32 positionId);
    error CannotDisableConnector();
    error TooManyPositions();
}
