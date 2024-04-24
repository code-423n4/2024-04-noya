import { ethers } from "hardhat";
const fs = require("fs");
async function main() {
  console.log("Deploying shared contracts");

  let constants = JSON.parse(fs.readFileSync("deployments/sharedContracts.json"));
  const owner = (await ethers.getSigners())[0];
  const chainId = Number(await ethers.provider.getNetwork().then((network) => network.chainId));
  let sharedAddresses = constants[chainId];
  if (sharedAddresses == undefined) {
    sharedAddresses = {};
    constants[chainId] = sharedAddresses;
  }
  console.log("Chain ID:", chainId, sharedAddresses);

  console.log("Deploying shared contracts for chain", chainId);

  // const registry = await deployRegistry(await owner.getAddress());
  // sharedAddresses["registry"] = await registry.getAddress();

  let LZEndpoint = sharedAddresses["LZEndpoint"];
  const lzHelperSender = await deployLZHelperSender(LZEndpoint, await owner.getAddress());
  // const lzHelperReceiver = await deployLZHelperReceiver(LZEndpoint, await owner.getAddress());

  // const valueOracle = await deployValueOracle(sharedAddresses["registry"]);
  // sharedAddresses["valueOracle"] = await valueOracle.getAddress();

  // const swapHandler = await deploySwapHandler(sharedAddresses["valueOracle"], sharedAddresses["registry"], vaultId);
  // sharedAddresses["swapHandler"] = await swapHandler.getAddress();

  // const tvlHelperLibrary = await deployTVLHelperLibrary();
  // sharedAddresses["TVLHelper"] = await tvlHelperLibrary.getAddress();

  sharedAddresses["lzHelperSender"] = await lzHelperSender.getAddress();
  // sharedAddresses["lzHelperReceiver"] = await lzHelperReceiver.getAddress();

  fs.writeFileSync(`deployments/sharedContracts.json`, JSON.stringify(constants));
}

console.log("Deploying shared contracts");

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

export async function deployTVLHelperLibrary() {
  const TVLHelperLibrary = await ethers.getContractFactory("TVLHelper");
  const tvlHelperLibrary = await TVLHelperLibrary.deploy();
  console.log("TVLHelper deployed to:", await tvlHelperLibrary.getAddress());
  return tvlHelperLibrary;
}

async function deployRegistry(ownerAddress: string) {
  const Registry = await ethers.getContractFactory("PositionRegistry");
  const registry = await Registry.deploy(ownerAddress, ownerAddress, ownerAddress, "0x0000000000000000000000000000000000000000");
  console.log("Registry deployed to:", await registry.getAddress());
  return registry;
}

async function deployLZHelperSender(LZEndpoint: string, ownerAddress: string) {
  const LZHelperSender = await ethers.getContractFactory("LZHelperSender");
  const lzHelperSender = await LZHelperSender.deploy(LZEndpoint, ownerAddress);
  console.log("LZHelperSender deployed to:", await lzHelperSender.getAddress());
  return lzHelperSender;
}

async function deployLZHelperReceiver(LZEndpoint: string, ownerAddress: string) {
  const LZHelperReceiver = await ethers.getContractFactory("LZHelperReceiver");
  const lzHelperReceiver = await LZHelperReceiver.deploy(LZEndpoint, ownerAddress);
  console.log("LZHelperReceiver deployed to:", await lzHelperReceiver.getAddress());
  return lzHelperReceiver;
}

async function deployValueOracle(registryAddress: string) {
  const ValueOracle = await ethers.getContractFactory("NoyaValueOracle");
  const valueOracle = await ValueOracle.deploy(registryAddress);
  console.log("ValueOracle deployed to:", await valueOracle.getAddress());
  return valueOracle;
}

async function deploySwapHandler(valueOracle: string, registryAddress: string, vaultId: string) {
  const SwapHandler = await ethers.getContractFactory("SwapAndBridgeHandler");
  const swapHandler = await SwapHandler.deploy([], valueOracle, registryAddress, vaultId);
  console.log("SwapHandler deployed to:", await swapHandler.getAddress());
  return swapHandler;
}
