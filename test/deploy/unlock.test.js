const { expect } = require("chai");
const { BigNumber } = require("ethers");

const { parseUnits } = require("ethers/lib/utils");
const { ethers, network } = require("hardhat");

const DAI = "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063";
const WETH = "0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619";

// DAI_daiWHALE must be an account, not contract
const daiWHALE = "0x1a34edac6ab1cf8fe609f163d798c8644636c7dd";
const wethWHALE = "0x0f0c716b007c289c0011e470cc7f14de4fe9fc80";

var MAKER;

describe("Multiple User Replication", () => {
  let accounts;
  let dai;
  let daiwhale;
  let weth;
  let wethwhale;

  before(async () => {
    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [daiWHALE],
    });

    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [wethWHALE],
    });

    daiwhale = await ethers.getSigner(daiWHALE);
    dai = await ethers.getContractAt("IERC20", DAI);

    wethwhale = await ethers.getSigner(wethWHALE);
    weth = await ethers.getContractAt("IERC20", WETH);

    accounts = await ethers.getSigners();
  });

  it("Should unlock dai", async () => {
    const amount = await dai.balanceOf(daiWHALE);
    const value = ethers.BigNumber.from(amount);
    console.log("DAI balance of whale", await ethers.utils.formatEther(value));

    await dai.connect(daiwhale).transfer(accounts[0].address, amount);
    expect(await dai.balanceOf(accounts[0].address)).to.gte(amount);
    signer = (await ethers.getSigners())[0];

  });

  it("Should unlock weth", async () => {
    const amount = await weth.balanceOf(wethWHALE);
    const value = ethers.BigNumber.from(amount);
    console.log("weth balance of whale", await ethers.utils.formatEther(value));

    await weth.connect(wethwhale).transfer(accounts[0].address, amount);
    expect(await weth.balanceOf(accounts[0].address)).to.gte(amount);
    signer = (await ethers.getSigners())[0];

  });

});
