// Copyright 2022 DeltaDex

const {ethers} = require('ethers');
const { round } = require('mathjs');

var Addresses = require("./addresses.js");
require("dotenv").config();


async function main() {
    let addresses = Addresses.LoadAddresses();

    let DAI = addresses.sDAI;
    let WETH = addresses.sWETH;

    const RPC = 'https://rpc.ankr.com/polygon_mumbai';
    const provider = new ethers.providers.JsonRpcProvider(RPC);
    const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

    const sDAI = await ethers.getContractAt("IERC20", DAI);

    const optionmaker = await ethers.getContractAt("OptionMaker", MAKER);
    const optionstorage = await ethers.getContractAt("OptionStorage", STORAGE);

    const amountDAI = await sDAI.balanceOf(signer.address);
  
    const pair = await optionstorage.getPair(DAI.address, WETH.address);

    let user = await optionstorage.getUserAddressesInPair(pair);
    user = user[0];

    let ID = 0;



    try {
        await optionmaker.BS_HEDGE(pair, user, ID);
    } catch(err) {
        console.log("Hedging Failed");
        console.log(err);
    }
    console.log("Hedging Position Success");  

}



main().then(() => process.exit(0)).catch((error) => {
    console.error(error);
    process.exit(1);
});
