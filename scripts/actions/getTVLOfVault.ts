import { readVaultAddresses, writeVaultAddresses, readSharedAddresses } from "../utils/updateAddresses";
import { ethers } from "hardhat";

async function main() {
  let vaultId = "1"; // This is the vaultId of the vault we want to deploy the connector for

  const owner = (await ethers.getSigners())[0];
  const chainId = Number(await ethers.provider.getNetwork().then((network) => network.chainId));
  console.log("Chain ID:", chainId);
  let addresses = await readVaultAddresses(vaultId);
  let sharedAddresses = await readSharedAddresses();

  console.log(addresses);

  const ContractBuilder = await ethers.getContractFactory("AccountingManager", {
    libraries: {
      TVLHelper: sharedAddresses[chainId]["TVLHelper"],
    },
  });
  const contract = await ContractBuilder.attach(addresses[chainId]["accountingManager"]);
  console.log("TVL of vault", vaultId, "is", await contract.TVL());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
