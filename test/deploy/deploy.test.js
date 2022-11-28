const { expect } = require("chai");
const { parseUnits } = require("ethers/lib/utils");
const { ethers, network } = require("hardhat");

const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const WETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

// DAI_daiWHALE must be an account, not contract
const daiWHALE = "0x2FAF487A4414Fe77e2327F0bf4AE2a264a776AD2";
const wethWHALE = "0xf584f8728b874a6a5c7a8d4d387c9aae9172d621";

var MAKER;

describe("Multiple User Replication", () => {
  let accounts;
  let dai;
  let daiwhale;
  let weth;
  let wethwhale;

  let optionmaker;

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

  it("Should deploy v1-core and unlock DAI of whale account: ", async () => {
    signers = await ethers.getSigners();

    const Statistics = await ethers.getContractFactory("Statistics");
    const Statslib = await Statistics.deploy();
    await Statslib.deployed();
    console.log("stats library:", Statslib.address);

    // @dev deploy HedgeMath.sol
    const HedgeMath = await ethers.getContractFactory("HedgeMath");
    const HedgeMathlib = await HedgeMath.deploy();
    await HedgeMathlib.deployed();

    // @dev deploy Black Scholes model library
    const BS = await ethers.getContractFactory("BS", {
      signer: signers[0],
      libraries: {
        Statistics: Statslib.address,
      },
    });
    const BSlib = await BS.deploy();
    await BSlib.deployed();
    console.log("BS library:", BSlib.address);

    // @dev deploy Jump Diffusion model library
    const JDM = await ethers.getContractFactory("JDM", {
      signer: signers[0],
      libraries: {
        Statistics: Statslib.address,
      },
    });
    const JDMlib = await JDM.deploy();
    await JDMlib.deployed();
    console.log("JDM library:", JDMlib.address);

    // @dev deploy Curved options model library
    const BSC = await ethers.getContractFactory("BSC", {
      signer: signers[0],
      libraries: {
        Statistics: Statslib.address,
      },
    });
    const BSClib = await BSC.deploy();
    await BSClib.deployed();
    console.log("BSC library:", BSClib.address);

    // ######## @dev deploying periphery contracts Contracts ###########
    const BSOptionMaker = await ethers.getContractFactory("BSOptionMaker", {
      signer: signers[0],
      libraries: {
        BS: BSlib.address,
        JDM: JDMlib.address,
        BSC: BSClib.address,
        HedgeMath: HedgeMathlib.address,
      },
    });
    bsoptionmaker = await BSOptionMaker.deploy();
    await bsoptionmaker.deployed();

    console.log("BSOptionMaker address:", bsoptionmaker.address);

    const JDMOptionMaker = await ethers.getContractFactory("JDMOptionMaker", {
      signer: signers[0],
      libraries: {
        BS: BSlib.address,
        JDM: JDMlib.address,
        BSC: BSClib.address,
        HedgeMath: HedgeMathlib.address,
      },
    });
    jdmoptionmaker = await JDMOptionMaker.deploy();
    await jdmoptionmaker.deployed();

    console.log("JDMOptionMaker address:", jdmoptionmaker.address);

    const BSCOptionMaker = await ethers.getContractFactory("BSCOptionMaker", {
      signer: signers[0],
      libraries: {
        BS: BSlib.address,
        JDM: JDMlib.address,
        BSC: BSClib.address,
        HedgeMath: HedgeMathlib.address,
      },
    });
    bscoptionmaker = await BSCOptionMaker.deploy();
    await bscoptionmaker.deployed();

    console.log("BSCOptionMaker address:", bscoptionmaker.address);

    // @dev Deploying main
    const OptionMaker = await ethers.getContractFactory("OptionMaker", {
      signer: signers[0],
      libraries: {
        BS: BSlib.address,
        JDM: JDMlib.address,
        BSC: BSClib.address,
        HedgeMath: HedgeMathlib.address,
      },
    });
    optionmaker = await OptionMaker.deploy(
      bsoptionmaker.address,
      jdmoptionmaker.address,
      bscoptionmaker.address
    );
    await optionmaker.deployed();

    console.log("OptionMaker address:", optionmaker.address);

    MAKER = optionmaker.addresss;

    const amount = await dai.balanceOf(daiWHALE);
    const value = ethers.BigNumber.from(amount);
    console.log("DAI balance of whale", await ethers.utils.formatEther(value));

    expect(await dai.balanceOf(daiWHALE)).to.gte(amount);

    await dai.connect(daiwhale).transfer(accounts[0].address, amount);
    expect(await dai.balanceOf(accounts[0].address)).to.gte(amount);
    signer = (await ethers.getSigners())[0];

    await dai.connect(signer, accounts[0]).approve(optionmaker.address, amount);

    expect(
      await dai.allowance(accounts[0].address, optionmaker.address)
    ).to.gte(amount);

    const amount1 = await dai.balanceOf(accounts[0].address);
    const value1 = ethers.BigNumber.from(amount1);

    console.log(
      "DAI balance of account",
      await ethers.utils.formatEther(value1)
    );

    // WETH transfer
    const wethamount = await weth.balanceOf(wethWHALE);
    console.log("WETH Balance of Whale", wethamount);
    await weth.connect(wethwhale).transfer(accounts[0].address, wethamount);
    expect(await weth.balanceOf(accounts[0].address)).to.gte(wethamount);
    signer = (await ethers.getSigners())[0];

    await weth
      .connect(signer, accounts[0])
      .approve(optionmaker.address, wethamount);

    expect(
      await weth.allowance(accounts[0].address, optionmaker.address)
    ).to.gte(wethamount);

    const wethBalance = await weth.allowance(
      accounts[0].address,
      optionmaker.address
    );

    console.log("WETH Allowance of OptionMaker ", wethBalance);
    const USER1_balance = await dai.balanceOf(accounts[0].address);
    console.log("balance USER 1: ", USER1_balance);
  });

  it("Position 1: JDM Call replication: ", async () => {
    // input to JDM start replication
    let tokenA_balance = "5000";
    let amount = "1";
    let fee = "400";
    let perDay = "8";
    let K = "1250";
    let T = "0.3";
    let r = "0.15";
    let sigma = "0.8";
    let m = "0.9";
    let v = "0.8";
    let lam = "0.7";

    tokenA_balance = ethers.utils.parseUnits(tokenA_balance);
    amount = ethers.utils.parseUnits(amount);
    fee = ethers.utils.parseUnits(fee);

    perDay = ethers.utils.parseUnits(perDay, "wei");

    K = ethers.utils.parseUnits(K);
    T = ethers.utils.parseUnits(T);
    r = ethers.utils.parseUnits(r);
    sigma = ethers.utils.parseUnits(sigma);
    m = ethers.utils.parseUnits(m);
    v = ethers.utils.parseUnits(v);
    lam = ethers.utils.parseUnits(lam);

    const input = [
      DAI,
      WETH,
      tokenA_balance,
      0,
      true,
      true,
      amount,
      0,
      fee,
      perDay,
      0,
      0,
      [K, T, r, sigma, m, v, lam],
    ];

    const tx = await optionmaker
      .connect(accounts[0])
      .JDM_START_REPLICATION(input);
    // wait until the transaction is mined
    await tx.wait();

    const pair = await optionmaker.getPair(DAI, WETH);
    console.log("address of pair:", pair);

    expect(await optionmaker.getPairUserAddress(pair, 0)).to.equal(
      accounts[0].address
    );
  });

  it("Position 2: JDM Put replication: ", async () => {
    // input to JDM start replication

    let tokenB_balance = "4";
    let amount = "1";
    let fee = "500";
    let perDay = "9";
    let K = "2000";
    let T = "0.5";
    let r = "0.11";
    let sigma = "0.95";
    let m = "1.1";
    let v = "1.2";
    let lam = "0.9";

    tokenB_balance = ethers.utils.parseUnits(tokenB_balance);
    amount = ethers.utils.parseUnits(amount);
    fee = ethers.utils.parseUnits(fee);
    perDay = ethers.utils.parseUnits(perDay, "wei");
    K = ethers.utils.parseUnits(K);
    T = ethers.utils.parseUnits(T);
    r = ethers.utils.parseUnits(r);
    sigma = ethers.utils.parseUnits(sigma);
    m = ethers.utils.parseUnits(m);
    v = ethers.utils.parseUnits(v);
    lam = ethers.utils.parseUnits(lam);

    const input = [
      DAI,
      WETH,
      0,
      tokenB_balance,
      false,
      true,
      amount,
      0,
      fee,
      perDay,
      0,
      0,
      [K, T, r, sigma, m, v, lam],
    ];

    const tx = await optionmaker
      .connect(accounts[0])
      .JDM_START_REPLICATION(input);
    // wait until the transaction is mined
    await tx.wait();

    const pair = await optionmaker.getPair(DAI, WETH);
    console.log("address of pair:", pair);

    expect(await optionmaker.getPairUserAddress(pair, 0)).to.equal(
      accounts[0].address
    );
  });

  it("Position 3: BS Call replication: ", async () => {
    // input to JDM start replication
    let tokenA_balance = "5000";
    let amount = "1";
    let fee = "400";
    let perDay = "8";
    let K = "1400";
    let T = "0.3";
    let r = "0.15";
    let sigma = "0.8";

    tokenA_balance = ethers.utils.parseUnits(tokenA_balance);
    amount = ethers.utils.parseUnits(amount);
    fee = ethers.utils.parseUnits(fee);

    perDay = ethers.utils.parseUnits(perDay, "wei");

    K = ethers.utils.parseUnits(K);
    T = ethers.utils.parseUnits(T);
    r = ethers.utils.parseUnits(r);
    sigma = ethers.utils.parseUnits(sigma);

    const input = [
      DAI,
      WETH,
      tokenA_balance,
      0,
      true,
      true,
      amount,
      0,
      fee,
      perDay,
      0,
      0,
      [K, T, r, sigma],
    ];

    const tx = await optionmaker
      .connect(accounts[0])
      .BS_START_REPLICATION(input);
    // wait until the transaction is mined
    await tx.wait();

    const pair = await optionmaker.getPair(DAI, WETH);
    console.log("address of pair:", pair);

    expect(await optionmaker.getPairUserAddress(pair, 0)).to.equal(
      accounts[0].address
    );
  });

  it("Position 4: BS Put replication: ", async () => {
    // input to JDM start replication

    let tokenB_balance = "4";
    let amount = "1";
    let fee = "500";
    let perDay = "9";
    let K = "2000";
    let T = "0.5";
    let r = "0.11";
    let sigma = "0.95";

    tokenB_balance = ethers.utils.parseUnits(tokenB_balance);
    amount = ethers.utils.parseUnits(amount);
    fee = ethers.utils.parseUnits(fee);
    perDay = ethers.utils.parseUnits(perDay, "wei");
    K = ethers.utils.parseUnits(K);
    T = ethers.utils.parseUnits(T);
    r = ethers.utils.parseUnits(r);
    sigma = ethers.utils.parseUnits(sigma);

    const input = [
      DAI,
      WETH,
      0,
      tokenB_balance,
      false,
      true,
      amount,
      0,
      fee,
      perDay,
      0,
      0,
      [K, T, r, sigma],
    ];

    const tx = await optionmaker
      .connect(accounts[0])
      .BS_START_REPLICATION(input);
    // wait until the transaction is mined
    await tx.wait();

    const pair = await optionmaker.getPair(DAI, WETH);
    console.log("address of pair:", pair);

    expect(await optionmaker.getPairUserAddress(pair, 0)).to.equal(
      accounts[0].address
    );
  });

  it("Should get the number of positions of user: ", async () => {
    expect(await optionmaker.userIDlength(accounts[0].address)).to.equal(4);

    const positions = await optionmaker.userIDlength(accounts[0].address);

    const value = ethers.BigNumber.from(positions).toString();

    console.log("number of positions of user: ", value);
  });

  it("Should get amount of contracts from JDM_Options", async () => {
    const pair = await optionmaker.getPair(DAI, WETH);
    let JDMOption = await optionmaker.JDM_Options(pair, accounts[0].address, 0);

    amount = Math.round(ethers.utils.formatUnits(JDMOption[6], 18));

    expect(amount).to.equal(2);
  });
});
