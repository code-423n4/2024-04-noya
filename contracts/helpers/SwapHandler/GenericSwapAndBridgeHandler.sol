// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../../interface/valueOracle/INoyaValueOracle.sol";
import "../../governance/NoyaGovernanceBase.sol";
import "../../interface/SwapHandler/ISwapAndBridgeHandler.sol";
import { SafeERC20, IERC20 } from "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol";

contract SwapAndBridgeHandler is NoyaGovernanceBase, ISwapAndBridgeHandler, ReentrancyGuard {
    using SafeERC20 for IERC20;

    mapping(address => bool) public isEligibleToUse;
    INoyaValueOracle public valueOracle;
    mapping(address => mapping(address => uint256)) public slippageTolerance;
    uint256 public genericSlippageTolerance = 50_000; // 5% slippage tolerance
    RouteData[] public routes;

    event SetValueOracle(address _valueOracle);
    event SetSlippageTolerance(address _inputToken, address _outputToken, uint256 _slippageTolerance);
    event AddEligibleUser(address _user);
    event BridgeExecutionCompleted(BridgeRequest _bridgeRequest);

    modifier onlyEligibleUser() {
        require(isEligibleToUse[msg.sender], "NoyaSwapHandler: Not eligible to use");
        _;
    }

    modifier onlyExistingRoute(uint256 _routeId) {
        if (routes[_routeId].route == address(0) && !routes[_routeId].isEnabled) revert RouteNotFound();
        _;
    }

    constructor(address[] memory usersAddresses, address _valueOracle, PositionRegistry _registry, uint256 _vaultId)
        NoyaGovernanceBase(_registry, _vaultId)
    {
        for (uint256 i = 0; i < usersAddresses.length; i++) {
            isEligibleToUse[usersAddresses[i]] = true;
        }
        valueOracle = INoyaValueOracle(_valueOracle);
        require(_valueOracle != address(0));
    }

    /**
     * @notice function responsible for setting the value oracle
     * @param _valueOracle address of the value oracle
     */
    function setValueOracle(address _valueOracle) external onlyMaintainerOrEmergency {
        valueOracle = INoyaValueOracle(_valueOracle);
        emit SetValueOracle(_valueOracle);
    }

    /**
     * @notice function responsible for setting the slippage tolerance
     * @param _slippageTolerance uint256 value of the slippage tolerance
     */
    function setGeneralSlippageTolerance(uint256 _slippageTolerance) external onlyMaintainerOrEmergency {
        genericSlippageTolerance = _slippageTolerance;
        emit SetSlippageTolerance(address(0), address(0), _slippageTolerance);
    }

    /**
     * @notice function responsible for setting the slippage tolerance for a specific pair
     * @param _inputToken address of the input token
     * @param _outputToken address of the output token
     * @param _slippageTolerance uint256 value of the slippage tolerance
     */
    function setSlippageTolerance(address _inputToken, address _outputToken, uint256 _slippageTolerance)
        external
        onlyMaintainerOrEmergency
    {
        slippageTolerance[_inputToken][_outputToken] = _slippageTolerance;
        emit SetSlippageTolerance(_inputToken, _outputToken, _slippageTolerance);
    }

    /**
     * @notice function responsible for adding an eligible user to use the handler
     * @param _user address of the user
     */
    function addEligibleUser(address _user) external onlyMaintainerOrEmergency {
        isEligibleToUse[_user] = true;
        emit AddEligibleUser(_user);
    }

    /**
     * @notice The function executes the route and returns the amount of output token
     * @param _swapRequest SwapRequest struct containing the swap information
     * @return _amountOut uint256 amount of output token
     */
    function executeSwap(SwapRequest memory _swapRequest)
        external
        payable
        onlyEligibleUser
        onlyExistingRoute(_swapRequest.routeId)
        nonReentrant
        returns (uint256 _amountOut)
    {
        if (_swapRequest.amount == 0) revert InvalidAmount();
        RouteData memory swapImplInfo = routes[_swapRequest.routeId];
        if (swapImplInfo.isBridge) revert RouteNotAllowedForThisAction();

        if (_swapRequest.checkForSlippage && _swapRequest.minAmount == 0) {
            // set minAmount so that slippage can be checked
            uint256 _slippageTolerance = slippageTolerance[_swapRequest.inputToken][_swapRequest.outputToken];
            if (_slippageTolerance == 0) {
                _slippageTolerance = genericSlippageTolerance;
            }
            INoyaValueOracle _priceOracle = INoyaValueOracle(valueOracle);
            uint256 _outputTokenValue =
                _priceOracle.getValue(_swapRequest.inputToken, _swapRequest.outputToken, _swapRequest.amount);

            _swapRequest.minAmount = (((1e6 - _slippageTolerance) * _outputTokenValue) / 1e6);
        }

        _amountOut = ISwapAndBridgeImplementation(swapImplInfo.route).performSwapAction(msg.sender, _swapRequest);

        emit ExecutionCompleted(
            _swapRequest.routeId, _swapRequest.amount, _amountOut, _swapRequest.inputToken, _swapRequest.outputToken
        );
    }

    /**
     * @notice executes the bridge action, sending the tokens to the bridge to be sent to the destination chain
     * @param _bridgeRequest BridgeRequest struct containing the bridge information
     */
    function executeBridge(BridgeRequest calldata _bridgeRequest)
        external
        payable
        onlyEligibleUser
        onlyExistingRoute(_bridgeRequest.routeId)
        nonReentrant
    {
        RouteData memory bridgeImplInfo = routes[_bridgeRequest.routeId];

        if (!bridgeImplInfo.isBridge) revert RouteNotAllowedForThisAction();

        ISwapAndBridgeImplementation(bridgeImplInfo.route).performBridgeAction(msg.sender, _bridgeRequest);

        emit BridgeExecutionCompleted(_bridgeRequest);
    }

    /**
     * @notice function responsible for adding routes to the handler
     * @param _routes RouteData array containing the route information
     * @dev should be called by the maintainer (timelock)
     */
    function addRoutes(RouteData[] memory _routes) public onlyMaintainer {
        for (uint256 i = 0; i < _routes.length;) {
            routes.push(_routes[i]);
            emit NewRouteAdded(i, _routes[i].route, _routes[i].isEnabled, _routes[i].isBridge);
            unchecked {
                i++;
            }
        }
    }

    ///@notice disables the route  if required.
    function setEnableRoute(uint256 _routeId, bool enable) external onlyMaintainerOrEmergency {
        routes[_routeId].isEnabled = enable;
        emit RouteUpdate(_routeId, false);
    }

    /// @notice checks if the route address is correct and enabled
    function verifyRoute(uint256 _routeId, address addr) external view onlyExistingRoute(_routeId) {
        if (routes[_routeId].route != addr) {
            revert RouteNotFound();
        }
    }
}
