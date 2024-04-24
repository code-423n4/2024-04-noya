import { readVaultAddresses, writeVaultAddresses } from "../utils/updateAddresses";
import { ethers } from "hardhat";
const fs = require("fs");

async function main() {
  let vaultIds = ["110", "111", "112", "113"]; // This is the vaultId of the vault we want to deploy the connector for

  const owner = (await ethers.getSigners())[0];
  const chainId = Number(await ethers.provider.getNetwork().then((network) => network.chainId));
  console.log("Chain ID:", chainId);

  let sharedContracts = JSON.parse(fs.readFileSync("deployments/sharedContracts.json"));
  let sharedAddresses = sharedContracts[chainId];
  if (sharedAddresses == undefined || sharedAddresses["registry"] == undefined) {
    console.log("Please deploy shared contracts first");
    return;
  }
  for (let vaultId of vaultIds) {
    let addresses = await readVaultAddresses(vaultId);
    console.log(addresses);
    const ContractBuilder = await ethers.getContractFactory("AccountingManager", {
      libraries: {
        TVLHelper: sharedAddresses["TVLHelper"],
      },
    });
    const contract = await ContractBuilder.attach(addresses[chainId]["accountingManager"]);
    addresses["name"] = await contract.name();
    addresses["symbol"] = await contract.symbol();
    addresses["baseToken"] = await contract.baseToken();
    addresses["vaultId"] = Number(await contract.vaultId());
    writeVaultAddresses(vaultId, addresses);
  }
  //   let addresses = await readVaultAddresses(vaultId);
  //   console.log(addresses);

  //   const ContractBuilder = await ethers.getContractFactory("AccountingManager", {
  //     libraries: {
  //       TVLHelper: addresses[chainId]["TVLHelper"],
  //     },
  //   });
  //   const contract = await ContractBuilder.attach(addresses[chainId]["accountingManager"]);
  //   console.log("TVL of vault", vaultId, "is", await contract.getTVL());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
