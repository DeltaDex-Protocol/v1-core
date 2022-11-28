const { expect } = require("chai");
const { ethers, network } = require("hardhat");

const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const WETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

const MAKER = "0x572316aC11CB4bc5daf6BDae68f43EA3CCE3aE0e";

describe("Deployer", function () {
  it("Should get all positions of user: ", async () => {
    const optionmaker = await ethers.getContractAt("OptionMaker", MAKER);

    let accounts;

    accounts = await ethers.getSigners();

    const positions = await optionmaker.userIDlength(accounts[0].address);

    var value = ethers.BigNumber.from(positions).toString();
    value = parseInt(value);
    console.log("number of positions of user: ", positions);

    // to get all addresses of pairs, we can loop over mapping Positions[user] or call getUserPositions()
    // to get all addresses of pairs that the user has used.
    const pair = await optionmaker.getPair(DAI, WETH);

    console.log("pair", pair);

    var optionPosition = await optionmaker.JDM_Options(
      pair,
      accounts[0].address,
      1
    );

    const JDM = JSON.stringify(optionPosition);

    const JDMparsed = JSON.parse(JDM);

    var token0 = JDMparsed[0];
    var token1 = JDMparsed[1];

    var token0_balance = ethers.utils.formatUnits(
      ethers.BigNumber.from(JDMparsed[2]),
      "ether"
    );

    var token1_balance = ethers.utils.formatUnits(
      ethers.BigNumber.from(JDMparsed[3]),
      "ether"
    );

    var isCall = JDMparsed[4];
    var isLong = JDMparsed[5];

    var amount = ethers.utils.formatUnits(
      ethers.BigNumber.from(JDMparsed[6]),
      "ether"
    );

    var expiry = ethers.BigNumber.from(JDMparsed[7]).toString();

    var fees = ethers.utils.formatUnits(
      ethers.BigNumber.from(JDMparsed[8]),
      "ether"
    );

    var perDay = ethers.BigNumber.from(JDMparsed[9]).toString();

    var hedgeFee = ethers.utils.formatUnits(
      ethers.BigNumber.from(JDMparsed[10]),
      "ether"
    );

    var lastHedge = ethers.BigNumber.from(JDMparsed[11]).toString();

    var K = ethers.utils.formatUnits(
      ethers.BigNumber.from(JDMparsed[12][0]),
      "ether"
    );

    var T = ethers.utils.formatUnits(
      ethers.BigNumber.from(JDMparsed[12][1]),
      "ether"
    );

    var r = ethers.utils.formatUnits(
      ethers.BigNumber.from(JDMparsed[12][2]),
      "ether"
    );

    var sigma = ethers.utils.formatUnits(
      ethers.BigNumber.from(JDMparsed[12][3]),
      "ether"
    );

    var m = ethers.utils.formatUnits(
      ethers.BigNumber.from(JDMparsed[12][4]),
      "ether"
    );

    var v = ethers.utils.formatUnits(
      ethers.BigNumber.from(JDMparsed[12][5]),
      "ether"
    );

    var lam = ethers.utils.formatUnits(
      ethers.BigNumber.from(JDMparsed[12][6]),
      "ether"
    );

    const row = {
      id: 0,
      token0: token0,
      token1: token1,
      token0_balance: token0_balance,
      token1_balance: token1_balance,

      isCall: isCall,
      isLong: isLong,

      amount: amount,
      expiry: expiry,
      fees: fees,
      perday: perDay,
      hedgeFee: hedgeFee,
      lastHedge: lastHedge,
      strike: K,
      T: T,
      r: r,
      sigma: sigma,
      lam: lam,
      m: m,
      v: v,
    };

    console.log(row);

    /*     for (let i = 0; i < value; i++) {
      n = positions - i;
      var optionPosition = await optionmaker.JDM_Options(
        pair,
        accounts[0].address,
        n
      );
      console.log("user position", optionPosition);
    } */

    // expect(await optionmaker.JDM_Calls(pair, accounts[0].address, 0).tokenA).to.equal(1);
  });
});
