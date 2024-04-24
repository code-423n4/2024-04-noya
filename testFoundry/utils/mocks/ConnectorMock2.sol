// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import {
    SwapAndBridgeHandler,
    SwapRequest,
    BridgeRequest
} from "contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol";
import { ITokenTransferCallBack } from "contracts/interface/ITokenTransferCallBack.sol";
import { HoldingPI } from "contracts/interface/IConnector.sol";
import { PositionRegistry } from "contracts/accountingManager/Registry.sol";

contract ConnectorMock2 {
    using SafeERC20 for IERC20;

    uint256 public vaultId = 0;
    PositionRegistry public registry;

    uint256 public constant positionType = 1;

    constructor(address _registry, uint256 _vaultId) {
        registry = PositionRegistry(_registry);
        vaultId = _vaultId;
    }

    function sendTokensToTrustedAddress(address token, uint256 amount, address caller, bytes memory data)
        external
        returns (uint256)
    {
        if (data.length == 0) {
            IERC20(token).safeTransfer(msg.sender, amount);
            return amount;
        }
        (uint256 amountToSend, uint256 amountToReturn) = abi.decode(data, (uint256, uint256));
        IERC20(token).safeTransfer(msg.sender, amountToSend);
        return amountToReturn;
    }

    function addLiquidity(address[] memory tokens, uint256[] memory amounts, bytes memory data) external {
        for (uint256 i = 0; i < tokens.length; i++) {
            // gather all of the tokens

            ITokenTransferCallBack(msg.sender).sendTokensToTrustedAddress(tokens[i], amounts[i], msg.sender, "");
        }
        for (uint256 i = 0; i < tokens.length; i++) {
            _updateTokenInRegistry(tokens[i]); // update the token in the registry
        }
    }

    function updatePositionToRegistryUsingType(bytes32 _positionId, bytes memory data, bool remove) external {
        registry.updateHoldingPosition(vaultId, _positionId, data, "", remove);
    }

    function addPositionToRegistryUsingType(bytes32 _positionId, bytes memory data) external {
        registry.updateHoldingPosition(vaultId, _positionId, data, "", false);
    }

    function addPositionToRegistryUsingType(uint256 _positionType, bytes memory data) external {
        registry.updateHoldingPosition(
            vaultId, registry.calculatePositionId(address(this), _positionType, ""), data, "", false
        );
    }

    function addPositionToRegistry(bytes memory data) external {
        registry.updateHoldingPosition(
            vaultId, registry.calculatePositionId(address(this), positionType, ""), data, "", false
        );
    }

    function getPositionTVL(HoldingPI memory p, address baseToken) public view returns (uint256) {
        return 0;
    }

    function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) public view returns (address[] memory) {
        return new address[](0);
    }

    function _updateTokenInRegistry(address token, bool remove) internal {
        (address accountingManager,) = registry.getVaultAddresses(vaultId);
        // the value function is inside the accounting manager contract (so we can use the accounting manager address as the calculator connector)
        bytes32 positionId = registry.calculatePositionId(accountingManager, 0, abi.encode(token));
        // if the token is not in the registry, we add it or remove it if the remove flag is true
        uint256 positionIndex =
            registry.getHoldingPositionIndex(vaultId, positionId, address(this), abi.encode(address(this)));
        if ((positionIndex == 0 && !remove) || (positionIndex > 0 && remove)) {
            registry.updateHoldingPosition(vaultId, positionId, abi.encode(address(this)), "", remove);
        }
    }

    function _updateTokenInRegistry(address token) internal {
        _updateTokenInRegistry(token, IERC20(token).balanceOf(address(this)) == 0);
    }
}
