import { ethers } from "hardhat";
const fs = require("fs");
import { readVaultAddresses, writeVaultAddresses } from "../utils/updateAddresses";

let vaultAddresses: any;

let strategyFeeAddress = "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b";
let managementFeeAddress = "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b";

async function main() {
  const owner = (await ethers.getSigners())[0];
  const chainId = Number(await ethers.provider.getNetwork().then((network) => network.chainId));
  let vaultId = "5656";

  vaultAddresses = await readVaultAddresses(vaultId);

  console.log("Vault addresses", vaultAddresses);

  if (vaultAddresses[chainId] == undefined) {
    vaultAddresses[chainId] = {};
  }

  if (vaultAddresses[chainId]["accountingManager"] == undefined) {
    console.log("Accounting manager already deployed for vault", vaultId);
    return;
  }

  let constants = JSON.parse(fs.readFileSync("deployments/constants.json"));
  let tokens = constants[chainId]["tokens"];
  let sharedContracts = JSON.parse(fs.readFileSync("deployments/sharedContracts.json"));
  let sharedAddresses = sharedContracts[chainId];
  if (sharedAddresses == undefined || sharedAddresses["registry"] == undefined) {
    console.log("Please deploy shared contracts first");
    return;
  }
  let vaultName = "Noya test vault";
  let vaultSymbol = "Noya test vault";
  let baseTokenAddress = tokens["USDC"];

  let connector = await deployMockConnector(sharedAddresses["registry"], vaultId);
  console.log("Connector deployed to:", await connector.getAddress());
  vaultAddresses[chainId]["connectors"].push(await connector.getAddress());

  writeVaultAddresses(vaultId, vaultAddresses);
}

export async function deployMockConnector(registryAddress: string, vaultId: string) {
  const MockConnector = await ethers.getContractFactory("ConnectorMock2");
  const mockConnector = await MockConnector.deploy(registryAddress, vaultId);
  console.log("MockConnector deployed to:", await mockConnector.getAddress());
  return mockConnector;
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
