// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

contract ArbitrumAddresses {
    // DeFi Ecosystem
    address public ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public uniV3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address public uniV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    // addresss
    address public USDC = address(0xaf88d065e77c8cC2239327C5EDb3A432268e5831);
    address public USDCe = address(0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8);
    address public WETH = address(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1);
    address public WBTC = address(0x2f2a2543B76A4166549F7aaB2e75Bef0aefC5B0f);
    address public USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9;
    address public DAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1;
    address public WSTETH = address(0x5979D7b546E38E414F7E9822514be443A4800529);
    address public FRAX = address(0x17FC002b466eEc40DaE837Fc4bE5c67993ddBd6F);
    address public BAL = address(0x040d1EdC9569d4Bab2D15287Dc5A4F10F56a56B8);
    address public COMP = address(0x354A6dA3fcde098F8389cad84b0182725c6C91dE);
    address public LINK = address(0xf97f4df75117a78c1A5a0DBb814Af92458539FB4);
    address public rETH = address(0xEC70Dcb4A1EFa46b8F2D97C310C9c4790ba5ffA8);
    address public cbETH = address(0x1DEBd73E752bEaF79865Fd6446b0c970EaE7732f);
    address public LUSD = address(0x93b346b6BC2548dA6A1E7d98E9a421B42541425b);
    address public UNI = address(0xFa7F8980b0f1E64A2062791cc3b0871572f1F7f0);
    address public CRV = address(0x11cDb42B0EB46D95f990BeDD4695A6e3fA034978);
    address public FRXETH = address(0x178412e79c25968a32e89b11f63B33F733770c2A);
    address public ARB = address(0x912CE59144191C1204E64559FE8253a0e49E6548);

    // Chainlink Datafeeds
    address public WETH_USD_FEED = 0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612;
    address public USDC_USD_FEED = 0x50834F3163758fcC1Df9973b6e91f0F0F0434aD3;
    address public USDCe_USD_FEED = 0x50834F3163758fcC1Df9973b6e91f0F0F0434aD3;
    address public WBTC_USD_FEED = 0xd0C7101eACbB49F3deCcCc166d238410D6D46d57;
    address public DAI_USD_FEED = 0xc5C8E77B397E531B8EC06BFb0048328B30E9eCfB;
    address public USDT_USD_FEED = 0x3f3f5dF88dC9F13eac63DF89EC16ef6e7E25DdE7;
    address public COMP_USD_FEED = 0xe7C53FFd03Eb6ceF7d208bC4C13446c76d1E5884;
    address public FRAX_USD_FEED = 0x0809E3d38d1B4214958faf06D8b1B1a2b73f2ab8;
    address public WSTETH_ETH_FEED = 0xb523AE262D20A936BC152e6023996e46FDC2A95D;
    address public RETH_ETH_FEED = 0xD6aB2298946840262FcC278fF31516D39fF611eF;
    address public CBETH_ETH_FEED = 0xa668682974E3f121185a3cD94f00322beC674275;
    address public BAL_USD_FEED = 0xBE5eA816870D11239c543F84b71439511D70B94f;
    address public LUSD_USD_FEED = 0x0411D28c94d85A36bC72Cb0f875dfA8371D8fFfF;
    address public UNI_USD_FEED = 0x9C917083fDb403ab5ADbEC26Ee294f6EcAda2720;
    address public CRV_USD_FEED = 0xaebDA2c976cfd1eE1977Eac079B4382acb849325;
    address public ARB_USD_FEED = 0xb2A824043730FE05F3DA2efaFa1CBbe83fa548D6;
    address public LINK_USD_FEED = 0x86E53CF1B870786351Da77A57575e79CB55812CB;
    address public LINK_ETH_FEED = 0xb7c8Fb1dB45007F98A68Da0588e1AA524C317f27;

    // Aave V3 Tokens
    address public aV3USDC = address(0x724dc807b04555b71ed48a6896b6F41593b8C637);
    address public dV3USDC = address(0xf611aEb5013fD2c0511c9CD55c7dc5C1140741A6);
    address public aV3USDCe = address(0x625E7708f30cA75bfd92586e17077590C60eb4cD);
    address public dV3USDCe = address(0xFCCf3cAbbe80101232d343252614b6A3eE81C989);
    address public aV3WETH = address(0xe50fA9b3c56FfB159cB0FCA61F5c9D750e8128c8);
    address public dV3WETH = address(0x0c84331e39d6658Cd6e6b9ba04736cC4c4734351);
    address public aV3WBTC = address(0x078f358208685046a11C85e8ad32895DED33A249);
    address public dV3WBTC = address(0x92b42c66840C7AD907b4BF74879FF3eF7c529473);
    address public aV3USDT = address(0x6ab707Aca953eDAeFBc4fD23bA73294241490620);
    address public dV3USDT = address(0xfb00AC187a8Eb5AFAE4eACE434F493Eb62672df7);
    address public aV3DAI = address(0x82E64f49Ed5EC1bC6e43DAD4FC8Af9bb3A2312EE);
    address public dV3DAI = address(0x8619d80FB0141ba7F184CbF22fd724116D9f7ffC);
    address public aV3WSTETH = address(0x513c7E3a9c69cA3e22550eF58AC1C0088e918FFf);
    address public dV3WSTETH = address(0x77CA01483f379E58174739308945f044e1a764dc);
    address public aV3FRAX = address(0x38d693cE1dF5AaDF7bC62595A37D667aD57922e5);
    address public dV3FRAX = address(0x5D557B07776D12967914379C71a1310e917C7555);
    address public aV3LINK = address(0x191c10Aa4AF7C30e871E70C95dB0E4eb77237530);
    address public dV3LINK = address(0x953A573793604aF8d41F306FEb8274190dB4aE0e);
    address public aV3rETH = address(0x8Eb270e296023E9D92081fdF967dDd7878724424);
    address public dV3rETH = address(0xCE186F6Cccb0c955445bb9d10C59caE488Fea559);
    address public aV3LUSD = address(0x8ffDf2DE812095b1D19CB146E4c004587C0A0692);
    address public dV3LUSD = address(0xA8669021776Bc142DfcA87c21b4A52595bCbB40a);
    address public aV3ARB = address(0x6533afac2E7BCCB20dca161449A13A32D391fb00);
    address public dV3ARB = address(0x44705f578135cC5d703b4c9c122528C73Eb87145);

    // Balancer V2 Addresses
    address public vault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;

    // Chainlink Automation Registry
    address public automationRegistry = 0x37D9dC70bfcd8BC77Ec2858836B923c560E891D1;
    address public automationRegistrar = 0x86EFBD0b6736Bed994962f9797049422A3A8E8Ad;

    // FraxLend Pairs
    address public ARB_FRAX_PAIR = 0x2D0483FefAbA4325c7521539a3DFaCf94A19C472;

    // dolomite addresses
    address public depositWithdrawalProxy = 0xAdB9D68c613df4AA363B42161E1282117C7B9594;
    address public dolomiteMargin = 0x6Bd780E7fDf01D77e4d475c821f1e7AE05409072;
    address public BorrowPositionProxy = 0xe43638797513ef7A6d326a95E8647d86d2f5a099;

    // Curve Pools and Tokens

    // Convex-Curve Platform Specifics

    // Uniswap V3

    // Redstone

    uint256 public startingBlock = 204_276_115;
    string public RPC_URL = "https://arbitrum-mainnet.infura.io/v3/7ba42ae194ff466fba204bb8cbfa60b4";
}
