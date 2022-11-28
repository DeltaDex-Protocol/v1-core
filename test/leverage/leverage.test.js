const { expect } = require("chai");
const { parseUnits } = require("ethers/lib/utils");
const { ethers, network } = require("hardhat");

const ADDRESS_PROVIDER = "0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5";

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

  // main contracts
  let aaveflash;
  let leverage;

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

  it("Should deploy aave flashloan contract and set address", async () => {
    const AAVE = await ethers.getContractFactory("AaveFlashLoan");
    aaveflash = await AAVE.deploy(ADDRESS_PROVIDER);
    await aaveflash.deployed();
    console.log("aave flashloan contract: ", aaveflash.address);
  });


  it("Should deploy leverage contract", async () => {
    const Leverage = await ethers.getContractFactory("Leverage");
    leverage = await Leverage.deploy(aaveflash.address);
    await leverage.deployed();
    console.log("compound borrow contract address:", leverage.address);
  });

  it("Should  set leverage address in aave flash", async () => {
    await aaveflash.initLeverageAddr(leverage.address); 
    console.log("compound borrow contract address:", aaveflash.leverage);
  });


  it("Should unlock dai", async () => {
    const amount = await dai.balanceOf(daiWHALE);
    const value = ethers.BigNumber.from(amount);
    console.log("DAI balance of whale", await ethers.utils.formatEther(value));

    await dai.connect(daiwhale).transfer(accounts[0].address, amount);
    expect(await dai.balanceOf(accounts[0].address)).to.gte(amount);
    signer = (await ethers.getSigners())[0];

    await dai.connect(signer, accounts[0]).approve(leverage.address, amount);

    expect(
      await dai.allowance(accounts[0].address, leverage.address)
    ).to.gte(amount);

    const amount1 = await dai.balanceOf(accounts[0].address);
    const value1 = ethers.BigNumber.from(amount1);

    console.log(
      "DAI balance of account",
      await ethers.utils.formatEther(value1)
    );
  });

  it("Should initiate leverage trade ", async () => {

    console.log("Starting Leverage Trade:")

    let amount = ethers.utils.parseUnits("10000");
    amount  = ethers.BigNumber.from(amount)
    console.log("User sends 10,000 DAI", amount);

    await dai.connect(accounts[0]).approve(leverage.address, amount);

    const tx = await leverage.connect(accounts[0]).initiateTrade(DAI, WBTC, amount, 1);
    await tx.wait();

    let daiBalance = await dai.balanceOf(leverage.address);
    daiBalance = ethers.BigNumber.from(daiBalance);
    console.log("contract DAI balance", daiBalance);


    let ctokenBalance = await leverage.getCTokenBalance(CDAI);
    ctokenBalance = ethers.BigNumber.from(ctokenBalance);
    console.log("compound CDAI balance", ctokenBalance);
  });
 

});
