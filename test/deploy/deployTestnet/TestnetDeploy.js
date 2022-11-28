const { executionAsyncId } = require("async_hooks");
const { expect } = require("chai");
const { parseUnits } = require("ethers/lib/utils");
const { ethers, network } = require("hardhat");

// var deltadex_dai = "0x739c9A6Df880fc77b7de2E6ce83B2c8a9702F619";
// var deltadex_weth = "0xF914C539E3B38d10dB0E6095891BFC80749FF909";

// var stats_lib = "0x582521Ae7B25Fb3d5Eb30331FCd958538f137AdA";
// var hedgemath = '0xce329d6906b4b79f0ecdb14a5c29d8cee52861a9';
// var bs_lib = '0xB00fe940089804DC8741E196E051ca597F28cCf4';
// var jdm_lib = '0x9Daef70c872FD036cdB065496032c7de7fdD50cE';
// var bsc_lib = '0x800b1c6E672842BAbC4541B15D715e1a62647253';

// var bs_option_maker = '0xc555EeA86616846B6A0dBE29B3468D13AC2da0Ff';
// var jdm_option_maker = '0x1d7E5E00904C02771FaaAf574BA96E4602aeA015';
// var bsc_option_maker = '0x17FC6C155C5F52202A0c04003b4F5B91A11559D8';
// var option_maker = '0xcd9CE3abF3cdcDf051C32b928a771584077DcB78'; // 0x94e95f4fc9fada36c48bdca3b3af5fe507f787c1

// var deltadex_dai;
// var deltadex_weth;

// var stats_lib;
// var hedgemath;
// var bs_lib;
// var jdm_lib;
// var bsc_lib;

// var bs_option_maker;
// var jdm_option_maker;
// var bsc_option_maker;
// var option_maker;



const LoadAddresses = (callback) => {
  var fs = require("fs");
  // fs.writeFile('../deploy/deployTestnet/myjsonfile.json', `{"table": []}`, 'utf8', () => {});
  return JSON.parse(
    fs.readFileSync("test/deploy/deployTestnet/addresses.json", "utf8")
  );
};

// [{name: '', addr: ''}]
const UpdateAddresses = (newAddresses) => {
  var fs = require("fs");

  newAddresses = JSON.stringify(newAddresses);
  fs.writeFileSync(
    "test/deploy/deployTestnet/addresses.json",
    newAddresses,
    "utf8"
  );

  // fs.readFile('../deploy/deployTestnet/addresses.json', 'utf8', function readFileCallback(err, data){
  //   if (err){
  //     console.log(err);
  //   } else {

  //     data = JSON.parse(data); //now it's an object

  //     // obj[name] = address;
  //     // json = JSON.stringify(obj); //convert it back to json
  //     // console.log(obj);
  //   }
  // });
};

// UpdateAddress("deltadex_dai", '123'); // works

const DeployTokenContracts = async (
  ShouldUDeployNewTokenContracts,
  addresses
) => {
  if (ShouldUDeployNewTokenContracts) {
    const _dai = await ethers.getContractFactory("DeltaDexDAI");
    let DeltaDexDAI = await _dai.deploy();
    console.log("New DeltaDexDAI address:", DeltaDexDAI.address);

    const _weth = await ethers.getContractFactory("DeltaDexWETH");
    let DeltaDexWETH = await _weth.deploy();
    console.log("New DeltaDexWETH address:", DeltaDexWETH.address);

    return [DeltaDexDAI.address, DeltaDexWETH.address];
  } else {
    console.log();
    let DeltaDexDAI = await ethers.getContractAt(
      "DeltaDexDAI",
      addresses.deltadex_dai
    );
    let DeltaDexWETH = await ethers.getContractAt(
      "DeltaDexWETH",
      addresses.deltadex_weth
    );

    return [DeltaDexDAI.address, DeltaDexWETH.address];
  }
};

async function MintTokens(addresses, amount, ShouldUDeployNewTokenContracts) {
  const [deployer, anotherAccount] = await ethers.getSigners();

  // const ShouldUDeployNewTokenContracts = true;  // either should update dd_dai, dd_weth contracts or not

  console.log("Deployer", deployer.address);
  console.log("SecondUser", anotherAccount.address);

  const DeployerWeiAmount = (await deployer.getBalance()).toString();
  const SecondUserWeiAmount = (await anotherAccount.getBalance()).toString();

  console.log(
    "Deployer balance:",
    await ethers.utils.formatEther(DeployerWeiAmount)
  );
  console.log(
    "SecondUser balance:",
    await ethers.utils.formatEther(SecondUserWeiAmount)
  );

  [deltadex_dai, deltadex_weth] = await DeployTokenContracts(
    ShouldUDeployNewTokenContracts,
    addresses
  );

  addresses.deltadex_dai = deltadex_dai;
  addresses.deltadex_weth = deltadex_weth;
  UpdateAddresses(addresses);

  const DeltaDexDAI = await ethers.getContractAt("DeltaDexDAI", deltadex_dai);
  const DeltaDexWETH = await ethers.getContractAt(
    "DeltaDexWETH",
    deltadex_weth
  );

  amount = ethers.utils.parseUnits(amount + "", "ether");

  console.log(ethers.utils.formatEther(amount));
  await DeltaDexDAI.connect(anotherAccount).mint(amount);
  await DeltaDexWETH.connect(anotherAccount).mint(amount);

  // console.log("SecondUser's DAI balance", ethers.utils.formatEther(await DeltaDexDAI.balanceOf(anotherAccount.address)));
  // console.log("SecondUser's WETH balance", ethers.utils.formatEther(await DeltaDexWETH.balanceOf(anotherAccount.address)));

  return [addresses.deltadex_dai, addresses.deltadex_weth];
}

async function DeployLibs() {
  const [deployer, anotherAccount] = await ethers.getSigners();

  const Statistics = await ethers.getContractFactory("Statistics");
  const Statslib = await Statistics.deploy();
  await Statslib.deployed();
  console.log("stats library:", Statslib.address);

  // @dev deploy HedgeMath.sol
  const HedgeMath = await ethers.getContractFactory("HedgeMath");
  const HedgeMathlib = await HedgeMath.deploy();
  await HedgeMathlib.deployed();
  console.log("hedgemath library:", HedgeMathlib.address);

  // @dev deploy Black Scholes model library
  const BS = await ethers.getContractFactory("BS", {
    signer: deployer,
    libraries: {
      Statistics: Statslib.address,
    },
  });
  const BSlib = await BS.deploy();
  await BSlib.deployed();
  console.log("BS library:", BSlib.address);

  // @dev deploy Jump Diffusion model library
  const JDM = await ethers.getContractFactory("JDM", {
    signer: deployer,
    libraries: {
      Statistics: Statslib.address,
    },
  });
  const JDMlib = await JDM.deploy();
  await JDMlib.deployed();
  console.log("JDM library:", JDMlib.address);

  // @dev deploy Curved options model library
  const BSC = await ethers.getContractFactory("BSC", {
    signer: deployer,
    libraries: {
      Statistics: Statslib.address,
    },
  });
  const BSClib = await BSC.deploy();
  await BSClib.deployed();
  console.log("BSC library:", BSClib.address);

  return [
    Statslib.address,
    HedgeMathlib.address,
    BSlib.address,
    JDMlib.address,
    BSClib.address,
  ];
}

async function DeployPeriphery(addresses) {
  const [deployer, anotherAccount] = await ethers.getSigners();

  const BSlib = await ethers.getContractAt("BS", addresses.bs_lib);
  const JDMlib = await ethers.getContractAt("JDM", addresses.jdm_lib);
  const BSClib = await ethers.getContractAt("BSC", addresses.bsc_lib);
  const HedgeMathlib = await ethers.getContractAt(
    "HedgeMath",
    addresses.hedgemath
  );

  // console.log((await BSlib).address)

  const BSOptionMaker = await ethers.getContractFactory("BSOptionMaker", {
    signer: deployer,
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
    signer: deployer,
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
    signer: deployer,
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

  return [
    bsoptionmaker.address,
    jdmoptionmaker.address,
    bscoptionmaker.address,
  ];
}

async function DeployOptionMaker(addresses) {
  const [deployer] = await ethers.getSigners();

  // @dev Deploying main
  const OptionMaker = await ethers.getContractFactory("OptionMaker", {
    signer: deployer,
    libraries: {
      BS: addresses.bs_lib,
      JDM: addresses.jdm_lib,
      BSC: addresses.bsc_lib,
      HedgeMath: addresses.hedgemath,
    },
  });
  optionmaker = await OptionMaker.deploy(
    addresses.bs_option_maker,
    addresses.jdm_option_maker,
    addresses.bsc_option_maker
  );
  await optionmaker.deployed();

  console.log("OptionMaker address:", optionmaker.address);

  return [optionmaker.address];
}

async function approveTokens(addresses, amount) {
  const optionmaker = await ethers.getContractAt(
    "OptionMaker",
    addresses.option_maker
  );
  let DeltaDexDAI = await ethers.getContractAt(
    "DeltaDexDAI",
    addresses.deltadex_dai
  );
  let DeltaDexWETH = await ethers.getContractAt(
    "DeltaDexWETH",
    addresses.deltadex_weth
  );

  const [deployer, anotherAccount] = await ethers.getSigners();

  let approve_amount = amount + "";
  console.log(amount);
  approve_amount = ethers.utils.parseUnits(approve_amount);

  var tx = await DeltaDexDAI.connect(anotherAccount).approve(
    optionmaker.address,
    approve_amount
  );
  await tx.wait();
  tx = await DeltaDexWETH.connect(anotherAccount).approve(
    optionmaker.address,
    approve_amount
  );
  await tx.wait();

  console.log("both tokens approved");
}

async function JDMCallReplication(addresses) {
  const optionmaker = await ethers.getContractAt(
    "OptionMaker",
    addresses.option_maker
  );
  let DeltaDexDAI = await ethers.getContractAt(
    "DeltaDexDAI",
    addresses.deltadex_dai
  );
  let DeltaDexWETH = await ethers.getContractAt(
    "DeltaDexDAI",
    addresses.deltadex_weth
  );

  const [deployer, anotherAccount] = await ethers.getSigners();

  // input to JDM start replication
  let tokenA_balance = "3000";
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
    addresses.deltadex_dai,
    addresses.deltadex_weth,
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
    .connect(anotherAccount)
    .JDM_START_REPLICATION(input);
  // wait until the transaction is mined
  await tx.wait();
  console.log(input);

  const pair = await optionmaker.getPair(
    addresses.deltadex_dai,
    addresses.deltadex_weth
  );
  console.log("address of pair:", pair);
}

async function BSCallReplication(addresses) {
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
    addresses.deltadex_dai,
    addresses.deltadex_weth,
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

  const tx = await optionmaker.connect(deployer).BS_START_REPLICATION(input);
  // wait until the transaction is mined
  await tx.wait();

  const pair = await optionmaker.getPair(addresses.deltadex_dai, deltadex_weth);
  console.log("address of pair:", pair);
}

const main = async () => {
  var addresses = LoadAddresses();

  console.log(addresses);

  [deltadex_dai, deltadex_weth] = await MintTokens(addresses, 10 ** 7, false);
  addresses.deltadex_dai = deltadex_dai;
  addresses.deltadex_weth = deltadex_weth;
  UpdateAddresses(addresses);
  console.log("tokens updated");

  // approveTokens(addresses, 10**7)

  // [stats_lib, hedgemath, bs_lib, jdm_lib, bsc_lib] = await DeployLibs(addresses);
  // addresses.stats_lib = stats_lib;
  // addresses.hedgemath = hedgemath;
  // addresses.bs_lib = bs_lib;
  // addresses.jdm_lib = jdm_lib;
  // addresses.bsc_lib = bsc_lib;
  // UpdateAddresses(addresses);

  // // console.log(addresses)

  // [bs_option_maker, jdm_option_maker, bsc_option_maker] = await DeployPeriphery(addresses);
  // addresses.bs_option_maker = bs_option_maker;
  // addresses.jdm_option_maker = jdm_option_maker;
  // addresses.bsc_option_maker = bsc_option_maker;
  // UpdateAddresses(addresses);

  // [option_maker] = await DeployOptionMaker(addresses);
  // addresses.option_maker = option_maker;
  // UpdateAddresses(addresses);

  // not works:
  // JDMCallReplication(addresses)
  // BSCallReplication(addresses);
};

main();

// MintTokens()
//   .then(() => process.exit(0))
//   .catch((error) => {
//     console.error(error);
//     process.exit(1);
// });
