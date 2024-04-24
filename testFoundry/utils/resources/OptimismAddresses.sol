// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

contract OptimismAddresses {
    // DeFi Ecosystem
    address public ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public WETH = 0x4200000000000000000000000000000000000006;
    address public uniV3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address public uniV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public uniswapV3PositionManager = 0xC36442b4a4522E871399CD717aBDD847Ab11FE88;
    address public uniswapV3Factory = 0x1F98431c8aD98523631AE4a59f267346ea31F984;

    // addresss
    address public USDC = address(0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85);
    address public USDCe = address(0x7F5c764cBc14f9669B88837ca1490cCa17c31607);
    address public USDT = address(0x94b008aA00579c1307B0EF2c499aD98a8ce58e58);
    address public DAI = address(0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1);

    address constant GHO = 0xc4bF5CbDaBE595361438F8c6a187bDc330539c60;
    address constant AAVEtoken = 0x76FB31fb4af56892A25e32cFC43De717950c9278;

    // Aave V3
    address constant aavePool = 0x794a61358D6845594F94dc1DB02A252b5b4814aD;

    // chainlink feeds
    address constant USDC_USD_FEED = 0x16a9FA2FDa030272Ce99B29CF780dFA30361E0f3;
    address public constant DAI_USD_FEED = 0x8dBa75e83DA73cc766A7e5a0ee71F656BAb470d6;
    address public constant ETH_USD_FEED = 0x13e3Ee699D1909E989722E753853AE30b17e08c5;

    // Balancer V3 Addresses

    address public balancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;

    // FraxLend Pairs

    // Curve Pools and Tokens

    // Convex-Curve Platform Specifics

    // Uniswap V3

    // Redstone

    // Optimism
    address public USDC_Whale = 0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23;

    string public RPC_URL = "https://opt-mainnet.g.alchemy.com/v2/FY0tnR37N5bLNyjWsEY4IXxReJejnfQo";
    uint256 public startingBlock = 116_357_148;
}
