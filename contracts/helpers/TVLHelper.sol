// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import { PositionRegistry, HoldingPI } from "../accountingManager/Registry.sol";
import { IConnector } from "../interface/IConnector.sol";

library TVLHelper {
    /// @notice Get the total value locked in the vault
    /// @param vaultId The vault id
    /// @param registry The position registry
    /// @param baseToken The base token
    /// @return The total value locked based on the base token
    /// @dev This function gets the holding positions from the registry and loops through them to get the TVL
    function getTVL(uint256 vaultId, PositionRegistry registry, address baseToken) public view returns (uint256) {
        uint256 totalTVL;
        uint256 totalDebt;
        HoldingPI[] memory positions = registry.getHoldingPositions(vaultId);
        for (uint256 i = 0; i < positions.length; i++) {
            if (positions[i].calculatorConnector == address(0)) {
                continue;
            }
            uint256 tvl = IConnector(positions[i].calculatorConnector).getPositionTVL(positions[i], baseToken);
            bool isPositionDebt = registry.isPositionDebt(vaultId, positions[i].positionId);
            if (isPositionDebt) {
                totalDebt += tvl;
            } else {
                totalTVL += tvl;
            }
        }
        if (totalTVL < totalDebt) {
            return 0;
        }
        return (totalTVL - totalDebt);
    }
    /// @notice Get the oldest update time of the holding positions
    /// @param vaultId The vault id
    /// @param registry The position registry
    /// @return The oldest update time
    /// @dev in case we have a position that we can't fetch the latest update at the moment, we get the oldest update time of all of them to avoid any issues with the TVL

    function getLatestUpdateTime(uint256 vaultId, PositionRegistry registry) public view returns (uint256) {
        uint256 latestUpdateTime;
        HoldingPI[] memory positions = registry.getHoldingPositions(vaultId);
        for (uint256 i = 0; i < positions.length; i++) {
            if (latestUpdateTime == 0 || positions[i].positionTimestamp < latestUpdateTime) {
                latestUpdateTime = positions[i].positionTimestamp;
            }
        }
        if (latestUpdateTime == 0) {
            latestUpdateTime = block.timestamp;
        }
        return latestUpdateTime;
    }
}
