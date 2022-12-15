const { expect } = require("chai");
const { BigNumber } = require("ethers");

const { parseUnits } = require("ethers/lib/utils");
const { ethers, network } = require("hardhat");

const DAI = "0x924f46Fcd0d9F6fcA457A546c7F702A29E675eE5";
const WETH = "0xB77C4E565a7368130AaC782fA548A817D2D2fd28";

// DAI_daiWHALE must be an account, not contract
const daiWHALE = "0x817998389F4E4d732129f2B37CBc165673da5b2E";
const wethWHALE = "0x817998389F4E4d732129f2B37CBc165673da5b2E";

var MAKER;

describe("Multiple User Replication", () => {
  let accounts;
  let dai;
  let daiwhale;
  let weth;
  let wethwhale;

  // libraries
  let Statslib;
  let HedgeMathlib;
  let BSlib;

  // main
  let optionmaker;

  // storage;
  let optionstorage;

  // periphery
  let bsoptionmaker;

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

  it("Should deploy libraries: ", async () => {
    signers = await ethers.getSigners();

    const Statistics = await ethers.getContractFactory("Statistics");
    Statslib = await Statistics.deploy();
    await Statslib.deployed();

    // @dev deploy HedgeMath.sol
    const HedgeMath = await ethers.getContractFactory("HedgeMath");
    HedgeMathlib = await HedgeMath.deploy();
    await HedgeMathlib.deployed();

    // @dev deploy Black Scholes model library
    const BS = await ethers.getContractFactory("BS", {
      signer: signers[0],
      libraries: {
        Statistics: Statslib.address,
      },
    });
    BSlib = await BS.deploy();
    await BSlib.deployed();
  });

  it("Should deploy storage", async () => {
    // @dev Deploying storage
    const OptionStorage = await ethers.getContractFactory("OptionStorage", {
      signer: signers[0],
    });
    // @dev accounts 1 & 2 are fillers
    optionstorage = await OptionStorage.deploy();
    await optionstorage.deployed();
    console.log("storage address:", optionstorage.address);
  });

  it("Should deploy periphery", async () => {
    // ######## @dev deploying periphery contracts Contracts ###########
    const BSOptionMaker = await ethers.getContractFactory("BSMOptionMaker", {
      signer: signers[0],
      libraries: {
        BS: BSlib.address,
        HedgeMath: HedgeMathlib.address,
      },
    });
    bsoptionmaker = await BSOptionMaker.deploy(DAI);
    await bsoptionmaker.deployed();

    console.log("periphery:", bsoptionmaker.address);

  });

  it("Should deploy main", async () => {
    // @dev Deploying main
    const OptionMaker = await ethers.getContractFactory("OptionMaker", {
      signer: signers[0],
      libraries: {
        BS: BSlib.address,
        HedgeMath: HedgeMathlib.address,
      },
    });
    optionmaker = await OptionMaker.deploy(
      optionstorage.address,
      bsoptionmaker.address,
      DAI
    );
    await optionmaker.deployed();

    console.log("core address:", optionmaker.address);
  });

  it("Should set core and periphery addresses in storage", async () => {
    let tx = await optionstorage
      .connect(accounts[0])
      .setCoreAddr(optionmaker.address);
    tx.wait();

    let tx1 = await optionstorage
      .connect(accounts[0])
      .setPeripheryAddr(
        bsoptionmaker.address
      );
    tx1.wait();

    await optionstorage.connect(accounts[0]).initializeAvailablePair(WETH, DAI);

  });

  it("Should set addresses inside periphery", async () => {
    // bs
    await bsoptionmaker
      .connect(accounts[0])
      .setStorageAddr(optionstorage.address);

    let storageAddr = await bsoptionmaker.connect(accounts[0]).getStorageAddr();
    console.log("storage addr: ", storageAddr);

    await bsoptionmaker.connect(accounts[0]).setCoreAddr(optionmaker.address);

    let coreAddr = await bsoptionmaker.connect(accounts[0]).getCoreAddr();
    console.log("core addr: ", coreAddr);


  });

  it("Should unlock dai", async () => {
    const amount = await dai.balanceOf(daiWHALE);
    const value = ethers.BigNumber.from(amount);
    console.log("DAI balance of whale", await ethers.utils.formatEther(value));

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

  });

  it("Should unlock weth", async () => {
    const amount = await weth.balanceOf(wethWHALE);
    const value = ethers.BigNumber.from(amount);
    console.log("weth balance of whale", await ethers.utils.formatEther(value));

    await weth.connect(wethwhale).transfer(accounts[0].address, amount);
    expect(await weth.balanceOf(accounts[0].address)).to.gte(amount);
    signer = (await ethers.getSigners())[0];

    await weth.connect(signer, accounts[0]).approve(optionmaker.address, amount);

    expect(
      await weth.allowance(accounts[0].address, optionmaker.address)
    ).to.gte(amount);

    const amount1 = await weth.balanceOf(accounts[0].address);
    const value1 = ethers.BigNumber.from(amount1);

    console.log(
      "weth balance of account",
      await ethers.utils.formatEther(value1)
    );

  });

  it("Position 1: BS Call replication: ", async () => {
    // input to BS start replication
    let tokenA_balance = "5000";
    let amount = "1";
    let fee = "400";
    let perDay = "24";
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

    const pair = await optionstorage.getPair(DAI, WETH);
    console.log("address of pair:", pair);

    expect(await optionstorage.getPairUserAddress(pair, 0)).to.equal(
      accounts[0].address
    );
  });

  it("Position 2: BS Put replication: ", async () => {
    // input to JDM start replication

    let tokenB_balance = "4";
    let amount = "1";
    let fee = "1000";
    let perDay = "12";
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

    const pair = await optionstorage.getPair(DAI, WETH);
    console.log("address of pair:", pair);

    expect(await optionstorage.getPairUserAddress(pair, 0)).to.equal(
      accounts[0].address
    );
  });

  it("Position 3: BS Call replication: ", async () => {
    // input to JDM start replication
    let tokenA_balance = "2000";
    let amount = "1";
    let fee = "400";
    let perDay = "24";
    let K = "1100";
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

    const pair = await optionstorage.getPair(DAI, WETH);
    console.log("address of pair:", pair);

    expect(await optionstorage.getPairUserAddress(pair, 0)).to.equal(
      accounts[0].address
    );
  });

  it("Position 4: BS Put replication: ", async () => {
    // input to JDM start replication

    let tokenB_balance = "2";
    let amount = "1";
    let fee = "1000";
    let perDay = "24";
    let K = "1150";
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

    const pair = await optionstorage.getPair(DAI, WETH);
    console.log("address of pair:", pair);

    expect(await optionstorage.getPairUserAddress(pair, 0)).to.equal(
      accounts[0].address
    );
  });

  it("Should get the number of positions of user: ", async () => {
    expect(await optionstorage.userIDlength(accounts[0].address)).to.equal(4);

    const positions = await optionstorage.userIDlength(accounts[0].address);

    const value = ethers.BigNumber.from(positions).toString();

    console.log("number of positions of user: ", value);
  });

  it("Change time: ", async () => {
    // getting timestamp
    const blockNumBefore = await ethers.provider.getBlockNumber();
    const blockBefore = await ethers.provider.getBlock(blockNumBefore);

    const currenttimestamp = blockBefore.timestamp;
    console.log("timenow", currenttimestamp);

    // await ethers.provider.send("evm_mine", [newTimestampInSeconds]);

    await hre.ethers.provider.send("evm_increaseTime", [24 * 60 * 120]);
    await network.provider.send("evm_mine");

    const blockNumBefore1 = await ethers.provider.getBlockNumber();
    const blockBefore1 = await ethers.provider.getBlock(blockNumBefore1);

    const currenttimestamp1 = blockBefore1.timestamp;
    console.log("timenow", currenttimestamp1);
  });

  it("Hedge BS Call: ", async () => {
    const pair = await optionstorage.getPair(DAI, WETH);

    const user = await optionstorage.getPairUserAddress(pair, 0);
    console.log("user in hedge func", user);

    const tx = await optionmaker.connect(accounts[1]).BS_HEDGE(pair, user, 0, {
      gasLimit: 2000000,
    });

    await tx.wait();

    let bs_option = await optionstorage.BS_Options(pair, user, 0);

    let hedgeFee = ethers.BigNumber.from(bs_option.hedgeFee);

    console.log("hedge fee DAI", hedgeFee);

    let daiBalance = await dai.balanceOf(accounts[1].address);

    daiBalance = ethers.BigNumber.from(daiBalance);
    console.log("paid fee DAI", daiBalance);
  });

  it("Hedge BS Put: ", async () => {
    const pair = await optionstorage.getPair(DAI, WETH);

    const user = await optionstorage.getPairUserAddress(pair, 0);
    console.log("user in hedge func", user);

    const tx = await optionmaker.connect(accounts[1]).BS_HEDGE(pair, user, 1, {
      gasLimit: 2000000,
    });

    await tx.wait();

    let bs_option = await optionstorage.BS_Options(pair, user, 0);

    let hedgeFee = ethers.BigNumber.from(bs_option.hedgeFee);

    console.log("hedge fee DAI", hedgeFee);

    let daiBalance = await dai.balanceOf(accounts[1].address);

    daiBalance = ethers.BigNumber.from(daiBalance);
    console.log("paid fee DAI", daiBalance);
  });


  it("Close and withdraw position: ", async () => {

    const ID = 0;

    const pair = await optionstorage.getPair(DAI, WETH);

    let tokenA_balance_c0 = await optionstorage.BS_Options_tokenA_balance(pair, accounts[0].address, ID);
    let tokenB_balance_c0 = await optionstorage.BS_Options_tokenB_balance(pair, accounts[0].address, ID);

    // console.log("tokenA_balance_c0", tokenA_balance_c0);
    // console.log("tokenB_balance_c0", tokenB_balance_c0);

    const fee_c0 = await optionstorage.BS_Options_fee_balance(pair, accounts[0].address, ID);

    console.log("fee_c0", fee_c0);

    const tokenA_balance_t0 = await dai.balanceOf(accounts[0].address);
    const tokenB_balance_t0 = await weth.balanceOf(accounts[0].address);

    // console.log("tokenA_balance_t0", tokenA_balance_t0);
    // console.log("tokenB_balance_t0", tokenB_balance_t0);

    const tx = await optionmaker.connect(accounts[0]).BS_Withdraw(pair, 0, {
      gasLimit: 2000000,
    });

    await tx.wait();

    const tokenA_balance_t1 = await dai.balanceOf(accounts[0].address);
    const tokenB_balance_t1 = await weth.balanceOf(accounts[0].address);

    // console.log("tokenA_balance_t1", tokenA_balance_t1);
    // console.log("tokenB_balance_t1", tokenB_balance_t1);
  
    const tokenA_balance_dx = BigInt(tokenA_balance_t1 - tokenA_balance_t0);
    const tokenB_balance_dx = BigInt(tokenB_balance_t1 - tokenB_balance_t0);

    // console.log("tokenA_balance_dx", tokenA_balance_dx);
    // console.log("tokenB_balance_dx", tokenB_balance_dx);

    expect(tokenA_balance_dx).to.equal(BigInt(tokenA_balance_c0) + BigInt(fee_c0));
    expect(tokenB_balance_dx).to.equal(tokenB_balance_c0);

    expect(await optionstorage.BS_Options_tokenA_balance(pair, accounts[0].address, ID)).to.equal(0);
    expect(await optionstorage.BS_Options_tokenB_balance(pair, accounts[0].address, ID)).to.equal(0);
    expect(await optionstorage.BS_Options_fee_balance(pair, accounts[0].address, ID)).to.equal(0);
  });
});
