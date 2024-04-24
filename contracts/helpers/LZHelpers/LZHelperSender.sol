// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/access/Ownable.sol";
import "../OmniChainHandler/OmnichainManagerNormalChain.sol";
import "../OmniChainHandler/OmnichainManagerBaseChain.sol";
import "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol";

struct ChainInfo {
    uint32 lzChainId;
    address lzHelperAddress;
}

struct VaultInfo {
    uint256 baseChainId;
    address omniChainManager;
}

contract LZHelperSender is OAppSender {
    mapping(uint256 => ChainInfo) public chainInfo; // chainId => ChainInfo
    mapping(uint256 => VaultInfo) public vaultIdToVaultInfo; // vaultId => VaultInfo

    bytes messageSetting;

    error InvalidSender();

    receive() external payable { }

    constructor(address _endpoint, address _owner) OAppSender() OAppCore(_endpoint, _owner) { }
    /**
     * @notice Updates the message setting for LayerZero sends
     * @dev Allows the owner to configure how messages are sent through LayerZero, adjusting parameters like gas limits or message fees.
     * @param _messageSetting The new message settings to be used for LayerZero sends (see https://docs.layerzero.network/contracts/options)
     */

    function updateMessageSetting(bytes memory _messageSetting) public onlyOwner {
        messageSetting = _messageSetting;
    }

    function _payNative(uint256 amount) internal override returns (uint256) {
        return amount;
    }
    /**
     * @notice Registers the destination chain information for a specific blockchain
     * @dev Stores LayerZero-specific identifiers and helper contract addresses for cross-chain communication to a specified chain.
     * @param chainId The native blockchain ID being registered
     * @param lzChainId The corresponding LayerZero chain ID
     * @param lzHelperAddress The address of the helper contract on the destination chain
     */

    function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public onlyOwner {
        require(lzHelperAddress != address(0));
        chainInfo[chainId] = ChainInfo(lzChainId, lzHelperAddress);
    }
    /**
     * @notice Adds information about a vault to enable TVL updates
     * @dev Maps a vault ID to its corresponding base chain ID and omnichain manager contract, setting up the infrastructure for cross-chain TVL updates.
     * @param vaultId The unique identifier for the vault
     * @param baseChainId The blockchain ID where the vault primarily operates (where the accountingManager is deployed)
     * @param omniChainManager The address of the omnichain manager contract associated with the vault
     */

    function addVaultInfo(uint256 vaultId, uint256 baseChainId, address omniChainManager) public onlyOwner {
        vaultIdToVaultInfo[vaultId] = VaultInfo(baseChainId, omniChainManager);
    }
    /**
     * @notice Sends a TVL update for a specified vault to its base chain
     * @dev Constructs and sends a message containing the vault ID, new TVL, and the time of the update through LayerZero. This function can only be called by the vault's omnichain manager.
     * @param vaultId The ID of the vault for which TVL is being updated
     * @param tvl The new Total Value Locked amount
     * @param updateTime The timestamp of the TVL update
     * @dev only the omnichain manager of this vault can call this function
     */

    function updateTVL(uint256 vaultId, uint256 tvl, uint256 updateTime) public {
        if (msg.sender != vaultIdToVaultInfo[vaultId].omniChainManager) revert InvalidSender();

        uint32 lzChainId = chainInfo[vaultIdToVaultInfo[vaultId].baseChainId].lzChainId;
        bytes memory data = abi.encode(vaultId, tvl, updateTime);
        _lzSend(lzChainId, data, messageSetting, MessagingFee(address(this).balance, 0), payable(address(this))); // TODO: send event here
    }
}
