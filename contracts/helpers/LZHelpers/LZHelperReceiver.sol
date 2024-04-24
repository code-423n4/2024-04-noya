// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/access/Ownable.sol";
import "../OmniChainHandler/OmnichainManagerBaseChain.sol";
import "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol";

struct ChainInfo {
    uint256 chainId;
    address lzHelperAddress;
}

struct VaultInfo {
    uint256 baseChainId;
    address omniChainManager;
}

contract LZHelperReceiver is OAppReceiver {
    mapping(uint32 => ChainInfo) public chainInfo; // chainId => ChainInfo
    mapping(uint256 => VaultInfo) public vaultIdToVaultInfo; // vaultId => VaultInfo

    error InvalidPayload();

    uint32 constant TVL_UPDATE = 1;
    /**
     * @notice Constructs the LZHelperReceiver contract
     * @param _endpoint The LayerZero endpoint address for cross-chain communication
     * @param _owner The address that will own the LZHelperReceiver contract, typically a governance or deployer address with the ability to execute administrative functions
     */

    constructor(address _endpoint, address _owner) OAppReceiver() OAppCore(_endpoint, _owner) { }

    /**
     * @notice Sets the information for a chain where LayerZero messages can be received from
     * @dev This function allows the contract owner to map a LayerZero chain ID to its corresponding chain information, including the native chain ID and the address of a helper contract specific to LayerZero on that chain.
     * @param chainId The native chain ID of the blockchain (e.g., Ethereum Mainnet, Binance Smart Chain)
     * @param lzChainId The LayerZero chain ID corresponding to the chainId
     * @param lzHelperAddress The address of the helper contract deployed on the chainId that interacts with LayerZero for cross-chain messaging
     */
    function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public onlyOwner {
        require(lzHelperAddress != address(0));
        chainInfo[lzChainId] = ChainInfo(chainId, lzHelperAddress);
    }

    /**
     * @notice Sets the information for a vault where TVL updates can be received from
     * @dev This function allows the contract owner to map a vault ID to its corresponding chain information, including the base chain ID and the address of the OmniChainManager contract that manages the vault on the base chain.
     * @param vaultId The ID of the vault
     * @param baseChainId The native chain ID of the blockchain where the vault is managed
     * @param omniChainManager The address of the OmniChainManager contract that manages the vault on the base chain
     */
    function addVaultInfo(uint256 vaultId, uint256 baseChainId, address omniChainManager) public onlyOwner {
        require(omniChainManager != address(0));
        vaultIdToVaultInfo[vaultId] = VaultInfo(baseChainId, omniChainManager);
    }
    /**
     * @notice Handles the receipt of a cross-chain message via LayerZero
     * @dev Overrides the `_lzReceive` function from `OAppReceiver` to process incoming messages. It's designed to decode the received message containing TVL update information for a specific vault and then call the associated OmnichainManager to update the TVL accordingly.
     * @param _origin Struct containing information about the origin chain of the message, including the LayerZero chain ID and other metadata
     * @param _message The encoded message data containing the vault ID, updated TVL value, and the timestamp of the update
     *
     * This function decodes the message and then utilizes the `OmnichainManagerBaseChain` contract associated with the specified vault to update its TVL. It ensures that messages are processed only from configured chains and vaults to maintain data integrity and security.
     */

    function _lzReceive(Origin calldata _origin, bytes32, bytes calldata _message, address, bytes calldata)
        internal
        override
    {
        (uint256 vaultId, uint256 tvl, uint256 updateTime) = abi.decode(_message, (uint256, uint256, uint256));
        uint256 _srcChainId = chainInfo[_origin.srcEid].chainId;
        OmnichainManagerBaseChain(vaultIdToVaultInfo[vaultId].omniChainManager).updateTVL(_srcChainId, tvl, updateTime);
    }
}
