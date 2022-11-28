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

  const balance = await sDAI.allowance(signers[0].address, optionmaker.address);

  console.log(balance);

  // const pairAddress = await optionstorage.getPair(DAI.address, WETH.address);

  /*   const allowance = await sDAI.allowance(
    signers[0].address,
    optionmaker.address
  ); */

  // console.log(pairAddress);

  // console.log(amount);
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
