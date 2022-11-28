const { expect } = require("chai");
const { parseUnits } = require("ethers/lib/utils");
const { ethers, network } = require("hardhat");

describe("Chainlink Oracle Tests", () => {

  let WETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
  let WETH_DATAFEED = "0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419";

  let WBTC = "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599";
  let WBTC_DATAFEED = "0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c";

  let UNI = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
  let UNI_DATAFEED = 0x553303d460EE0afB37EdFf9bE42922D8FF63220e;

  let LINK = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
  let LINK_DATAFEED = 0x2c1d072e956AFFC0D435Cb7AC38EF18d24d9127c;

  let AAVE = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
  let AAVE_DATAFEED = 0x6Df09E975c830ECae5bd4eD9d90f3A95a4f88012;

  let COMP = 0xc00e94Cb662C3520282E6f5717214004A7f26888;
  let COMP_DATAFEED = 0xdbd020CAeF83eFd542f4De03e3cF0C28A4428bd5;

  let USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
  let USDC_DATAFEED = 0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6;

  let USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
  let USDT_DATAFEED = 0x3E7d1eAB13ad0104d2750B8863b489D65364e32D;

  let DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
  let DAI_DATAFEED = 0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9;


  let accounts;

  // main
  let oracle;

  before(async () => {
    accounts = await ethers.getSigners();
  });

  it("Should deploy chainlink oracle contract: ", async () => {
    ChainlinkOracleContract = await ethers.getContractFactory("ChainlinkPriceFeed");
    oracle = await ChainlinkOracleContract.deploy();
    await oracle.deployed();
  });

  it("Should call init function", async () => {
    let tx = await oracle.connect(accounts[0]).initAddresses();
    await tx.wait();
  });

  it("Should verify addresses in contract", async () => {
    let tx = await oracle.DataAddresses(WETH);
    
    // expect(tx.token).to.be.equal(WETH);

  });

});
