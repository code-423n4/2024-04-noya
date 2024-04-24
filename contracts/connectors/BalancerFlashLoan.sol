// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import { IBalancerVault, IERC20 } from "../external/interfaces/Balancer/IBalancerVault.sol";
import { IFlashLoanRecipient } from "../external/interfaces/Balancer/IFlashLoanRecipient.sol";
import { PositionRegistry, PositionBP } from "../accountingManager/Registry.sol";
import { BaseConnector } from "../helpers/BaseConnector.sol";
import "@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol";

import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

contract BalancerFlashLoan is IFlashLoanRecipient, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IBalancerVault internal vault;
    PositionRegistry public registry;
    address caller;

    error Unauthorized(address sender);

    event MakeFlashLoan(IERC20[] tokens, uint256[] amounts);
    event ReceiveFlashLoan(IERC20[] tokens, uint256[] amounts, uint256[] feeAmounts, bytes userData);

    constructor(address _balancerVault, PositionRegistry _registry) {
        require(_balancerVault != address(0));
        require(address(_registry) != address(0));
        vault = IBalancerVault(_balancerVault);
        registry = _registry;
    }

    /**
     * @notice Make a flash loan
     * @param tokens - tokens to flash loan
     * @param amounts - amounts to flash loan
     * @param userData - user data for the flash loan (will be decoded after the flash loan is received)
     */
    function makeFlashLoan(IERC20[] memory tokens, uint256[] memory amounts, bytes memory userData)
        external
        nonReentrant
    {
        caller = msg.sender;
        emit MakeFlashLoan(tokens, amounts);
        vault.flashLoan(this, tokens, amounts, userData);
        caller = address(0);
    }

    /**
     * @notice Receive the flash loan
     * @param tokens - tokens to flash loan
     * @param amounts - amounts to flash loan
     * @param feeAmounts - fee amounts to flash loan
     * @param userData - user data for the flash loan (used to execute transactions with the flash loaned tokens)
     */
    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external override {
        emit ReceiveFlashLoan(tokens, amounts, feeAmounts, userData);
        require(msg.sender == address(vault));
        (
            uint256 vaultId,
            address receiver,
            address[] memory destinationConnector,
            bytes[] memory callingData,
            uint256[] memory gas
        ) = abi.decode(userData, (uint256, address, address[], bytes[], uint256[]));
        (,,, address keeperContract,, address emergencyManager) = registry.getGovernanceAddresses(vaultId);
        if (!(caller == keeperContract)) {
            revert Unauthorized(caller);
        }
        if (registry.isAnActiveConnector(vaultId, receiver)) {
            for (uint256 i = 0; i < tokens.length; i++) {
                // send the tokens to the receiver
                tokens[i].safeTransfer(receiver, amounts[i]);
                amounts[i] = amounts[i] + feeAmounts[i];
            }
            for (uint256 i = 0; i < destinationConnector.length; i++) {
                // execute the transactions
                (bool success,) = destinationConnector[i].call{ value: 0, gas: gas[i] }(callingData[i]);
                require(success, "BalancerFlashLoan: Flash loan failed");
            }
            for (uint256 i = 0; i < tokens.length; i++) {
                // send the tokens back to this contract
                BaseConnector(receiver).sendTokensToTrustedAddress(address(tokens[i]), amounts[i], address(this), "");
            }
        }
        for (uint256 i = 0; i < tokens.length; i++) {
            // send the tokens back to the vault
            tokens[i].safeTransfer(msg.sender, amounts[i]);
            require(tokens[i].balanceOf(address(this)) == 0, "BalancerFlashLoan: Flash loan extra tokens");
        }
    }
}
