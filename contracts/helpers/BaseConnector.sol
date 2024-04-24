// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../interface/IConnector.sol";
import { NoyaGovernanceBase } from "../governance/NoyaGovernanceBase.sol";
import { PositionRegistry, PositionBP } from "../accountingManager/Registry.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-5.0/token/ERC721/utils/ERC721Holder.sol";
import { SwapAndBridgeHandler, SwapRequest } from "../helpers/SwapHandler/GenericSwapAndBridgeHandler.sol";
import "../interface/valueOracle/INoyaValueOracle.sol";
import "../governance/Watchers.sol";
import "@openzeppelin/contracts-5.0/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol";

struct BaseConnectorCP {
    PositionRegistry registry;
    uint256 vaultId;
    SwapAndBridgeHandler swapHandler;
    INoyaValueOracle valueOracle;
}

contract BaseConnector is NoyaGovernanceBase, IConnector, ReentrancyGuard {
    using SafeERC20 for IERC20;

    SwapAndBridgeHandler public swapHandler;
    INoyaValueOracle public valueOracle;

    uint256 public MINIMUM_HEALTH_FACTOR = 15e17;
    uint256 public minimumHealthFactor;

    uint256 public DUST_LEVEL = 1;

    constructor(BaseConnectorCP memory params) NoyaGovernanceBase(params.registry, params.vaultId) {
        swapHandler = params.swapHandler;
        valueOracle = params.valueOracle;
        minimumHealthFactor = MINIMUM_HEALTH_FACTOR;
    }

    /**
     * @notice Updates the minimum health factor required for operations
     * @dev Can only be called by the contract maintainer
     * @param _minimumHealthFactor The new minimum health factor
     * @dev for the connectors that borrowing is allowed, the health factor should be higher than this value (so we keep a safe margin)
     */
    function updateMinimumHealthFactor(uint256 _minimumHealthFactor) external onlyMaintainer {
        if (_minimumHealthFactor < MINIMUM_HEALTH_FACTOR) {
            revert IConnector_LowHealthFactor(_minimumHealthFactor);
        }
        minimumHealthFactor = _minimumHealthFactor;
        emit MinimumHealthFactorUpdated(_minimumHealthFactor);
    }

    /**
     * @notice Updates the SwapAndBridgeHandler contract address
     * @param _swapHandler The new SwapAndBridgeHandler contract address
     * @dev swap handler is used to execute swaps and bridges
     */
    function updateSwapHandler(address payable _swapHandler) external onlyMaintainer {
        swapHandler = SwapAndBridgeHandler(_swapHandler);
        emit SwapHandlerUpdated(_swapHandler);
    }
    /**
     * @notice Updates the ValueOracle contract address
     * @param _valueOracle The new ValueOracle contract address
     */

    function updateValueOracle(address _valueOracle) external onlyMaintainer {
        valueOracle = INoyaValueOracle(_valueOracle);
        emit ValueOracleUpdated(_valueOracle);
    }
    /**
     * @notice Sends tokens to a trusted address
     * @param token The token address
     * @param amount The amount of tokens to send
     * @param caller The caller address (used to verify the caller is this contract in the swapHandler)
     * @param data Additional data used in the transfer
     * @return The actual amount of tokens sent
     * @dev This function is used to send tokens to trusted addresses (vault, accounting manager, swap handler)
     * @dev in case the caller is the accounting manager, the function will check with the watcher contract the number of tokens to withdraw
     * @dev in case the caller is a connector, the function will check if the caller is an active connector
     * @dev in case the caller is the swap handler, the function will check if the caller is a valid route
     */

    function sendTokensToTrustedAddress(address token, uint256 amount, address caller, bytes memory data)
        external
        returns (uint256)
    {
        emit TransferTokensToTrustedAddress(token, amount, caller, data);
        (address accountingManager,) = registry.getVaultAddresses(vaultId);
        if (msg.sender == accountingManager) {
            (,,,, address watcherContract,) = registry.getGovernanceAddresses(vaultId);

            (uint256 newAmount, bytes memory newData) = abi.decode(data, (uint256, bytes));
            Watchers(watcherContract).verifyRemoveLiquidity(amount, newAmount, newData);

            IERC20(token).safeTransfer(address(accountingManager), newAmount);
            amount = newAmount;
        } else if (registry.isAnActiveConnector(vaultId, msg.sender) || msg.sender == registry.flashLoan()) {
            IERC20(token).safeTransfer(address(msg.sender), amount);
        } else {
            uint256 routeId = abi.decode(data, (uint256));
            swapHandler.verifyRoute(routeId, msg.sender);
            if (caller != address(this)) revert IConnector_InvalidAddress(caller);
            IERC20(token).safeTransfer(msg.sender, amount);
        }
        _updateTokenInRegistry(token);
        return amount;
    }
    /**
     * @notice Transfers position to another connector
     * @param tokens The addresses of tokens involved
     * @param amounts The amounts for each token
     * @param data Additional data for liquidity adding
     * @param connector The target connector address
     * @dev the flow is :
     * @dev 1. check if the connector is active
     * @dev 2. call the addLiquidity function in the target connector
     * @dev 3. destination connector will call the sendTokensToTrustedAddress function to transfer the tokens
     * @dev 4. update the position in the registry for both connectors
     */

    function transferPositionToAnotherConnector(
        address[] memory tokens,
        uint256[] memory amounts,
        bytes memory data,
        address connector
    ) external onlyManager nonReentrant {
        emit TransferPositionToConnector(tokens, amounts, connector, data);
        if (registry.isAnActiveConnector(vaultId, connector)) {
            IConnector(connector).addLiquidity(tokens, amounts, data);
        }
    }

    // @dev the following functions are used to manage holding tokens in the registry
    function _updateTokenInRegistry(address token, bool remove) internal {
        (address accountingManager,) = registry.getVaultAddresses(vaultId);
        // the value function is inside the accounting manager contract (so we can use the accounting manager address as the calculator connector)
        bytes32 positionId = registry.calculatePositionId(accountingManager, 0, abi.encode(token));
        // if the token is not in the registry, we add it or remove it if the remove flag is true
        uint256 positionIndex =
            registry.getHoldingPositionIndex(vaultId, positionId, address(this), abi.encode(address(this)));
        if ((positionIndex == 0 && !remove) || (positionIndex > 0 && remove)) {
            emit UpdateTokenInRegistry(token, remove);
            registry.updateHoldingPosition(vaultId, positionId, abi.encode(address(this)), "", remove);
        }
    }
    /**
     * @notice Updates the token registry to reflect the current balance of a specified token. It can add a new token to the registry or remove a token with zero balance.
     * @dev This function is called to ensure the registry is accurate after liquidity is added, removed, or swaps are performed. It should reflect the current state of tokens held by this connector.
     * @param token The address of the token to update in the registry.
     */

    function updateTokenInRegistry(address token) public onlyManager {
        _updateTokenInRegistry(token);
    }
    /// @notice adds or removes the token position to the registry based on the balance of the token

    function _updateTokenInRegistry(address token) internal {
        _updateTokenInRegistry(token, IERC20(token).balanceOf(address(this)) == 0);
    }
    /**
     * @notice Adds liquidity to this connector
     * @param tokens The addresses of tokens to add as liquidity
     * @param amounts The amounts of each token to add
     * @param data Additional data needed for adding liquidity
     * @dev This function is called to add liquidity to this connector. It should be implemented in the connector contract to handle the specific liquidity adding process for the connector by overriding the _addLiquidity function (optional).
     */

    function addLiquidity(address[] memory tokens, uint256[] memory amounts, bytes memory data)
        external
        override
        nonReentrant
    {
        if (!registry.isAddressTrusted(vaultId, msg.sender)) {
            revert IConnector_InvalidAddress(msg.sender);
        }

        for (uint256 i = 0; i < tokens.length; i++) {
            // gather all of the tokens
            uint256 _balance = IERC20(tokens[i]).balanceOf(address(this));
            ITokenTransferCallBack(msg.sender).sendTokensToTrustedAddress(tokens[i], amounts[i], msg.sender, "");
            uint256 _balanceAfter = IERC20(tokens[i]).balanceOf(address(this));
            if (_balanceAfter < amounts[i] + _balance) {
                revert IConnector_InsufficientDepositAmount(_balanceAfter - _balance, amounts[i]);
            }
        }
        _addLiquidity(tokens, amounts, data); // call the specific implementation if the connector needs to do something after the liquidity is added

        for (uint256 i = 0; i < tokens.length; i++) {
            _updateTokenInRegistry(tokens[i]); // update the token in the registry
        }
        emit AddLiquidity(tokens, amounts, data);
    }

    /**
     * @notice Executes swaps for holdings from one set of tokens to another
     * @param tokensIn The addresses of input tokens for the swaps
     * @param tokensOut The addresses of output tokens for the swaps
     * @param amountsIn The input amounts for each swap
     * @param swapData The data required for executing each swap
     * @param routeIds The route IDs for each swap (used to verify the route in the swapHandler)
     * @dev the check slippage is set to true, so the swapHandler will revert if the slippage is higher than the allowed
     */
    function swapHoldings(
        address[] memory tokensIn,
        address[] memory tokensOut,
        uint256[] memory amountsIn,
        bytes[] memory swapData,
        uint256[] memory routeIds
    ) external onlyManager nonReentrant {
        for (uint256 i = 0; i < tokensIn.length; i++) {
            _executeSwap(
                SwapRequest(address(this), routeIds[i], amountsIn[i], tokensIn[i], tokensOut[i], swapData[i], true, 0)
            );
            _updateTokenInRegistry(tokensIn[i]);
            _updateTokenInRegistry(tokensOut[i]);
            emit SwapHoldings(tokensIn[i], tokensOut[i], amountsIn[i], swapData[i]);
        }
    }

    function _executeSwap(SwapRequest memory swapRequest) internal returns (uint256 amountOut) {
        amountOut = swapHandler.executeSwap(swapRequest);
    }
    /**
     * @notice Retrieves the underlying tokens associated with a position type and data
     * @param positionTypeId The type ID of the position
     * @param data Additional data relevant to the position
     * @return An array of addresses of the underlying tokens
     * @dev each connector should implement this function to return the underlying tokens for the position type and data
     */

    function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) public view returns (address[] memory) {
        if (positionTypeId == 0) {
            address[] memory tokens = new address[](1);
            tokens[0] = abi.decode(data, (address));
            return tokens;
        }
        return _getUnderlyingTokens(positionTypeId, data);
    }
    /**
     * @notice the TVLHelper library uses this function to calculate the TVL of a position
     * @param p The holding position information
     * @param baseToken The base currency for the TVL calculation
     * @return The TVL of the position in the base currency units
     * @dev each connector should implement this function to calculate the TVL of the position
     * @dev the holding position is the data that was sent to the connector to create the position
     */

    function getPositionTVL(HoldingPI memory p, address baseToken) public view returns (uint256) {
        return _getPositionTVL(p, baseToken);
    }

    function _getValue(address token, address baseToken, uint256 amount) internal view returns (uint256) {
        if (token == baseToken) {
            return amount;
        }
        if (amount == 0) {
            return 0;
        }
        return valueOracle.getValue(token, baseToken, amount);
    }

    function _getUnderlyingTokens(uint256, bytes memory) public view virtual returns (address[] memory) {
        return new address[](0);
    }

    function _addLiquidity(address[] memory, uint256[] memory, bytes memory) internal virtual returns (bool) {
        return true;
    }

    function _getPositionTVL(HoldingPI memory, address) public view virtual returns (uint256 tvl) {
        return 0;
    }
    /// @notice is used to approve the _spender to spend the _amount of the _token
    /// @dev It uses the forceApprove function so it's safe to use it with tokens with special approval logic (USDT)

    function _approveOperations(address _token, address _spender, uint256 _amount) internal virtual {
        uint256 currentAllowance = IERC20(_token).allowance(address(this), _spender);
        if (currentAllowance >= _amount) {
            return;
        }
        IERC20(_token).forceApprove(_spender, _amount);
    }

    function _revokeApproval(address _token, address _spender) internal virtual {
        IERC20(_token).forceApprove(_spender, 0);
    }
}
