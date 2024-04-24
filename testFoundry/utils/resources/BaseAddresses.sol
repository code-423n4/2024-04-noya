// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

contract BaseAddresses {
    // DeFi Ecosystem
    address public ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public uniV3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address public uniV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    // ERC20s
    address public USDC = address(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913);
    address public DAI = address(0x50c5725949A6F0c72E6C4a641F24049A917DB0Cb);

    // Chainlink Datafeeds
    address public USDC_USD_FEED = 0x7e860098F58bBFC8648a4311b374B1D669a2bc6B;
    address public DAI_USD_FEED = 0x591e79239a7d679378eC8c847e5038150364C78F;

    // Aerodrome
    address public aerodrome_USDC_DAI_Pool = 0x67b00B46FA4f4F24c03855c5C8013C0B938B3eEc;
    address public aerodromeRouter = 0xcF77a3Ba9A5CA399B7c97c74d54e5b1Beb874E43;
    address public aerodromeVoter = 0x16613524e02ad97eDfeF371bC883F2F5d6C480A5;

    //
    address public USDC_Whale = 0x20FE51A9229EEf2cF8Ad9E89d91CAb9312cF3b7A;

    string public RPC_URL = "https://base-mainnet.g.alchemy.com/v2/YTZ4co0ktED8_pxzfX77Lqg9Z2z4SCX_";
    uint256 public startingBlock = 10_926_641;
}
