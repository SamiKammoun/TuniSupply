const hre = require("hardhat");

async function main() {
  const [Government, Manufacturer, Vendor, Transporter] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", Government.address);
  console.log("Account balance:", (await Government.getBalance()).toString());

  const Contract = await hre.ethers.getContractFactory("TunSupply");
  const TunSupply = await Contract.deploy();

  await TunSupply.deployed();

  console.log("Contract deployed, address: ", TunSupply.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
