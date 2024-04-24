// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./OmnichainLogic.sol";
import "../../interface/IConnector.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

contract OmnichainManagerBaseChain is OmnichainLogic {
    using SafeERC20 for IERC20;

    uint256 public constant OMNICHAIN_POSITION_ID = 13;
    /**
     * @notice Initializes the OmnichainManagerBaseChain with specific parameters for omnichain operations.
     * @param dl The threshold below which the TVL is considered negligible or "dust."
     * @param _lzHelper The address of the LayerZero helper contract, facilitating cross-chain communications.
     * @param baseConnectorParams Struct containing parameters needed for initializing the base connector.
     */

    constructor(uint256 dl, address payable _lzHelper, BaseConnectorCP memory baseConnectorParams)
        OmnichainLogic(_lzHelper, baseConnectorParams)
    {
        DUST_LEVEL = dl;
    }

    /**
     * @notice Updates the TVL for a specific chain ID based on cross-chain data received and adds it to the position.
     * @dev This function is called by the LayerZero helper to adjust the TVL in response to changes detected on other chains. It's critical for maintaining an accurate and up-to-date reflection of the assets managed across the entire ecosystem.
     * @param chainId The ID of the chain where the TVL update originated.
     * @param tvl The new TVL figure to be recorded.
     * @param updateTime The timestamp when the update was made, ensuring that the data remains timely and relevant.
     */
    function updateTVL(uint256 chainId, uint256 tvl, uint256 updateTime) external nonReentrant {
        if (msg.sender != lzHelper) revert IConnector_InvalidSender();

        registry.updateHoldingPostionWithTime(
            vaultId,
            registry.calculatePositionId(address(this), OMNICHAIN_POSITION_ID, abi.encode(chainId)),
            "",
            abi.encode(tvl),
            tvl <= DUST_LEVEL,
            updateTime
        );
    }
    /**
     * @notice Calculates the TVL for a position identified by the OMNICHAIN_POSITION_ID.
     * @dev Overrides the `_getPositionTVL` function from `OmnichainLogic` to provide specific logic for interpreting TVL data related to omnichain positions on the base chain.
     * @param position Struct containing details about the specific holding position being queried.
     * @return The TVL associated with the specified omnichain position, derived from additional data stored in the position.
     */

    function _getPositionTVL(HoldingPI memory position, address) public view override returns (uint256) {
        uint256 positionTypeId = registry.getPositionBP(vaultId, position.positionId).positionTypeId;
        if (positionTypeId == OMNICHAIN_POSITION_ID) {
            return (abi.decode(position.additionalData, (uint256)));
        }
        return 0;
    }
}
