const fs = require("fs");

export async function readSharedAddresses() {
  if (!fs.existsSync(`deployments/sharedContracts.json`)) {
    return {};
  }
  let a = JSON.parse(fs.readFileSync(`deployments/sharedContracts.json`));
  if (a == undefined) {
    a = {};
  }
  return a;
}

export async function readVaultAddresses(vaultId: string) {
  if (!fs.existsSync(`deployments/vaultAddresses_${vaultId}.json`)) {
    return {
      connectors: [],
    };
  }
  let a = JSON.parse(fs.readFileSync(`deployments/vaultAddresses_${vaultId}.json`));
  if (a == undefined) {
    a = {
      connectors: [],
    };
  }
  if (a["connectors"] == undefined) {
    a["connectors"] = [];
  }
  return a;
}

export async function writeVaultAddresses(vaultId: string, vaultAddresses: any) {
  if (!fs.existsSync(`deployments`)) {
    fs.mkdirSync(`deployments`);
  }
  if (fs.existsSync(`deployments/vaultAddresses_${vaultId}.json`)) {
    if (!fs.existsSync(`deploymentsOld`)) {
      fs.mkdirSync(`deploymentsOld`);
    }
    let a = fs.readFileSync(`deployments/vaultAddresses_${vaultId}.json`);
    fs.writeFileSync(`deploymentsOld/vaultAddresses_${vaultId}.json`, a);
  }
  fs.writeFileSync(`deployments/vaultAddresses_${vaultId}.json`, JSON.stringify(vaultAddresses));
}
