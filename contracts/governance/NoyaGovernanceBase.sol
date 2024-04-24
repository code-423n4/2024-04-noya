// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import { PositionRegistry, PositionBP } from "../accountingManager/Registry.sol";

contract NoyaGovernanceBase {
    PositionRegistry public registry;
    uint256 public vaultId;
    /**
     * @notice Reports an unauthorized access attempt
     * @param sender The address of the caller attempting to access a restricted function
     */

    error NoyaGovernance_Unauthorized(address sender);
    /**
     * @notice Initializes a new NoyaGovernanceBase contract with a registry and a vault ID
     * @param _registry The PositionRegistry contract that stores governance addresses and other configurations for vaults
     * @param _vaultId The unique identifier of the vault this contract will interact with
     */

    constructor(PositionRegistry _registry, uint256 _vaultId) {
        require(address(_registry) != address(0));
        registry = _registry;
        vaultId = _vaultId;
    }
    /**
     * @notice Ensures the caller is the designated manager for the vault, either the keeper contract or the emergency manager
     * @dev Uses governance addresses from the registry to validate the caller's role
     */

    modifier onlyManager() {
        (,,, address keeperContract,, address emergencyManager) = registry.getGovernanceAddresses(vaultId);
        if (!(msg.sender == keeperContract || msg.sender == emergencyManager || msg.sender == registry.flashLoan())) {
            revert NoyaGovernance_Unauthorized(msg.sender);
        }
        _;
    }
    /**
     * @notice Ensures the caller is the emergency manager for the vault
     * @dev Uses governance addresses from the registry to validate the caller's role
     */

    modifier onlyEmergency() {
        (,,,,, address emergencyManager) = registry.getGovernanceAddresses(vaultId);
        if (msg.sender != emergencyManager) revert NoyaGovernance_Unauthorized(msg.sender);
        _;
    }
    /**
     * @notice Ensures the caller is either the emergency manager or the watcher contract for the vault
     * @dev Uses governance addresses from the registry to validate the caller's role
     */

    modifier onlyEmergencyOrWatcher() {
        (,,,, address watcherContract, address emergencyManager) = registry.getGovernanceAddresses(vaultId);
        if (msg.sender != emergencyManager && msg.sender != watcherContract) {
            revert NoyaGovernance_Unauthorized(msg.sender);
        }
        _;
    }
    /**
     * @notice Ensures the caller is either the maintainer or the emergency manager for the vault
     * @dev Uses governance addresses from the registry to validate the caller's role
     */

    modifier onlyMaintainerOrEmergency() {
        (, address maintainer,,,, address emergencyManager) = registry.getGovernanceAddresses(vaultId);
        if (msg.sender != maintainer && msg.sender != emergencyManager) revert NoyaGovernance_Unauthorized(msg.sender);
        _;
    }
    /**
     * @notice Ensures the caller is the maintainer for the vault
     * @dev Uses governance addresses from the registry to validate the caller's role
     */

    modifier onlyMaintainer() {
        (, address maintainer,,,,) = registry.getGovernanceAddresses(vaultId);
        if (msg.sender != maintainer) revert NoyaGovernance_Unauthorized(msg.sender);
        _;
    }
    /**
     * @notice Ensures the caller is the governance (governer) for the vault
     * @dev Uses governance addresses from the registry to validate the caller's role
     */

    modifier onlyGovernance() {
        (address governer,,,,,) = registry.getGovernanceAddresses(vaultId);
        if (msg.sender != governer) revert NoyaGovernance_Unauthorized(msg.sender);
        _;
    }
}
