const { sluDependencies } = require("mathjs");
var Addresses = require("./addresses.js");

async function main() {
  const signers = await ethers.getSigners();

  let currentAddresses = Addresses.LoadAddresses();

  // ADDRESSES OF ERC20 TOKENS
  const DAI = currentAddresses.sDAI;
  const WETH = currentAddresses.sWETH;

  // let dai;
  // let daiwhale;
  // let weth;
  // let wethwhale;

  // libraries
  let Statslib;
  let HedgeMathlib;
  let BSlib;
  let JDMlib;
  let BSClib;

  // main
  let optionmaker;

  // storage;
  let optionstorage;

  // periphery
  let bsoptionmaker;
  let jdmoptionmaker;
  let bscoptionmaker;

  const Statistics = await ethers.getContractFactory("Statistics");
  Statslib = await Statistics.deploy();
  await Statslib.deployed();

  console.log(Statslib.address);

  currentAddresses.Statslib = Statslib.address;
  Addresses.UpdateAddresses(currentAddresses);

  // @dev deploy HedgeMath.sol
  const HedgeMath = await ethers.getContractFactory("HedgeMath");
  HedgeMathlib = await HedgeMath.deploy();
  await HedgeMathlib.deployed();

  currentAddresses.HedgeMathlib = HedgeMathlib.address;
  Addresses.UpdateAddresses(currentAddresses);

  // @dev deploy Black Scholes model library
  const BS = await ethers.getContractFactory("BS", {
    signer: signers[0],
    libraries: {
      Statistics: Statslib.address,
    },
  });
  BSlib = await BS.deploy();
  await BSlib.deployed();

  currentAddresses.BSlib = BSlib.address;
  Addresses.UpdateAddresses(currentAddresses);

  // @dev deploy JDM model library
  const JDM = await ethers.getContractFactory("JDM", {
    signer: signers[0],
    libraries: {
      Statistics: Statslib.address,
    },
  });
  JDMlib = await JDM.deploy();
  await JDMlib.deployed();
  console.log("JDM library:", JDMlib.address);

  currentAddresses.JDMlib = JDMlib.address;
  Addresses.UpdateAddresses(currentAddresses);

  // @dev deploy Curved options model library
  const BSC = await ethers.getContractFactory("BSC", {
    signer: signers[0],
    libraries: {
      Statistics: Statslib.address,
    },
  });
  BSClib = await BSC.deploy();
  await BSClib.deployed();
  console.log("BSC library:", BSClib.address);

  currentAddresses.BSClib = BSClib.address;
  Addresses.UpdateAddresses(currentAddresses);

  // @dev Deploying storage
  const OptionStorage = await ethers.getContractFactory("OptionStorage", {
    signer: signers[0],
  });
  // @dev signers 1 & 2 are fillers
  optionstorage = await OptionStorage.deploy();
  await optionstorage.deployed();
  console.log("storage address:", optionstorage.address);

  currentAddresses.optionstorage = optionstorage.address;
  Addresses.UpdateAddresses(currentAddresses);

  // ######## @dev deploying periphery contracts Contracts ###########
  const BSOptionMaker = await ethers.getContractFactory("BSMOptionMaker", {
    signer: signers[0],
    libraries: {
      BS: BSlib.address,
      HedgeMath: HedgeMathlib.address,
    },
  });
  bsoptionmaker = await BSOptionMaker.deploy();
  await bsoptionmaker.deployed();

  console.log("periphery:", bsoptionmaker.address);

  currentAddresses.bsoptionmaker = bsoptionmaker.address;
  Addresses.UpdateAddresses(currentAddresses);

  const JDMOptionMaker = await ethers.getContractFactory("JDMOptionMaker", {
    signer: signers[0],
    libraries: {
      JDM: JDMlib.address,
      HedgeMath: HedgeMathlib.address,
    },
  });
  jdmoptionmaker = await JDMOptionMaker.deploy();
  await jdmoptionmaker.deployed();

  console.log("periphery:", jdmoptionmaker.address);

  currentAddresses.jdmoptionmaker = jdmoptionmaker.address;
  Addresses.UpdateAddresses(currentAddresses);

  const BSCOptionMaker = await ethers.getContractFactory("BSCOptionMaker", {
    signer: signers[0],
    libraries: {
      BSC: BSClib.address,
      HedgeMath: HedgeMathlib.address,
    },
  });
  bscoptionmaker = await BSCOptionMaker.deploy();
  await bscoptionmaker.deployed();

  console.log("BSCOptionMaker address:", bscoptionmaker.address);

  currentAddresses.bscoptionmaker = bscoptionmaker.address;
  Addresses.UpdateAddresses(currentAddresses);

  // @dev Deploying main
  const OptionMaker = await ethers.getContractFactory("OptionMaker", {
    signer: signers[0],
    libraries: {
      BS: BSlib.address,
      JDM: JDMlib.address,
      // BSC: BSClib.address,
      HedgeMath: HedgeMathlib.address,
    },
  });
  optionmaker = await OptionMaker.deploy(
    optionstorage.address,
    bsoptionmaker.address,
    jdmoptionmaker.address,
    bscoptionmaker.address
  );
  await optionmaker.deployed();

  console.log("core address:", optionmaker.address);

  currentAddresses.optionmaker = optionmaker.address;
  Addresses.UpdateAddresses(currentAddresses);

  sleep(20000);
  console.log("woke up 1");

  let tx = await optionstorage
    .connect(signers[0])
    .setCoreAddr(optionmaker.address);
  await tx.wait();

  sleep(20000);
  console.log("woke up 2");

  let tx1 = await optionstorage
    .connect(signers[0])
    .setPeripheryAddr(
      bsoptionmaker.address,
      jdmoptionmaker.address,
      bscoptionmaker.address
    );
  await tx1.wait();

  sleep(20000);
  console.log("woke up 3");

  // bs

  await bsoptionmaker
    .connect(signers[0])
    .setStorageAddr(optionstorage.address, {
      gasLimit: 3000000,
    });

  sleep(20000);
  console.log("woke up 4");

  let storageAddr = await bsoptionmaker.connect(signers[0]).getStorageAddr();
  console.log("storage addr: ", storageAddr);

  await bsoptionmaker.connect(signers[0]).setCoreAddr(optionmaker.address, {
    gasLimit: 3000000,
  });

  sleep(20000);
  console.log("woke up 5");

  let coreAddr = await bsoptionmaker.connect(signers[0]).getCoreAddr();
  console.log("core addr: ", coreAddr);

  // jdm
  await jdmoptionmaker
    .connect(signers[0])
    .setStorageAddr(optionstorage.address, {
      gasLimit: 3000000,
    });

  sleep(20000);
  console.log("woke up 6");

  let storageAddr1 = await jdmoptionmaker.connect(signers[0]).getStorageAddr();
  console.log("storage addr: ", storageAddr1);

  await jdmoptionmaker.connect(signers[0]).setCoreAddr(optionmaker.address, {
    gasLimit: 3000000,
  });

  sleep(20000);
  console.log("woke up 7");

  let coreAddr1 = await jdmoptionmaker.connect(signers[0]).getCoreAddr();
  console.log("core addr: ", coreAddr1);

  // bsc
  await bscoptionmaker
    .connect(signers[0])
    .setStorageAddr(optionstorage.address, {
      gasLimit: 3000000,
    });

  sleep(20000);
  console.log("woke up 8");

  let storageAddr2 = await bscoptionmaker.connect(signers[0]).getStorageAddr();
  console.log("storage addr: ", storageAddr2);

  await bscoptionmaker.connect(signers[0]).setCoreAddr(optionmaker.address, {
    gasLimit: 3000000,
  });

  sleep(20000);
  console.log("woke up 9");

  let coreAddr2 = await bscoptionmaker.connect(signers[0]).getCoreAddr();
  console.log("core addr: ", coreAddr2);
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
