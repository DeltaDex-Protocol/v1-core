const { expect } = require("chai");
const { parseUnits } = require("ethers/lib/utils");
const { ethers, network } = require("hardhat");

const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const USDC = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
const WETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
const WBTC = "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599";

// Compound cToken addresses
const CDAI = "0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643";
const CUSDC = "0x39AA39c021dfbaE8faC545936693aC917d5E7563";
const CWBTC = "0xccF4429DB6322D5C611ee964527D42E5d685DD6a";
const CETH = "0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5";

// DAI_daiWHALE must be an account, not contract
const daiWHALE = "0x7c8ca1a587b2c4c40fc650db8196ee66dc9c46f4";
const wethWHALE = "0x56178a0d5f301baf6cf3e1cd53d9863437345bf9";

describe("Compound Contract Test", () => {
  let accounts;
  let dai;
  let daiwhale;
  let weth;
  let wethwhale;

  let usdc;

  // main contract
  let compound;

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

    usdc = await ethers.getContractAt("IERC20", USDC);
    wbtc = await ethers.getContractAt("IERC20", WBTC);

    accounts = await ethers.getSigners();
  });


  it("Should deploy compound borrow contract", async () => {
    // @dev Deploying storage
    const Comp = await ethers.getContractFactory("CompoundErc20");
    
    compound = await Comp.deploy();
    await compound.deployed();
    console.log("compound borrow contract address:", compound.address);
  });


  it("Should unlock dai", async () => {
    const amount = await dai.balanceOf(daiWHALE);
    const value = ethers.BigNumber.from(amount);
    console.log("DAI balance of whale", await ethers.utils.formatEther(value));

    await dai.connect(daiwhale).transfer(accounts[0].address, amount);
    expect(await dai.balanceOf(accounts[0].address)).to.gte(amount);
    signer = (await ethers.getSigners())[0];

    await dai.connect(signer, accounts[0]).approve(compound.address, amount);

    expect(
      await dai.allowance(accounts[0].address, compound.address)
    ).to.gte(amount);

    const amount1 = await dai.balanceOf(accounts[0].address);
    const value1 = ethers.BigNumber.from(amount1);

    console.log(
      "DAI balance of account",
      await ethers.utils.formatEther(value1)
    );
  });


  it("Should supply ", async () => {

    const amount = await dai.balanceOf(accounts[0].address);
    console.log("dai balance", amount);

    await dai.connect(accounts[0]).approve(compound.address, amount);

    const tx = await compound.connect(accounts[0]).supply(DAI, CDAI, amount);
    await tx.wait();

    const amount1 = await dai.balanceOf(compound.address);
    console.log("contract dai balance", amount1);

    const amount2 = await compound.getCTokenBalance(CDAI);
    console.log("compound cdai balance", amount2);

  });

  it("Should get cToken balance", async () => {
    const amount = await compound.getCTokenBalance(CDAI);
    console.log("cToken Balance ", amount);
  })

  it("Should get CWBTC price", async () => {
    const price = await compound.getPriceFeed(CWBTC);
    console.log("CWBTC price", price);
  })

  /* 
  it("Should redeem", async () => {
    const amount = await compound.getCTokenBalance(CDAI);
    
    console.log("balanceOfUnderlying", amount);
    
    await compound.redeem(CDAI, amount);
    const amount1 = await dai.balanceOf(compound.address);
    console.log("dai balance", amount1);
  })
  */

  it("Should get collateral factor ", async () => {
    const price = await compound.getCollateralFactor(CWBTC);
    console.log("collateral factor", price);
  })

  it("Should get account liquidity before borrow", async () => {
    const amount = await compound.getAccountLiquidity();
    console.log("account liquidity", amount);
  })

  it("Should borrow", async () => {
    await compound.borrow(CDAI, CWBTC);
    // console.log("account liquidity", amount);

    const amount1 = await compound.getBorrowedBalance(CWBTC);
    console.log("CWBTC Balance ", amount1);
  })


  /* 
  it("Should get eth balance", async () => {
    const provider = ethers.getDefaultProvider();
    const balance = await provider.getBalance(compound.address);
    console.log("eth in contract", balance);
  })
  */
 
  it("Should get cToken balance", async () => {
    const amount = await compound.getBorrowedBalance(CWBTC);
    console.log("CWBTC Balance ", amount.value);
  })

  it("Should redeem", async () => {
    const amount = await compound.getCTokenBalance(CWBTC);
    
    console.log("getCTokenBalance CWBTC", amount);
    
    await compound.redeem(CWBTC, amount);
    const amount1 = await wbtc.balanceOf(compound.address);
    console.log("wbtc balance", amount1);
  })

  it("Should get eth balance", async () => {
    const provider = ethers.getDefaultProvider();
    const balance = await provider.getBalance(compound.address);
    console.log("eth in contract", balance);
  })

  
/*   it("Should borrow another asset", async () => {

    const tx = await compound.connect(accounts[0]).borrow(CDAI, CETH);

    await tx.wait();

    const amount = await compound.connect(accounts[0]).getCTokenBalance(CETH);

    console.log("CETH Balance ", amount);
  }) */
});
