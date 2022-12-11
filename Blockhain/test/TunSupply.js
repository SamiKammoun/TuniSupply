const { expect } = require("chai");
const { ethers } = require("hardhat");

const GOVERNMENT = "0x0000000000000000000000000000000000000000000000000000000000000000";
const MANUFACTURER = "0x0000000000000000000000000000000000000000000000000000000000000001";
const VENDOR = "0x0000000000000000000000000000000000000000000000000000000000000002";
const TRANSPORTER = "0x0000000000000000000000000000000000000000000000000000000000000003";
const deploy = async () => {
  //getting accounts
  const [Government, Manufacturer, Vendor, Transporter] = await ethers.getSigners();
  //deploying contract
  const Contract = await ethers.getContractFactory("TunSupply");
  const TunSupply = await Contract.deploy();
  return { Government, Manufacturer, Vendor, Transporter, TunSupply };
};

const giveAccess = async (contract, address, role) => {
  await contract.grantRole(role, address);
};

describe("TunSupply Test Suite", async () => {
  it("Should assign Government as admin upon deployment.", async () => {
    const { Government, Manufacturer, Vendor, Transporter, TunSupply } = await deploy();

    expect(await TunSupply.hasRole(GOVERNMENT, Government.address)).to.equal(true);
    expect(await TunSupply.hasRole(GOVERNMENT, Manufacturer.address)).to.equal(false);
  });

  it("Should be able to give Manufacturer, vendor and Transporter their appropriate access", async () => {
    const { Government, Manufacturer, Vendor, Transporter, TunSupply } = await deploy();

    await giveAccess(TunSupply, Manufacturer.address, MANUFACTURER);
    await giveAccess(TunSupply, Transporter.address, TRANSPORTER);
    await giveAccess(TunSupply, Vendor.address, VENDOR);

    expect(await TunSupply.hasRole(MANUFACTURER, Manufacturer.address)).to.equal(true);
    expect(await TunSupply.hasRole(TRANSPORTER, Transporter.address)).to.equal(true);
    expect(await TunSupply.hasRole(VENDOR, Vendor.address)).to.equal(true);
  });

  it("Cannot produce non issued item", async () => {
    const { Government, Manufacturer, Vendor, Transporter, TunSupply } = await deploy();

    await giveAccess(TunSupply, Manufacturer.address, MANUFACTURER);
    await giveAccess(TunSupply, Transporter.address, TRANSPORTER);
    await giveAccess(TunSupply, Vendor.address, VENDOR);

    await expect(TunSupply.connect(Manufacturer).produce(0, 5, 0x00)).to.be.reverted;

    expect(await TunSupply.hasRole(MANUFACTURER, Manufacturer.address)).to.equal(true);

    await TunSupply.connect(Manufacturer).issueItem("");

    await expect(TunSupply.connect(Manufacturer).produce(0, 5, 0x00)).to.not.be.reverted;
  });
});
