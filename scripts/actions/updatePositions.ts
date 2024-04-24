import { ethers } from "hardhat";
const fs = require("fs");
import { readVaultAddresses, writeVaultAddresses } from "../utils/updateAddresses";

let vaultId = "5656";
let connectorIndex = 0;

async function addTrustedPositionToRegistry() {
  let positionTypeId = 1;
  const chainId = Number(await ethers.provider.getNetwork().then((network) => network.chainId));
  const sharedAddresses = JSON.parse(fs.readFileSync(`deployments/sharedContracts.json`));

  const vaultAddresses = await readVaultAddresses(vaultId);
  const connector = vaultAddresses[chainId]["connectors"][connectorIndex];

  const ContractBuilder = await ethers.getContractFactory("PositionRegistry");
  const contract = await ContractBuilder.attach(sharedAddresses[chainId]["registry"]);

  await contract.addTrustedPosition(vaultId, positionTypeId, connector.address, false, false, ethers.toUtf8Bytes(""), ethers.toUtf8Bytes(""));
}

async function addHoldingPositionInRegistryUsingMockContract() {
  let positionTypeId = 1;
  const chainId = Number(await ethers.provider.getNetwork().then((network) => network.chainId));
  const sharedAddresses = JSON.parse(fs.readFileSync(`deployments/sharedContracts.json`));

  const vaultAddresses = await readVaultAddresses(vaultId);
  const connectorAddress = vaultAddresses[chainId]["connectors"][connectorIndex];

  const ContractBuilder = await ethers.getContractFactory(connectorAddress.name);
  const contract = await ContractBuilder.attach(connectorAddress.address);

  await contract.addPositionToRegistryUsingType(positionTypeId, ethers.toUtf8Bytes(""));
}

// addTrustedPositionToRegistry();
addHoldingPositionInRegistryUsingMockContract();
