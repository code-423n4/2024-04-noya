// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/access/AccessControl.sol";
import "@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol";
import "../interface/IPositionRegistry.sol";

/**
 * @dev : PositionRegistry
 * @dev This contract is used to store the information of the vaults and the positions
 */
contract PositionRegistry is AccessControl, IPositionRegistry, ReentrancyGuard {
    // -------------------- STATE VARIABLES --------------------
    // The id of the maintainer role (used to add and remove vaults and connectors)
    bytes32 public constant MAINTAINER_ROLE = keccak256("MAINTAINER_ROLE");
    // The id of the governer role (used to change the maintainer and governer addresses of the vaults)
    bytes32 public constant GOVERNER_ROLE = keccak256("GOVERNER_ROLE");
    // The id of the emergency role (used to perform emergency actions)
    bytes32 public constant EMERGENCY_ROLE = keccak256("EMERGENCY_ROLE");

    uint256 public constant MAX_NUM_HOLDING_POSITIONS = 40;

    uint256 public maxNumHoldingPositions = 20;

    // A mapping of vaults
    mapping(uint256 => Vault) public vaults;

    address public flashLoan;

    // -------------------- MODIFIERS --------------------

    modifier onlyVaultMaintainer(uint256 _vaultId) {
        if (msg.sender != vaults[_vaultId].maintainer || hasRole(EMERGENCY_ROLE, msg.sender) == false) {
            revert UnauthorizedAccess();
        }
        _;
    }

    modifier onlyVaultMaintainerWithoutTimeLock(uint256 _vaultId) {
        if (msg.sender != vaults[_vaultId].maintainerWithoutTimeLock && hasRole(EMERGENCY_ROLE, msg.sender) == false) {
            revert UnauthorizedAccess();
        }
        _;
    }

    modifier onlyVaultGoverner(uint256 _vaultId) {
        if (msg.sender != vaults[_vaultId].governer && hasRole(EMERGENCY_ROLE, msg.sender) == false) {
            revert UnauthorizedAccess();
        }
        _;
    }

    modifier vaultExists(uint256 _vaultId) {
        if (vaults[_vaultId].accountManager == address(0)) revert NotExist();
        _;
    }

    /**
     * @dev : Constructor
     * @param _governer The address of the governer
     * @param _maintainer The address of the maintainer
     * @param _emergency The address of the emergency
     * @dev Registry roles are set in the constructor
     * @dev The governer role is the admin of itself, the maintainer role and the emergency role
     */
    constructor(address _governer, address _maintainer, address _emergency, address _flashLoan) {
        require(_governer != address(0));
        require(_maintainer != address(0));
        require(_emergency != address(0));
        _grantRole(GOVERNER_ROLE, _governer);
        _grantRole(MAINTAINER_ROLE, _maintainer);
        _grantRole(EMERGENCY_ROLE, _emergency);
        _setRoleAdmin(GOVERNER_ROLE, GOVERNER_ROLE);
        _setRoleAdmin(MAINTAINER_ROLE, GOVERNER_ROLE);
        _setRoleAdmin(EMERGENCY_ROLE, GOVERNER_ROLE);
        flashLoan = _flashLoan;
    }

    function setMaxNumHoldingPositions(uint256 _maxNumHoldingPositions) external onlyRole(MAINTAINER_ROLE) {
        require(_maxNumHoldingPositions <= MAX_NUM_HOLDING_POSITIONS);
        maxNumHoldingPositions = _maxNumHoldingPositions;
    }

    function setFlashLoanAddress(address _flashLoan) external onlyRole(MAINTAINER_ROLE) {
        emit updateFlashloanAddress(_flashLoan, flashLoan);
        flashLoan = _flashLoan;
    }

    /*
    * @dev This function is used to add a new vault
    * @param vaultId The id of the vault
    * @param _vaultManager The address of the vault manager contract
    * @param _baseToken The address of the base token of the vault
    * @param _governer The address of the governer
    * @param _maintainer The address of the maintainer
    * @param _maintainerWithoutTimelock The address of the maintainer without time lock
    * @param _keeperContract The address of the keeper contract
    * @param _watcher The address of the watcher
    * @param _emergency The address of the emergency
    * @param _trustedTokens An array of trusted tokens
    * @dev This function can only be called by the maintainer (which is a timelocked role)
    * @dev adds the accounting manager as a connector and enables it
    * @dev adds the base token as a trusted token for the accounting manager
    * @dev adds one dummy holding position to the vault so it can be used as a placeholder at index 0 of the holdingPositions array
    */
    function addVault(
        uint256 vaultId,
        address _accountingManager,
        address _baseToken,
        address _governer,
        address _maintainer,
        address _maintainerWithoutTimelock,
        address _keeperContract,
        address _watcher,
        address _emergency,
        address[] calldata _trustedTokens
    ) external onlyRole(MAINTAINER_ROLE) {
        if (vaults[vaultId].accountManager != address(0)) revert AlreadyExists();
        Vault storage vault = vaults[vaultId];
        require(_governer != address(0));
        require(_accountingManager != address(0));
        require(_baseToken != address(0));
        require(_maintainer != address(0));
        require(_keeperContract != address(0));
        require(_watcher != address(0));

        vault.accountManager = _accountingManager;
        vault.baseToken = _baseToken;
        vault.governer = _governer;
        vault.maintainer = _maintainer;
        vault.maintainerWithoutTimeLock = _maintainerWithoutTimelock;
        vault.keeperContract = _keeperContract;
        vault.watcherContract = _watcher;
        vault.emergency = _emergency;
        // Enable the accounting manager connector so the vault can use the "getValue" function of the accounting manager for calculating the value of tokens
        vault.connectors[vault.accountManager].enabled = true;
        vault.enabled = true;
        for (uint256 i = 0; i < _trustedTokens.length; i++) {
            vault.connectors[vault.accountManager].trustedTokens[_trustedTokens[i]] = true;
        }
        vault.holdingPositions.push(HoldingPI(address(0), address(0), bytes32(0), "", "", type(uint256).max));
        emit VaultAdded(vaultId, _accountingManager, _baseToken, _trustedTokens);
        emit VaultAddressesChanged(
            vaultId, _governer, _maintainer, _maintainerWithoutTimelock, _keeperContract, _watcher, _emergency
        );
    }

    /*
    * @dev The function is used to change the governer of a vault
    * @param vaultId The id of the vault
    * @param _governer The address of the new governer
    * @param _maintainer The address of the new maintainer
    * @param _maintainerWithoutTimelock The address of the new maintainer without time lock
    * @param _keeperContract The address of the new keeper contract
    * @param _watcher The address of the new watcher
    * @param _emergency The address of the new emergency
    */
    function changeVaultAddresses(
        uint256 vaultId,
        address _governer,
        address _maintainer,
        address _maintainerWithoutTimelock,
        address _keeperContract,
        address _watcher,
        address _emergency
    ) external onlyVaultGoverner(vaultId) vaultExists(vaultId) {
        require(_governer != address(0));
        require(_maintainer != address(0));
        require(_keeperContract != address(0));
        require(_watcher != address(0));

        vaults[vaultId].governer = _governer;
        vaults[vaultId].maintainer = _maintainer;
        vaults[vaultId].maintainerWithoutTimeLock = _maintainerWithoutTimelock;
        vaults[vaultId].keeperContract = _keeperContract;
        vaults[vaultId].watcherContract = _watcher;
        vaults[vaultId].emergency = _emergency;
        emit VaultAddressesChanged(
            vaultId, _governer, _maintainer, _maintainerWithoutTimelock, _keeperContract, _watcher, _emergency
        );
    }

    /*
    * @dev This function is used to add new connectors to a vault
    * @param vaultId The id of the vault
    * @param _connectorAddresses An array of connector addresses
    */
    function addConnector(uint256 vaultId, address[] calldata _connectorAddresses, bool[] calldata _enableds)
        external
        onlyVaultMaintainer(vaultId)
        vaultExists(vaultId)
    {
        Vault storage vault = vaults[vaultId];
        for (uint256 i = 0; i < _connectorAddresses.length; i++) {
            vault.connectors[_connectorAddresses[i]].enabled = _enableds[i];
            emit ConnectorAdded(vaultId, _connectorAddresses[i]);
        }
    }

    /*
    * @dev This function is used to add or remove new trusted tokens to an specific connector
    * @param vaultId The id of the vault
    * @param _connectorAddress The address of the connector
    * @param _tokens An array of token addresses
    * @param _trusteds An array of booleans indicating if the token is trusted or not
    */
    function updateConnectorTrustedTokens(
        uint256 vaultId,
        address _connectorAddress,
        address[] calldata _tokens,
        bool trusted
    ) external onlyVaultMaintainer(vaultId) vaultExists(vaultId) {
        Vault storage vault = vaults[vaultId];
        for (uint256 i = 0; i < _tokens.length; i++) {
            vault.connectors[_connectorAddress].trustedTokens[_tokens[i]] = trusted;
        }
        emit ConnectorTrustedTokensUpdated(vaultId, _connectorAddress, _tokens, trusted);
    }

    /*
    * @dev This function is used to get the information of a vault
    * @param vaultId The id of the vault
    */
    function getPositionBP(uint256 vaultId, bytes32 _positionId) public view returns (PositionBP memory) {
        return vaults[vaultId].trustedPositionsBP[_positionId];
    }

    /*
    * @dev This function is used to add trusted positions to a vault
    * @param vaultId The id of the vault
    * @param _positionTypeId The id of the position type
    * @param calculatorConnector The address of the calculator connector
    * @param onlyOwner A boolean indicating if the position can only be managed by the owner
    * @param _isDebt A boolean indicating if the position is a debt
    * @param _data Additional data that the connector needs to manage the position
    * @param _additionalData Additional data that the connector needs to manage the position
    */
    function addTrustedPosition(
        uint256 vaultId,
        uint256 _positionTypeId,
        address calculatorConnector,
        bool onlyOwner,
        bool _isDebt,
        bytes calldata _data,
        bytes calldata _additionalData
    ) external onlyVaultMaintainerWithoutTimeLock(vaultId) vaultExists(vaultId) nonReentrant {
        Vault storage vault = vaults[vaultId];
        bytes32 positionId = calculatePositionId(calculatorConnector, _positionTypeId, _data);
        {
            if (vault.trustedPositionsBP[positionId].isEnabled) revert AlreadyExists();
            if (vault.connectors[calculatorConnector].enabled == false) revert NotExist();
            address[] memory usingTokens = IConnector(calculatorConnector).getUnderlyingTokens(_positionTypeId, _data);
            for (uint256 i = 0; i < usingTokens.length; i++) {
                if (!isTokenTrusted(vaultId, usingTokens[i], calculatorConnector)) {
                    revert TokenNotTrusted(usingTokens[i]);
                }
            }

            vault.trustedPositionsBP[positionId] =
                PositionBP(calculatorConnector, _positionTypeId, onlyOwner, true, _isDebt, _data, _additionalData);
        }
        emit TrustedPositionAdded(vaultId, positionId, calculatorConnector, _positionTypeId, onlyOwner, _isDebt, _data);
    }

    // @dev This function is used to remove trusted positions from a vault
    function removeTrustedPosition(uint256 vaultId, bytes32 _positionId)
        external
        onlyVaultMaintainer(vaultId)
        vaultExists(vaultId)
    {
        Vault storage vault = vaults[vaultId];
        if (!vault.trustedPositionsBP[_positionId].isEnabled) revert NotExist();
        uint256 length = vault.holdingPositions.length;
        for (uint256 i = 0; i < length; i++) {
            if (vault.holdingPositions[i].positionId == _positionId) {
                revert CannotRemovePosition(vaultId, _positionId);
            }
        }
        emit TrustedPositionRemoved(vaultId, _positionId);
        delete vault.trustedPositionsBP[_positionId];
    }

    /*
    * @dev This function is used to update the information of an holding position (holding position is a position that the connector is holding)
    * @param vault The vault struct
    * @param vaultId The id of the vault
    * @param _positionId The id of the position (in trustedPositionsBP mapping)
    * @param d data is the information that represents the position (e.g. the address of the pool in curve connector, the address of the pool in uniswap connector, etc.)
    * @param AD additionalData is the information that the connector needs to manage the position
    * @param index The index of the position in the holdingPositions array
    * @param holdingPositionId The id of the holding position (calculated using the positionId, the connector and the data)
    */
    function updateHoldingPosition(
        Vault storage vault,
        uint256 vaultId,
        bytes32 _positionId,
        bytes calldata d,
        bytes calldata AD,
        uint256 index,
        bytes32 holdingPositionId
    ) internal returns (uint256) {
        emit HoldingPositionUpdated(vaultId, _positionId, d, AD, false, index);

        if (index == 0) {
            if (!isPositionTrustedForConnector(vaultId, _positionId, msg.sender)) {
                revert InvalidPosition(_positionId);
            }
            if (vault.holdingPositions.length >= maxNumHoldingPositions) {
                revert TooManyPositions();
            }
            vault.isPositionUsed[holdingPositionId] = vault.holdingPositions.length;
            vault.holdingPositions.push(
                HoldingPI(
                    vaults[vaultId].trustedPositionsBP[_positionId].calculatorConnector,
                    msg.sender,
                    _positionId,
                    d,
                    AD,
                    type(uint256).max
                )
            );
            return vault.holdingPositions.length - 1;
        }
        vault.holdingPositions[index].additionalData = AD;
        return index;
    }

    /*
    * @dev This function is used to update the information of an holding position (holding position is a position that the connector is holding) 
    * @param vaultId The id of the vault
    * @param positionIndex The index of the position in the holdingPositions array
    * @param _data Additional data that the connector needs to manage the position
    * @param removePosition A boolean indicating if the position should be removed
    */
    function updateHoldingPosition(
        uint256 vaultId,
        bytes32 _positionId,
        bytes calldata _data,
        bytes calldata additionalData,
        bool removePosition
    ) public vaultExists(vaultId) returns (uint256) {
        Vault storage vault = vaults[vaultId];
        if (!vault.connectors[msg.sender].enabled) revert UnauthorizedAccess();
        if (!vault.trustedPositionsBP[_positionId].isEnabled) revert InvalidPosition(_positionId);
        bytes32 holdingPositionId = keccak256(abi.encode(msg.sender, _positionId, _data));
        uint256 positionIndex = vault.isPositionUsed[holdingPositionId];
        if (positionIndex == 0 && removePosition) return type(uint256).max;
        if (removePosition) {
            if (positionIndex < vault.holdingPositions.length - 1) {
                vault.holdingPositions[positionIndex] = vault.holdingPositions[vault.holdingPositions.length - 1];
                vault.isPositionUsed[keccak256(
                    abi.encode(
                        vault.holdingPositions[positionIndex].calculatorConnector,
                        vault.holdingPositions[positionIndex].positionId,
                        vault.holdingPositions[positionIndex].data
                    )
                )] = positionIndex;
            }
            vault.holdingPositions.pop();
            vault.isPositionUsed[holdingPositionId] = 0;
            emit HoldingPositionUpdated(vaultId, _positionId, _data, additionalData, removePosition, positionIndex);
            return type(uint256).max;
        }
        return
            updateHoldingPosition(vault, vaultId, _positionId, _data, additionalData, positionIndex, holdingPositionId);
    }

    /// @dev Same as updateHoldingPosition but with a positionTimestamp parameter
    /// @dev in scenarios where the positionTimestamp is not the current time (e.g. when we have positions on other chains)
    function updateHoldingPostionWithTime(
        uint256 vaultId,
        bytes32 _positionId,
        bytes calldata _data,
        bytes calldata additionalData,
        bool removePosition,
        uint256 positionTimestamp
    ) external vaultExists(vaultId) {
        uint256 positionIndex = updateHoldingPosition(vaultId, _positionId, _data, additionalData, removePosition);
        if (positionIndex != type(uint256).max) {
            vaults[vaultId].holdingPositions[positionIndex].positionTimestamp = positionTimestamp;
        }
    }
    // -------------------- VIEW FUNCTIONS --------------------
    /*
    * @dev This function is used to get the index of a holding position
    * @param vaultId The id of the vault
    * @param _positionId The id of the position
    * @param _connector The address of the connector
    * @param data Additional data used to calculate the holding position id
    * @return The index of the holding position
    * @dev Index 0 means that the position is not being used
    */

    function getHoldingPositionIndex(uint256 vaultId, bytes32 _positionId, address _connector, bytes memory data)
        public
        view
        returns (uint256)
    {
        bytes32 holdingPositionId = keccak256(abi.encode(_connector, _positionId, data));
        return vaults[vaultId].isPositionUsed[holdingPositionId];
    }
    /**
     * @dev This function is used to get the information of a holding position
     * @param vaultId The id of the vault
     * @param i The index of the holding position
     */

    function getHoldingPosition(uint256 vaultId, uint256 i) public view returns (HoldingPI memory) {
        return vaults[vaultId].holdingPositions[i];
    }
    /**
     * @dev This function is used to get the information of all the holding positions
     * @param vaultId The id of the vault
     */

    function getHoldingPositions(uint256 vaultId) public view returns (HoldingPI[] memory) {
        return vaults[vaultId].holdingPositions;
    }
    /**
     * @notice This function is used to check if a position is trusted
     * @param vaultId The id of the vault
     * @param _positionId The id of the position
     * @return A boolean indicating if the position is trusted
     */

    function isPositionTrusted(uint256 vaultId, bytes32 _positionId) public view returns (bool) {
        return vaults[vaultId].trustedPositionsBP[_positionId].isEnabled;
    }
    /**
     * @notice This function is used to check if a position is trusted for a specific connector
     * @param vaultId The id of the vault
     * @param _positionId The id of the position
     * @param connector The address of the connector
     */

    function isPositionTrustedForConnector(uint256 vaultId, bytes32 _positionId, address connector)
        public
        view
        returns (bool)
    {
        PositionBP memory position = vaults[vaultId].trustedPositionsBP[_positionId];
        return position.isEnabled && (!position.onlyOwner || position.calculatorConnector == connector);
    }
    /**
     * @notice This function is used to get the addresses of the governance contracts
     * @param vaultId The id of the vault
     */

    function getGovernanceAddresses(uint256 vaultId)
        public
        view
        returns (address, address, address, address, address, address)
    {
        return (
            vaults[vaultId].governer,
            vaults[vaultId].maintainer,
            vaults[vaultId].maintainerWithoutTimeLock,
            vaults[vaultId].keeperContract,
            vaults[vaultId].watcherContract,
            vaults[vaultId].emergency
        );
    }
    /**
     * @notice This function is used to check if a token is trusted for a specific connector
     * @param vaultId The id of the vault
     * @param token The address of the token
     * @param connector The address of the connector
     */

    function isTokenTrusted(uint256 vaultId, address token, address connector) public view returns (bool) {
        return (
            vaults[vaultId].connectors[vaults[vaultId].accountManager].trustedTokens[token]
                || vaults[vaultId].connectors[connector].trustedTokens[token]
        );
    }
    /**
     * @dev Calculates a unique ID for a position.
     *
     * @param calculatorConnector The address of the calculator connector contract.
     * @param positionTypeId The ID of the position type.
     * @param data Additional data used to calculate the position ID.
     *
     * @return bytes32 The unique position ID.
     */

    function calculatePositionId(address calculatorConnector, uint256 positionTypeId, bytes memory data)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(calculatorConnector, positionTypeId, data));
    }
    /**
     * @notice This function is used to check if a connector is active
     * @param vaultId The id of the vault
     * @param connectorAddress The address of the connector
     */

    function isAnActiveConnector(uint256 vaultId, address connectorAddress) public view returns (bool) {
        return vaults[vaultId].connectors[connectorAddress].enabled;
    }
    /**
     * @notice This function is used to check if a position is a debt position
     * @param vaultId The id of the vault
     * @param _positionId The id of the position
     */

    function isPositionDebt(uint256 vaultId, bytes32 _positionId) public view returns (bool) {
        return vaults[vaultId].trustedPositionsBP[_positionId].isDebt;
    }
    /**
     * @notice This function is used to get the addresses of the accounting manager and the base token
     * @param vaultId The id of the vault
     */

    function getVaultAddresses(uint256 vaultId) public view returns (address, address) {
        return (vaults[vaultId].accountManager, vaults[vaultId].baseToken);
    }
    /**
     * @notice This function is used to check if an address is trusted (account manager or an active connector)
     * @param vaultId The id of the vault
     * @param addr The address to check
     */

    function isAddressTrusted(uint256 vaultId, address addr) public view returns (bool) {
        if (addr == vaults[vaultId].accountManager) return true;
        return isAnActiveConnector(vaultId, addr);
    }
}
