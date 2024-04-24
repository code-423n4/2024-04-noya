// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../helpers/BaseConnector.sol";
import "../external/interfaces/SNXV3/IV3CoreProxy.sol";

contract SNXV3Connector is BaseConnector, IERC721Receiver {
    using SafeERC20 for IERC20;
    // ------------ state variables -------------- //
    /**
     * @notice SNX Core Proxy address
     */

    IV3CoreProxy public SNXCoreProxy;

    uint256 public constant SNX_POSITION_ID = 1;
    uint256 public constant SNX_POOL_POSITION_ID = 2;

    // ------------ Constructor -------------- //
    constructor(address _SNXCoreProxy, BaseConnectorCP memory baseConnectorParams) BaseConnector(baseConnectorParams) {
        require(_SNXCoreProxy != address(0));
        SNXCoreProxy = IV3CoreProxy(_SNXCoreProxy);
    }

    function createAccount() public onlyManager {
        // Create account
        SNXCoreProxy.createAccount();
    }

    function deposit(address _token, uint256 _amount, uint128 _accountId) public onlyManager {
        // Deposit
        _approveOperations(_token, address(SNXCoreProxy), _amount);

        SNXCoreProxy.deposit(_accountId, _token, _amount);
        registry.updateHoldingPosition(
            vaultId,
            registry.calculatePositionId(address(this), SNX_POSITION_ID, ""),
            abi.encode(_accountId, _token),
            "",
            false
        );
        // Update token
        _updateTokenInRegistry(_token);
    }

    function withdraw(address _token, uint256 _amount, uint128 _accountId) public onlyManager {
        // Deposit
        _approveOperations(_token, address(SNXCoreProxy), _amount);
        SNXCoreProxy.withdraw(_accountId, _token, _amount);
        (uint256 c,,) = SNXCoreProxy.getAccountCollateral(_accountId, _token);
        if (c == 0) {
            registry.updateHoldingPosition(
                vaultId,
                registry.calculatePositionId(address(this), SNX_POSITION_ID, ""),
                abi.encode(_accountId, _token),
                "",
                true
            );
        }
        // Update token
        _updateTokenInRegistry(_token);
    }

    function onERC721Received(address, address, uint256, bytes memory) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function delegateIntoPreferredPool(
        uint128 _accountId,
        address collateralType,
        uint256 newCollateralAmountD18,
        uint256 leverage
    ) public onlyManager {
        // Delegate

        uint128 poolId = SNXCoreProxy.getPreferredPool();

        SNXCoreProxy.delegateCollateral(_accountId, poolId, collateralType, newCollateralAmountD18, leverage);
    }

    function delegateIntoApprovedPool(
        uint256 poolIndex,
        uint128 _accountId,
        address collateralType,
        uint256 newCollateralAmountD18,
        uint256 leverage
    ) public onlyManager {
        uint256[] memory poolIds = SNXCoreProxy.getApprovedPools();
        SNXCoreProxy.delegateCollateral(
            _accountId, uint128(poolIds[poolIndex]), collateralType, newCollateralAmountD18, leverage
        );
    }

    function claimRewards(uint128 accountId, uint128 poolId, address collateralType, address distributor)
        public
        onlyManager
    {
        SNXCoreProxy.claimRewards(accountId, poolId, collateralType, distributor);
        _updateTokenInRegistry(collateralType);
    }

    function mintOrBurnSUSD(
        uint256 _amount,
        uint128 _accountId,
        uint128 poolId,
        address collateralType,
        bool mintOrBurn
    ) public onlyManager {
        // Mint or burn
        address usdToken = SNXCoreProxy.getUsdToken();
        if (mintOrBurn) {
            SNXCoreProxy.mintUsd(_accountId, poolId, collateralType, _amount);
        } else {
            _approveOperations(usdToken, address(SNXCoreProxy), _amount);
            SNXCoreProxy.burnUsd(_accountId, poolId, collateralType, _amount);
        }
        _updateTokenInRegistry(collateralType);
        _updateTokenInRegistry(usdToken);
    }

    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
        (uint128 accountId, address collateralType) = abi.decode(p.data, (uint128, address));
        (uint256 totalDeposited, uint256 totalAssigned, uint256 totalLocked) =
            SNXCoreProxy.getAccountCollateral(accountId, collateralType);
        tvl = _getValue(collateralType, base, totalDeposited + totalAssigned);
    }

    function _getUnderlyingTokens(uint256, bytes memory) public pure override returns (address[] memory) {
        return new address[](0);
    }
}
