// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts-5.0/access/Ownable2Step.sol";
import "@openzeppelin/contracts-5.0/utils/cryptography/ECDSA.sol";
/// @notice  Keepers multisignature wallet with a set of owners and a threshold for transaction execution

contract Keepers is EIP712, Ownable2Step {
    mapping(address => bool) public isOwner;
    bytes32 public constant TXTYPE_HASH = keccak256(
        "Execute(uint256 nonce,address destination,bytes data,uint256 gasLimit,address executor, uint256 deadline)"
    );
    uint256 public nonce;
    uint8 public threshold;
    uint256 public numOwners;

    event Execute(address indexed destination, bytes data, uint256 gasLimit, address executor, uint256 deadline);
    event UpdateOwners(address[] owners, bool[] addOrRemove);
    event UpdateThreshold(uint8 threshold);

    /**
     * @notice Constructs the Keepers multisignature wallet with a set of owners and a threshold for transaction execution
     * @param _owners An array of addresses that will be the initial owners of the multisig wallet
     * @param _threshold The number of required approvals for a transaction to be executed
     */
    constructor(address[] memory _owners, uint8 _threshold) EIP712("Keepers", "1") Ownable2Step() Ownable(msg.sender) {
        require(_owners.length <= 10 && _threshold <= _owners.length && _threshold > 1);
        for (uint256 i = 0; i < _owners.length; i++) {
            isOwner[_owners[i]] = true;
        }
        numOwners = _owners.length;
        threshold = _threshold;
    }
    /**
     * @notice Updates the set of owners for the multisig wallet, allowing addition or removal of owners
     * @dev Can only be called by the wallet owner. Ensures the number of owners and the threshold are always valid.
     * @param _owners An array of addresses to be added or removed from the set of owners
     * @param addOrRemove An array of booleans corresponding to the addresses in _owners; `true` to add, `false` to remove
     */

    function updateOwners(address[] memory _owners, bool[] memory addOrRemove) public onlyOwner {
        uint256 numOwnersTemp = numOwners;
        for (uint256 i = 0; i < _owners.length; i++) {
            if (addOrRemove[i] && !isOwner[_owners[i]]) {
                isOwner[_owners[i]] = true;
                numOwnersTemp++;
            } else if (!addOrRemove[i] && isOwner[_owners[i]]) {
                isOwner[_owners[i]] = false;
                numOwnersTemp--;
            }
        }
        require(numOwnersTemp <= 10 && threshold <= numOwnersTemp && threshold > 1);
        numOwners = numOwnersTemp;
        emit UpdateOwners(_owners, addOrRemove);
    }
    /**
     * @notice Sets the threshold number of approvals required for transactions to be executed
     * @dev Can only be called by the wallet owner. The threshold must be valid within the current set of owners.
     * @param _threshold The new threshold number
     */

    function setThreshold(uint8 _threshold) public onlyOwner {
        require(_threshold <= numOwners && _threshold > 1);
        threshold = _threshold;
        emit UpdateThreshold(_threshold);
    }
    /**
     * @notice Executes a transaction if it has been approved by the required number of owners
     * @dev Validates the signatures against the transaction details and the current nonce to prevent replay attacks.
     * @param destination The address to which the transaction will be sent
     * @param data The data payload of the transaction (same as msg.data (https://github.com/safe-global/safe-smart-account/blob/2278f7ccd502878feb5cec21dd6255b82df374b5/contracts/base/Executor.sol#L24))
     * @param gasLimit The maximum amount of gas that the transaction is allowed to use
     * @param executor The address executing the transaction, must be an owner
     * @param sigR Array of 'r' components of the signatures
     * @param sigS Array of 's' components of the signatures
     * @param sigV Array of 'v' components of the signatures
     * @dev The execute function incorporates several security measures, including:
     *     - Verification that the msg.sender is an owner.
     *     - Ensuring that the number of signatures (sigR, sigS, sigV) matches the threshold.
     *     - Sequentially verifying each signature to confirm it's valid, from an owner, and not reused within the same transaction (guarding against replay attacks).
     */

    function execute(
        address destination,
        bytes calldata data,
        uint256 gasLimit,
        address executor,
        bytes32[] memory sigR,
        bytes32[] memory sigS,
        uint8[] memory sigV,
        uint256 deadline
    ) public {
        require(isOwner[msg.sender], "Not an owner");
        require(sigR.length == threshold, "Not enough signatures");
        require(sigR.length == sigS.length && sigR.length == sigV.length, "Lengths do not match");
        require(executor == msg.sender, "Invalid executor");
        require(block.timestamp <= deadline, "Transaction expired");
        {
            bytes32 txInputHash =
                keccak256(abi.encode(TXTYPE_HASH, nonce, destination, data, gasLimit, executor, deadline));
            bytes32 totalHash = keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), txInputHash));
            address lastAdd = address(0);
            for (uint256 i = 0; i < threshold;) {
                address recovered = ECDSA.recover(totalHash, sigV[i], sigR[i], sigS[i]);
                require(recovered > lastAdd && isOwner[recovered]);
                lastAdd = recovered;
                unchecked {
                    ++i;
                }
            }

            nonce++;
        }
        emit Execute(destination, data, gasLimit, executor, deadline);
        (bool success,) = destination.call{ gas: gasLimit }(data);
        require(success, "Transaction execution reverted.");
    }
    /**
     * @notice Returns the domain separator used in the EIP712 typed data signing
     * @return The domain separator for the contract
     */

    function domainSeparatorV4() public view returns (bytes32) {
        return _domainSeparatorV4();
    }
}
