import { ethers } from "hardhat";

async function main() {

  const MetaERC20 = await ethers.deployContract("MetaERC20");

  await MetaERC20.waitForDeployment();

  console.log(
    `MetaERC20 contract deployed to ${MetaERC20.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
