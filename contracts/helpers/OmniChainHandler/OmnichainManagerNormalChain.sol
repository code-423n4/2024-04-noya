// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

import "./OmnichainLogic.sol";
import "../TVLHelper.sol";
import "../LZHelpers/LZHelperSender.sol";

contract OmnichainManagerNormalChain is OmnichainLogic {
    constructor(address payable _lzHelper, BaseConnectorCP memory baseConnectorParams)
        OmnichainLogic(_lzHelper, baseConnectorParams)
    { }
    /**
     * Fetches the current TVL of the vault associated with this contract on the normal (non-base) chain.
     * @return The current TVL calculated using the TVLHelper utility, which aggregates the value of assets managed by the vault on this chain.
     */

    function getTVL() public view returns (uint256) {
        (, address baseToken) = registry.getVaultAddresses(vaultId);
        return TVLHelper.getTVL(vaultId, registry, baseToken);
    }
    /**
     * Triggers an update of the vault's TVL information, sending the latest data to the base chain via the LZHelperSender contract.
     * This function is restricted to be called by managers only, ensuring that TVL updates are controlled and authorized.
     */

    function updateTVLInfo() external onlyManager {
        uint256 tvl = getTVL();
        LZHelperSender(lzHelper).updateTVL(vaultId, tvl, block.timestamp);
    }

    function _getPositionTVL(HoldingPI memory position, address base) public view override returns (uint256) {
        PositionBP memory bp = registry.getPositionBP(vaultId, position.positionId);
        if (bp.positionTypeId == 0) {
            address token = abi.decode(bp.data, (address));
            uint256 amount = IERC20(token).balanceOf(address(this));
            return _getValue(token, base, amount);
        }
        return 0;
    }
}
