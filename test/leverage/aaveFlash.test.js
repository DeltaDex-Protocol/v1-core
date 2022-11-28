const { expect } = require("chai");
const { ethers, network } = require("hardhat");

const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const USDC = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
const WETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

// DAI_WHALE must be an account, not contract
const WHALE = "0xaD0135AF20fa82E106607257143d0060A7eB5cBf";

const ADDRESS_PROVIDER = "0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5";

describe("Deploy flashloan contract and implement flashloan", () => {
  let accounts;
  let erc20;
  let whale;

  let aaveflash;

  before(async () => {
    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [WHALE],
    });

    whale = await ethers.getSigner(WHALE);
    erc20 = await ethers.getContractAt("IERC20", DAI);

    accounts = await ethers.getSigners();
  });

  it("Should deploy", async () => {
    // signers = await ethers.getSigners();

    // @dev deploy swapper contract
    const AAVE = await ethers.getContractFactory("AaveFlashLoan");
    aaveflash = await AAVE.deploy(ADDRESS_PROVIDER);
    await aaveflash.deployed();
    console.log("aave flashloan contract: ", aaveflash.address);

  });


  it("Should send DAI to contract", async () => {

    let amount = await erc20.balanceOf(WHALE)

    // const amount = ethers.utils.parseUnits("1000");
    await erc20.connect(whale).transfer(accounts[0].address, amount);

    await erc20.connect(accounts[0]).approve(aaveflash.address, amount);

    // send weth to flashloan contract
    await erc20.connect(accounts[0]).transfer(aaveflash.address, amount);

    const aaveflashBalance = await erc20.balanceOf(aaveflash.address);
    console.log("curve swap contract balance: ", aaveflashBalance);
  });

  it("Should implement flashloan", async () => {
    // let dai = await ethers.getContractAt("IERC20", DAI);

    let BORROW_AMOUNT = ethers.utils.parseUnits("10000");

    console.log(BORROW_AMOUNT);

    const tx = await aaveflash.connect(accounts[0]).FlashLoan(DAI, BORROW_AMOUNT);

    const aaveflashBalanceWETH = await erc20.balanceOf(aaveflash.address);
    console.log("curve contract balance WETH: ", aaveflashBalanceWETH);
  });
});
