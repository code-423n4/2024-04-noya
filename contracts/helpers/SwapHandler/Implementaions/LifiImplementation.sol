// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/access/Ownable2Step.sol";
import { SafeERC20, IERC20 } from "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "../../../interface/SwapHandler/ISwapAndBridgeHandler.sol";
import "../../../interface/ITokenTransferCallBack.sol";
import "@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol";

contract LifiImplementation is ISwapAndBridgeImplementation, Ownable2Step, ReentrancyGuard {
    using SafeERC20 for IERC20;

    mapping(address => bool) public isHandler;
    mapping(string => bool) public isBridgeWhiteListed;
    mapping(uint256 => bool) public isChainSupported;
    address public lifi;

    bytes4 public constant LI_FI_GENERIC_SWAP_SELECTOR = 0x4630a0d8;

    event AddedHandler(address _handler, bool state);
    event AddedChain(uint256 _chainId, bool state);
    event AddedBridgeBlacklist(string bridgeName, bool state);
    event Bridged(address bridge, address token, uint256 amount, bytes data);
    event Rescued(address token, address userAddress, uint256 amount);
    // --------------------- Constructor --------------------- //

    constructor(address swapHandler, address _lifi) Ownable2Step() Ownable(msg.sender) {
        isHandler[swapHandler] = true;
        lifi = _lifi;
    }

    // --------------------- Modifiers --------------------- //

    modifier onlyHandler() {
        require(isHandler[msg.sender] == true, "LifiImplementation: INVALID_SENDER");
        _;
    }

    // --------------------- Management Functions --------------------- //
    /**
     * @notice adding or removing a handler to the list of handlers
     * @param _handler address of the handler
     * @param state bool state of the handler
     */
    function addHandler(address _handler, bool state) external onlyOwner {
        isHandler[_handler] = state;
        emit AddedHandler(_handler, state);
    }

    /**
     * @notice adding or removing a chain to the list of supported chains
     * @param _chainId uint256 chain id
     * @param state bool state of the chain
     */
    function addChain(uint256 _chainId, bool state) external onlyOwner {
        isChainSupported[_chainId] = state;
        emit AddedChain(_chainId, state);
    }

    /**
     * @notice adding or removing a bridge name (string) to the list of supported bridges
     * @param bridgeName string chain id
     * @param state bool state of the bridge
     */
    function addBridgeBlacklist(string memory bridgeName, bool state) external onlyOwner {
        isBridgeWhiteListed[bridgeName] = state;
        emit AddedBridgeBlacklist(bridgeName, state);
    }

    // --------------------- Swap Functions --------------------- //
    /**
     * @notice function responsible for performing a swap action
     * @param caller address of the caller (the contract that called swap handler)
     * @param _request SwapRequest struct containing details of the swap transaction
     * @return uint256 amount of the output token
     */
    function performSwapAction(address caller, SwapRequest calldata _request)
        external
        payable
        override
        onlyHandler
        returns (uint256)
    {
        require(verifySwapData(_request), "LifiImplementation: INVALID_SWAP_DATA");
        uint256 balanceOut0 = 0;
        if (_request.outputToken == address(0)) {
            balanceOut0 = address(_request.from).balance;
        } else {
            balanceOut0 = IERC20(_request.outputToken).balanceOf(_request.from);
        }
        _forward(IERC20(_request.inputToken), _request.from, _request.amount, caller, _request.data, _request.routeId);
        uint256 balanceOut1 = 0;
        if (_request.outputToken == address(0)) {
            balanceOut1 = address(_request.from).balance;
        } else {
            balanceOut1 = IERC20(_request.outputToken).balanceOf(_request.from);
        }

        emit Swapped(balanceOut0, balanceOut1, _request.outputToken);

        return balanceOut1 - balanceOut0;
    }

    /**
     * @notice function responsible for verifying the swap data
     * @param _request SwapRequest struct containing details of the swap transaction
     * @return bool true if the swap data is valid, revert otherwise
     * @dev the function will get the data from lifi and verify it
     */
    function verifySwapData(SwapRequest calldata _request) public view override returns (bool) {
        bytes4 selector = bytes4(_request.data[:4]);
        if (selector != LI_FI_GENERIC_SWAP_SELECTOR) {
            revert InvalidSelector();
        }
        (address sendingAssetId, uint256 amount, address from, address receivingAssetId, uint256 receivingAmount) =
            ILiFi(lifi).extractGenericSwapParameters(_request.data);

        if (from != _request.from) revert InvalidReceiver(from, _request.from);
        if (receivingAmount < _request.minAmount) revert InvalidMinAmount();
        if (sendingAssetId != _request.inputToken) revert InvalidInputToken();
        if (receivingAssetId != _request.outputToken) revert InvalidOutputToken();
        if (amount != _request.amount) revert InvalidAmount();

        return true;
    }

    // --------------------- Bridge Functions --------------------- //
    /**
     * @notice function responsible for performing a bridge action
     * @param caller address of the caller (the contract that called swap handler)
     * @param _request BridgeRequest struct containing details of the bridge transaction
     */
    function performBridgeAction(address caller, BridgeRequest calldata _request)
        external
        payable
        override
        onlyHandler
    {
        verifyBridgeData(_request);
        _forward(IERC20(_request.inputToken), _request.from, _request.amount, caller, _request.data, _request.routeId);
        emit Bridged(_request.from, _request.inputToken, _request.amount, _request.data);
    }
    /**
     * @notice function responsible for verifying the bridge data
     * @param _request BridgeRequest struct containing details of the bridge transaction
     * @return bool true if the bridge data is valid, revert otherwise
     * @dev the function will get the data from lifi and verify it
     */

    function verifyBridgeData(BridgeRequest calldata _request) public view override returns (bool) {
        ILiFi.BridgeData memory bridgeData = ILiFi(lifi).extractBridgeData(_request.data);

        if (isBridgeWhiteListed[bridgeData.bridge] == false) revert BridgeBlacklisted();
        if (isChainSupported[bridgeData.destinationChainId] == false) revert InvalidChainId();
        if (bridgeData.sendingAssetId != _request.inputToken) revert InvalidFromToken();
        if (bridgeData.receiver != _request.receiverAddress) {
            revert InvalidReceiver(bridgeData.receiver, _request.receiverAddress);
        }
        if (bridgeData.minAmount > _request.amount) revert InvalidMinAmount();
        if (bridgeData.destinationChainId != _request.destChainId) revert InvalidToChainId();

        return true;
    }

    function _forward(IERC20 token, address from, uint256 amount, address caller, bytes calldata data, uint256 routeId)
        internal
        virtual
        nonReentrant
    {
        if (!_isNative(token)) {
            ITokenTransferCallBack(from).sendTokensToTrustedAddress(address(token), amount, caller, abi.encode(routeId));

            _setAllowance(token, lifi, amount);
        }

        (bool success, bytes memory err) = lifi.call{ value: msg.value }(data);

        if (!success) {
            revert FailedToForward(err);
        }

        emit Forwarded(lifi, address(token), amount, data);
    }

    function _setAllowance(IERC20 token, address spender, uint256 amount) internal {
        token.forceApprove(spender, amount);
    }

    function _isNative(IERC20 token) internal pure returns (bool isNative) {
        return address(token) == address(0);
    }

    function rescueFunds(address token, address userAddress, uint256 amount) external onlyOwner {
        if (token == address(0)) {
            (bool success,) = payable(userAddress).call{ value: amount }("");
            require(success, "Transfer failed.");
        } else {
            IERC20(token).safeTransfer(userAddress, amount);
        }
        emit Rescued(token, userAddress, amount);
    }
}
