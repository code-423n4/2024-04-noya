import { readVaultAddresses, writeVaultAddresses, readSharedAddresses } from "../utils/updateAddresses";
import { ethers } from "hardhat";

async function main() {
  let vaultId = "4"; // This is the vaultId of the vault we want to deploy the connector for

  const owner = (await ethers.getSigners())[0];
  const chainId = Number(await ethers.provider.getNetwork().then((network) => network.chainId));
  console.log("Chain ID:", chainId);
  let sharedAddresses = await readSharedAddresses();

  let addresses = await readVaultAddresses(vaultId);

  console.log(addresses);

  const ContractBuilder = await ethers.getContractFactory("AccountingManager", {
    libraries: {
      TVLHelper: sharedAddresses[chainId]["TVLHelper"],
    },
  });
  const contract = await ContractBuilder.attach(addresses[chainId]["accountingManager"]);

  const token = await ethers.getContractAt("@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol:IERC20", addresses["baseToken"]);
  // const token = await TokenContractBuilder.attach(addresses["baseToken"]);
  // await token.connect(owner).approve(addresses[chainId]["accountingManager"], ethers.parseEther("10000000"));

  await contract.connect(owner).deposit(ethers.Typed.address(owner.address), ethers.parseUnits("11", 0), ethers.Typed.address(owner.address));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
