import { readVaultAddresses, writeVaultAddresses } from "../utils/updateAddresses";

async function main() {
  let vaultId = "1"; // This is the vaultId of the vault we want to deploy the connector for

  const owner = (await ethers.getSigners())[0];
  const chainId = await owner.getChainId();
  let addresses = readVaultAddresses(vaultId);

  const sharedAddresses = JSON.parse(fs.readFileSync(`deployments/sharedContracts_chain_{$chainId}.json`));

  const ContractBuilder = await ethers.getContractFactory("PancakeswapConnector");
  const contract = await ContractBuilder.deploy(sharedAddresses["pancackeMasterChef"], sharedAddresses["pancackePostitionManager"], sharedAddresses["pancackeFactory"], (sharedAddresses["registry"], vaultId, sharedAddresses["swapHandler"], sharedAddresses["valueOracle"]));

  await contract.deployed();
  console.log("contract deployed to:", contract.address);
  addresses["connectors"].push({
    connector: contract.address,
    connectorType: "PancakeswapConnector",
    chainId: chainId,
  });
  writeVaultAddresses(vaultId, addresses);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
