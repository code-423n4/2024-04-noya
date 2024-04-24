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

  vaultAddresses = readVaultAddresses(vaultId);

  if (vaultAddresses[chainId] == undefined) {
    vaultAddresses[chainId] = {};
  }

  if (vaultAddresses[chainId]["accountingManager"] != undefined) {
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

  console.log("Deploying accounting manager on chain", chainId, sharedAddresses);

  const accounting = await deployAccountingManager(vaultName, vaultSymbol, baseTokenAddress, sharedAddresses["registry"], sharedAddresses["valueOracle"], vaultId, sharedAddresses["TVLHelper"]);
  vaultAddresses[chainId]["accountingManager"] = await accounting.getAddress();
  vaultAddresses["name"] = vaultName;
  vaultAddresses["symbol"] = vaultSymbol;
  vaultAddresses["baseToken"] = baseTokenAddress;
  vaultAddresses["vaultId"] = Number(vaultId);
  writeVaultAddresses(vaultId, vaultAddresses);
}

export async function deployAccountingManager(_name: string, _symbol: string, _baseTokenAddress: string, _registry: string, _valueOracle: string, _vaultId: string, tvlHelperLibraryAddress: string) {
  console.log("Deploying accounting manager", tvlHelperLibraryAddress);
  const AccountingManager = await ethers.getContractFactory("AccountingManager", {
    libraries: {
      TVLHelper: tvlHelperLibraryAddress,
    },
  });
  const accountingManager = await AccountingManager.deploy({
    _name,
    _symbol,
    _baseTokenAddress,
    _registry,
    _valueOracle,
    _vaultId,
    _withdrawFeeReceiver: managementFeeAddress,
    _managementFeeReceiver: managementFeeAddress,
    _performanceFeeReceiver: strategyFeeAddress,
    _withdrawFee: 0,
    _performanceFee: 0,
    _managementFee: 0,
  });
  console.log("AccountingManager deployed to:", await accountingManager.getAddress());
  return accountingManager;
}

export async function deployTVLHelperLibrary() {
  const TVLHelperLibrary = await ethers.getContractFactory("TVLHelper");
  const tvlHelperLibrary = await TVLHelperLibrary.deploy();
  console.log("TVLHelper deployed to:", await tvlHelperLibrary.getAddress());
  return tvlHelperLibrary;
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
