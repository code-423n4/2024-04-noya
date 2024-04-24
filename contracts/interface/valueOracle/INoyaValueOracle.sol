// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

interface INoyaValueOracle {
    error INoyaValueOracle_Unauthorized(address sender);
    error INoyaOracle_ValueOracleUnavailable(address asset, address baseToken);
    error INoyaValueOracle_InvalidInput();

    function getValue(address asset, address baseCurrency, uint256 amount) external view returns (uint256);
}
