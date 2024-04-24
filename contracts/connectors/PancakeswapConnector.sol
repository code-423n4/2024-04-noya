// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./UNIv3Connector.sol";
import "../external/interfaces/Pancakeswap/IMasterChefV3.sol";
import "@openzeppelin/contracts-5.0/token/ERC721/IERC721.sol";

contract PancakeswapConnector is UNIv3Connector {
    using SafeERC20 for IERC20;

    // ------------ errors -------------- //
    IMasterchefV3 public masterchef;

    event SendPositionToMasterChef(uint256 tokenId);
    event UpdatePosition(uint256 tokenId);
    event Withdraw(uint256 tokenId);
    // ------------ Constructor -------------- //

    constructor(address MC, address _positionManager, address _factory, BaseConnectorCP memory baseConnectorParams)
        UNIv3Connector(_positionManager, _factory, baseConnectorParams)
    {
        require(MC != address(0));
        masterchef = IMasterchefV3(MC);
    }
    // ------------ Connector functions -------------- //
    /**
     * @notice Supply LP token to Pancakeswap
     * @param tokenId - tokenId of the position
     */

    function sendPositionToMasterChef(uint256 tokenId) external onlyManager nonReentrant {
        IERC721(address(positionManager)).safeTransferFrom(address(this), address(masterchef), tokenId);
        emit SendPositionToMasterChef(tokenId);
    }
    /**
     * @notice updates the LP position that has been sent to Pancakeswap
     * @param tokenId - tokenId of the position
     */

    function updatePosition(uint256 tokenId) public onlyManager nonReentrant {
        masterchef.updateLiquidity(tokenId);
        _updateTokenInRegistry(masterchef.CAKE());
        emit UpdatePosition(tokenId);
    }
    /**
     * @notice Withdraw LP token from Pancakeswap
     * @param tokenId - tokenId of the position
     */

    function withdraw(uint256 tokenId) public onlyManager nonReentrant {
        masterchef.withdraw(tokenId, address(this));
        _updateTokenInRegistry(masterchef.CAKE());
        emit Withdraw(tokenId);
    }
}
