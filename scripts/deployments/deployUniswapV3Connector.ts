import { readVaultAddresses, writeVaultAddresses } from "../utils/updateAddresses";

async function main() {
  let vaultId = "1"; // This is the vaultId of the vault we want to deploy the connector for

  const owner = (await ethers.getSigners())[0];
  const chainId = await owner.getChainId();
  let addresses = readVaultAddresses("1");

  const sharedAddresses = JSON.parse(fs.readFileSync(`deployments/sharedContracts_chain_{$chainId}.json`));

  const UNISWAPV3 = await ethers.getContractFactory("UNIv3Connector");
  const uniswapV3 = await UNISWAPV3.deploy(sharedAddresses["uniswapV3PostitionManager"], sharedAddresses["uniswapV3Factory"], (sharedAddresses["registry"], vaultId, sharedAddresses["swapHandler"], sharedAddresses["valueOracle"]));

  await uniswapV3.deployed();
  console.log("UNIv3Connector deployed to:", uniswapV3.address);
  addresses["connectors"].push({
    connector: uniswapV3.address,
    connectorType: "UNIv3",
    chainId: chainId,
  });
  writeVaultAddresses(vaultId, addresses);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
