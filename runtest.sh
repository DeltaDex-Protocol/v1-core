#!/bin/sh

gnome-terminal -- npx hardhat node --fork https://mainnet.infura.io/v3/d234aacbaae64bfc8a7c0ba9821045e9

sleep 10

#npx hardhat --network localhost test test/deployTest.test.js

npx hardhat --network localhost test test/startReplication.test.js

npx hardhat --network localhost test test/hedgePositions.test.js