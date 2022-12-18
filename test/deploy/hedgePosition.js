// Copyright 2022 DeltaDex

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


    const pair = await optionstorage.getPair(DAI, WETH);

    let user = await optionstorage.getUserAddressesInPair(pair);
    user = user[0];

    console.log(pair);
    console.log(user);
  

    let ID = 0;


    try {
        const tx = await optionmaker.connect(signer).BS_HEDGE(pair, user, ID);
        await tx.wait();
        console.log("Hedging Position Success");  

    } catch(err) {
        console.log("Hedging Failed");
        console.log(err);
    }

}



main().then(() => process.exit(0)).catch((error) => {
    console.error(error);
    process.exit(1);
});
