import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-contract-sizer";
import * as dotenv from "dotenv";
import "solidity-docgen";

dotenv.config();

const config: any = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 10,
      },
    },
  },

  networks: {
    hardhat: {
      forking: {
        url: "https://rpc.ankr.com/eth",
      },
    },
    sepolia: {
      url: process.env.SEPOLIA_RPC,
      accounts: [process.env.OWNER_PRIVATE_KEY as string],
    },
    sepolia_op: {
      url: process.env.SEPOLIA_OP_RPC,
      accounts: [process.env.OWNER_PRIVATE_KEY as string],
    },
    base: {
      url: process.env.BASE_RPC,
      accounts: [process.env.OWNER_PRIVATE_KEY as string],
    },
    optimism: {
      url: process.env.OPTIMISM_RPC,
      accounts: [process.env.OWNER_PRIVATE_KEY as string],
    },
    arbitrum: {
      url: process.env.ARBITRUM_RPC,
      accounts: [process.env.OWNER_PRIVATE_KEY as string],
    },
    polygon: {
      url: process.env.POLYGON_RPC,
      accounts: [process.env.OWNER_PRIVATE_KEY as string],
    },
    ethereum: {
      url: process.env.ETHEREUM_RPC,
      accounts: [process.env.OWNER_PRIVATE_KEY as string],
    },
    BNB: {
      url: process.env.BNB_RPC,
      accounts: [process.env.OWNER_PRIVATE_KEY as string],
    },
    AVAX: {
      url: process.env.AVAX_RPC,
      accounts: [process.env.OWNER_PRIVATE_KEY as string],
    },
    gnosis: {
      url: process.env.GNOSIS_RPC,
      accounts: [process.env.OWNER_PRIVATE_KEY as string],
    },
    polygon_zk: {
      url: process.env.POLYGON_ZK_RPC,
      accounts: [process.env.OWNER_PRIVATE_KEY as string],
    },
    zkSync: {
      url: process.env.ZKSYNC_RPC,
      accounts: [process.env.OWNER_PRIVATE_KEY as string],
    },
  },

  contractSizer: {
    alphaSort: true,
    // runOnCompile: true,
    disambiguatePaths: false,
  },

  docgen: {
    path: "./docs",
    clear: true,
    only: ["contracts"],
  },
};

export default config;
