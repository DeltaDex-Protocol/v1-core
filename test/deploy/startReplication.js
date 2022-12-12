const { ethers } = require("hardhat");
const { sluDependencies } = require("mathjs");

var Addresses = require("./addresses.js");

async function main() {
  let addresses = Addresses.LoadAddresses();

  let DAI = addresses.sDAI;
  let WETH = addresses.sWETH;
  let MAKER = addresses.optionmaker;
  let STORAGE = addresses.optionstorage;

  const signers = await ethers.getSigners();

  const sDAI = await ethers.getContractAt("IERC20", DAI);
  const sWETH = await ethers.getContractAt("IERC20", WETH);

  const optionmaker = await ethers.getContractAt("OptionMaker", MAKER);

  const optionstorage = await ethers.getContractAt("OptionStorage", STORAGE);

  const amountDAI = await sDAI.balanceOf(signers[0].address);
  const amountWETH = await sDAI.balanceOf(signers[0].address);


  await sDAI.connect(signers[0]).approve(optionmaker.address, amountDAI);
  // sleep(20000);
  await sWETH.connect(signers[0]).approve(optionmaker.address, amountWETH);
  // sleep(20000);


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
    .connect(signers[0])
    .BS_START_REPLICATION(input);
  // wait until the transaction is mined
  await tx.wait();

  const pair = await optionstorage.getPair(DAI, WETH);
  console.log("address of pair:", pair);

  const position = await optionstorage.BS_Options(pair, signers[0].address, 0);

  console.log("position:", position);
}

function sleep(milliseconds) {
  const date = Date.now();
  let currentDate = null;
  do {
    currentDate = Date.now();
  } while (currentDate - date < milliseconds);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
