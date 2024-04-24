// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/access/Ownable.sol";
import "../../interface/valueOracle/INoyaValueOracle.sol";
import "../../accountingManager/Registry.sol";

/// @title NoyaValueOracle
/// @notice This contract is used to get the value of an asset in terms of a base Token
contract NoyaValueOracle is INoyaValueOracle {
    PositionRegistry public registry;
    /// @notice Default price sources for base currencies
    mapping(address => INoyaValueOracle) public defaultPriceSource;
    mapping(address => mapping(address => address[])) public priceRoutes;
    /// @notice Price sources for assets
    mapping(address => mapping(address => INoyaValueOracle)) public priceSource;

    error NoyaOracle_PriceOracleUnavailable(address asset, address baseToken);

    event UpdatedDefaultPriceSource(address[] baseCurrencies, INoyaValueOracle[] oracles);
    event UpdatedAssetPriceSource(address[] asset, address[] baseToken, address[] oracle);
    event UpdatedPriceRoute(address asset, address baseToken, address[] s);

    modifier onlyMaintainer() {
        if (!registry.hasRole(registry.MAINTAINER_ROLE(), msg.sender)) revert INoyaValueOracle_Unauthorized(msg.sender);
        _;
    }

    constructor(PositionRegistry _registry) {
        require(address(_registry) != address(0));
        registry = _registry;
    }

    /// @notice Adds a default price source for a base Token
    /// @param baseCurrencies The address of the base Token
    /// @param oracles The array of oracle connectors
    function updateDefaultPriceSource(address[] calldata baseCurrencies, INoyaValueOracle[] calldata oracles)
        public
        onlyMaintainer
    {
        for (uint256 i = 0; i < baseCurrencies.length; i++) {
            defaultPriceSource[baseCurrencies[i]] = oracles[i];
        }
        emit UpdatedDefaultPriceSource(baseCurrencies, oracles);
    }

    /// @notice Adds a price source for an asset
    /// @param asset The address of the asset
    /// @param baseToken The address of the base Token
    /// @param oracle The array of oracle connectors
    function updateAssetPriceSource(address[] calldata asset, address[] calldata baseToken, address[] calldata oracle)
        external
        onlyMaintainer
    {
        for (uint256 i = 0; i < oracle.length; i++) {
            priceSource[asset[i]][baseToken[i]] = INoyaValueOracle(oracle[i]);
        }
        emit UpdatedAssetPriceSource(asset, baseToken, oracle);
    }

    function updatePriceRoute(address asset, address base, address[] calldata s) external onlyMaintainer {
        priceRoutes[asset][base] = s;
        emit UpdatedPriceRoute(asset, base, s);
    }
    /// @notice Gets the value of an asset in terms of a base Token, considering a specific number of sources
    /// @param asset The address of the asset
    /// @param baseToken The address of the base Token
    /// @param amount The amount of the asset
    /// @return The value of the asset in terms of the base Token

    function getValue(address asset, address baseToken, uint256 amount) public view returns (uint256) {
        if (asset == baseToken || amount == 0) {
            return amount;
        }

        address[] memory sources = priceRoutes[asset][baseToken];

        return _getValue(asset, baseToken, amount, sources);
    }

    function _getValue(address asset, address baseToken, uint256 amount, address[] memory sources)
        internal
        view
        returns (uint256 value)
    {
        uint256 initialValue = amount;
        address quotingToken = asset;
        for (uint256 i = 0; i < sources.length; i++) {
            initialValue = _getValue(asset, sources[i], initialValue);
            quotingToken = sources[i];
        }
        return _getValue(quotingToken, baseToken, initialValue);
    }

    function _getValue(address quotingToken, address baseToken, uint256 amount) internal view returns (uint256) {
        INoyaValueOracle oracle = priceSource[quotingToken][baseToken];
        if (address(oracle) == address(0)) {
            oracle = priceSource[baseToken][quotingToken];
        }
        if (address(oracle) == address(0)) {
            oracle = defaultPriceSource[baseToken];
        }
        if (address(oracle) == address(0)) {
            oracle = defaultPriceSource[quotingToken];
        }
        if (address(oracle) == address(0)) {
            revert NoyaOracle_PriceOracleUnavailable(quotingToken, baseToken);
        }
        return oracle.getValue(quotingToken, baseToken, amount);
    }
}
