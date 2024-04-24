// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../../helpers/SwapHandler/GenericSwapAndBridgeHandler.sol";
import "../BaseConnector.sol";

/**
 * @notice OmnichainLogic is a base contract for OmnichainManagerBaseChain and OmnichainManagerNormalChain, which are used to manage cross-chain communication and transactions.
 *     Key Components and Design Considerations
 *     - Mapping Addresses for Cross-Chain Bridges: At its core, the contract uses something called destChainAddress mapping. This is essentially a way to keep track of where assets should be sent across different blockchain networks. It's a crucial part of making sure that when assets are bridged, they end up exactly where they're supposed to, maintaining accuracy across a complex web of chains.
 *
 *     - A Two-Step Approval for Transactions: Before any asset can make the jump to another chain, the contract requires each transaction to be approved not once, but twice. First, someone needs to give the green light indicating that the transaction is okay (that's where updateBridgeTransactionApproval comes into play). Then, and only then, can the actual transaction process begin (startBridgeTransaction). This double-check adds an extra layer of security, ensuring every transaction is intended and verified.
 */
abstract contract OmnichainLogic is BaseConnector {
    using SafeERC20 for IERC20;

    address payable public lzHelper;

    uint256 public constant BRIDGE_TXN_WAITING_TIME = 30 minutes;

    mapping(uint256 => address) public destChainAddress;
    mapping(bytes32 => uint256) public approvedBridgeTXN;

    event UpdateChainInfo(uint256 chainId, address destinationAddress);
    event UpdateBridgeTransactionApproval(bytes32 transactionHash, uint256 timestamp);
    event StartBridgeTransaction(BridgeRequest bridgeRequest, bytes32 transactionHash);

    /**
     * @notice Initializes the OmnichainLogic contract with the address of the LayerZero helper contract and base connector parameters
     * @param _lzHelper Address of the LayerZero helper contract responsible for managing cross-chain communication (in OmnichainManagerNormalChain this is LZHelperSender and in OmnichainManagerBaseChain this is LZHelperReceiver)
     * @param baseConnectorParams Parameters for initializing the base connector functionalities
     */
    constructor(address payable _lzHelper, BaseConnectorCP memory baseConnectorParams)
        BaseConnector(baseConnectorParams)
    {
        lzHelper = _lzHelper;
        require(_lzHelper != address(0));
    }
    /**
     * @notice Updates the address to which bridge transactions will be sent on a specified destination chain
     * @dev This function allows the maintainer to set or update the destination address for each supported chain, facilitating targeted cross-chain transactions.
     * @param chainId The identifier of the destination chain
     * @param destinationAddress The address on the destination chain to which assets will be bridged
     */

    function updateChainInfo(uint256 chainId, address destinationAddress) external onlyMaintainer {
        require(destinationAddress != address(0));
        destChainAddress[chainId] = destinationAddress;
        emit UpdateChainInfo(chainId, destinationAddress);
    }
    /**
     * @notice Marks a bridge transaction as approved or revokes approval based on its current state
     * @dev This toggles the approval state of a bridge transaction identified by its hash. If previously unapproved or expired, it approves it; if already approved, it revokes approval.
     * @param transactionHash The hash of the bridge transaction to be toggled
     */

    function updateBridgeTransactionApproval(bytes32 transactionHash) public onlyManager {
        if (approvedBridgeTXN[transactionHash] != 0) delete approvedBridgeTXN[transactionHash];
        else approvedBridgeTXN[transactionHash] = block.timestamp;
        emit UpdateBridgeTransactionApproval(transactionHash, block.timestamp);
    }
    /**
     * @notice Initiates a bridge transaction if it has been approved and the waiting time has passed
     * @dev Validates the bridge request against approvals and destination chain information before executing the bridge transaction via the `GenericSwapAndBridgeHandler`.
     * @param bridgeRequest A struct containing details of the bridge transaction, including source and destination chain IDs, addresses, and token information
     */

    function startBridgeTransaction(BridgeRequest memory bridgeRequest) public onlyManager nonReentrant {
        bytes32 txn = keccak256(abi.encode(bridgeRequest));
        emit StartBridgeTransaction(bridgeRequest, txn);
        if (approvedBridgeTXN[txn] == 0 || approvedBridgeTXN[txn] + BRIDGE_TXN_WAITING_TIME > block.timestamp) {
            revert IConnector_BridgeTransactionNotApproved(txn);
        }
        if (bridgeRequest.from != address(this)) revert IConnector_InvalidInput();
        if (
            destChainAddress[bridgeRequest.destChainId] == address(0)
                || destChainAddress[bridgeRequest.destChainId] != bridgeRequest.receiverAddress
        ) {
            revert IConnector_InvalidDestinationChain();
        }
        approvedBridgeTXN[txn] = 0;
        swapHandler.executeBridge(bridgeRequest);
        _updateTokenInRegistry(bridgeRequest.inputToken);
    }
}
