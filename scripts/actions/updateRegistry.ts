import { ethers } from "hardhat";
const fs = require("fs");
import { readVaultAddresses, writeVaultAddresses } from "../utils/updateAddresses";

async function updateConnectorsToRegistry(address: string[], vaultId: string) {
  const chainId = Number(await ethers.provider.getNetwork().then((network) => network.chainId));

  const sharedAddresses = JSON.parse(fs.readFileSync(`deployments/sharedContracts.json`));
  const ContractBuilder = await ethers.getContractFactory("PositionRegistry");
  const contract = await ContractBuilder.attach(sharedAddresses[chainId]["registry"]);
  await contract.addConnector(
    vaultId,
    address,
    address.map(() => true)
  );
}

// async function addVaultToRegistry(vaultId: string, accountingManager: string, baseToken: string, governer: string, maintainer: string, maintainerWithoutTimeLock: string, keeperContract: string, watcher: string, emergency: string, trustedTokens: string[]) {
//   const owner = (await ethers.getSigners())[0];
//   const chainId = Number(await ethers.provider.getNetwork().then((network) => network.chainId));
//   const sharedAddresses = JSON.parse(fs.readFileSync(`deployments/sharedContracts.json`));
//   const ContractBuilder = await ethers.getContractFactory("PositionRegistry");
//   // console.log("Deploying registry on chain", chainId, sharedAddresses[chainId]["registry"]);
//   const contract = await ContractBuilder.attach(sharedAddresses[chainId]["registry"]);
//   await contract.addVault(vaultId, accountingManager, baseToken, governer, maintainer, maintainerWithoutTimeLock, keeperContract, watcher, emergency, trustedTokens);
// }

async function addVaultToRegistry(vaultId: string) {
  let vaultAddresses: any = await readVaultAddresses(vaultId);
  const chainId = Number(await ethers.provider.getNetwork().then((network) => network.chainId));

  console.log("Adding vault to registry", vaultAddresses, chainId, vaultAddresses[chainId]);

  if (vaultAddresses[chainId]["accountingManager"] == undefined) {
    console.log("Accounting manager not deployed for vault", vaultId);
    return;
  }

  const ContractBuilder = await ethers.getContractFactory("PositionRegistry");
  const sharedAddresses = JSON.parse(fs.readFileSync(`deployments/sharedContracts.json`));
  const contract = await ContractBuilder.attach(sharedAddresses[chainId]["registry"]);
  await contract.addVault(
    vaultId,
    vaultAddresses[chainId]["accountingManager"],
    vaultAddresses["baseToken"],
    "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
    "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
    "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
    "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
    "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
    "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
    []
  );
}

async function updateRole() {
  const chainId = Number(await ethers.provider.getNetwork().then((network) => network.chainId));
  const sharedAddresses = JSON.parse(fs.readFileSync(`deployments/sharedContracts.json`));
  const ContractBuilder = await ethers.getContractFactory("PositionRegistry");
  const contract = await ContractBuilder.attach(sharedAddresses[chainId]["registry"]);
  await contract.grantRole(await contract.EMERGENCY_ROLE(), "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b");
}

async function changeVaultAddresses(vaultId: string) {
  const owner = (await ethers.getSigners())[0];
  let vaultAddresses: any = await readVaultAddresses(vaultId);
  const chainId = Number(await ethers.provider.getNetwork().then((network) => network.chainId));

  console.log("Adding vault to registry", vaultAddresses, chainId, vaultAddresses[chainId]);

  if (vaultAddresses[chainId]["accountingManager"] == undefined) {
    console.log("Accounting manager not deployed for vault", vaultId);
    return;
  }

  const ContractBuilder = await ethers.getContractFactory("PositionRegistry");
  const sharedAddresses = JSON.parse(fs.readFileSync(`deployments/sharedContracts.json`));
  const contract = await ContractBuilder.attach(sharedAddresses[chainId]["registry"]);
  console.log("Changing vault addresses", await contract.hasRole(await contract.EMERGENCY_ROLE(), owner.address));
  await contract.changeVaultAddresses(
    vaultId,
    "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
    "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
    "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
    "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
    "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
    "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b"
  );
}

// changeVaultAddresses("5656");

// updateRole();
// addVaultToRegistry("5656");
updateConnectorsToRegistry(["0xb70Cec752eAc08Ca604075Ac43CC65A72A2509E3"], "5656");

// addVaultToRegistry(
//   "1",
//   "0x663C7979aBF08C618720D7D28E4340B204750247",
//   "0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913",
//   "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
//   "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
//   "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
//   "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
//   "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
//   "0x8E95f959f1Bd3C4A3Be2bda6089155012fF1a37b",
//   []
// );
