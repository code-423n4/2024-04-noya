// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "contracts/interface/SwapHandler/ILiFi.sol";

contract lifiDiamondMock {
    function executeBridge(
        string memory bridge,
        address sendingAssetId,
        address receiver,
        uint256 minAmount,
        uint256 destinationChainId
    ) public payable { }

    function checkDiamondCut() public view { }

    function extractBridgeData(bytes calldata data) public view returns (ILiFi.BridgeData memory bridgeData) {
        (string memory bridge, address sendingAssetId, address receiver, uint256 minAmount, uint256 destinationChainId)
        = abi.decode(data[4:], (string, address, address, uint256, uint256));
        return ILiFi.BridgeData({
            transactionId: keccak256(data),
            bridge: bridge,
            integrator: "integrator",
            referrer: address(0),
            sendingAssetId: sendingAssetId,
            receiver: receiver,
            minAmount: minAmount,
            destinationChainId: destinationChainId,
            hasSourceSwaps: false,
            hasDestinationCall: false
        });
    }
}
