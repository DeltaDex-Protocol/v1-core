const { ethers } = require("hardhat");
const { sluDependencies } = require("mathjs");

var Addresses = require("./addresses.js");
require("dotenv").config();

async function main() {
  let addresses = Addresses.LoadAddresses();

  let DAI = addresses.sDAI;
  let WETH = addresses.sWETH;
  let MAKER = addresses.optionmaker;
  let STORAGE = addresses.optionstorage;

  const RPC = 'https://rpc.ankr.com/polygon_mumbai';
  const provider = new ethers.providers.JsonRpcProvider(RPC);
  const signer = new ethers.Wallet(process.env.PRIVATE_KEY_1, provider);

  const sDAI = await ethers.getContractAt("IERC20", DAI);
  const sWETH = await ethers.getContractAt("IERC20", WETH);

  const optionmaker = await ethers.getContractAt("OptionMaker", MAKER);

  const optionstorage = await ethers.getContractAt("OptionStorage", STORAGE);

  const amountDAI = await sDAI.balanceOf(signer.address);
  const amountWETH = await sDAI.balanceOf(signer.address);


  const tx1 = await sDAI.connect(signer).approve(optionmaker.address, amountDAI);
  await tx1.wait();
  // sleep(20000);
  const tx2 = await sWETH.connect(signer).approve(optionmaker.address, amountWETH);
  await tx2.wait();
  // sleep(20000);


  // input to BS start replication
  let tokenA_balance = "5000";
  let amount = "1";
  let fee = "4000";
  let perDay = "1440";
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
    .connect(signer)
    .BS_START_REPLICATION(input);
  // wait until the transaction is mined
  await tx.wait();

  const pair = await optionstorage.getPair(DAI, WETH);
  console.log("address of pair:", pair);

  const position = await optionstorage.BS_Options(pair, signer.address, 0);

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
