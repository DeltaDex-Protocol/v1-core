// const { sluDependencies } = require("mathjs");
var Addresses = require("./addresses.js");

async function main() {
  const signers = await ethers.getSigners();

  let addresses = Addresses.LoadAddresses();

  // ADDRESSES OF ERC20 TOKENS
  const DAI = addresses.sDAI;
  const WETH = addresses.sWETH;

  let MAKER = addresses.optionmaker;
  let STORAGE = addresses.optionstorage;
  let BSMAKER = addresses.bsoptionmaker;

  // const sDAI = await ethers.getContractAt("IERC20", DAI);
  // const sWETH = await ethers.getContractAt("IERC20", WETH);

  const optionmaker = await ethers.getContractAt("OptionMaker", MAKER);
  const optionstorage = await ethers.getContractAt("OptionStorage", STORAGE);
  const bsoptionmaker = await ethers.getContractAt("BSMOptionMaker", BSMAKER);


  // ######## @dev setting addresses ###########
  // sleep(20000);
  console.log("woke up 1");

  let tx = await optionstorage.connect(signers[0]).setCoreAddr(optionmaker.address);
  await tx.wait();

  // sleep(20000);
  console.log("woke up 2");

  let tx1 = await optionstorage.connect(signers[0]).setPeripheryAddr(bsoptionmaker.address);
  await tx1.wait();

  // sleep(20000);
  console.log("woke up 3");

  let tx2 = await optionstorage.connect(signers[0]).initializeAvailablePair(WETH, DAI);
  await tx2.wait();

  // sleep(20000);
  console.log("woke up 4");

  // ######## @dev setting addresses ###########
  let tx3 = await bsoptionmaker.connect(signers[0]).setStorageAddr(optionstorage.address);
  await tx3.wait();

  // sleep(20000);
  console.log("woke up 5");

  let storageAddr = await bsoptionmaker.connect(signers[0]).getStorageAddr();
  console.log("storage addr: ", storageAddr);

  let tx4 = await bsoptionmaker.connect(signers[0]).setCoreAddr(optionmaker.address);
  await tx4.wait();

  // sleep(20000);
  console.log("woke up 6");

  let coreAddr = await bsoptionmaker.connect(signers[0]).getCoreAddr();
  console.log("core addr: ", coreAddr);
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
