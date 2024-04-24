pragma solidity 0.8.20;

interface IMasterchefV3 {
    function updateLiquidity(uint256 _tokenId) external;
    function CAKE() external view returns (address);

    function withdraw(uint256 _tokenId, address _to) external;
}
