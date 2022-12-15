## Deploy readme

```sh
npx hardhat node
```

```sh
npx hardhat run test/deploy/deploy.js --network localhost
```

```sh
npx hardhat test test/deploy/unlock.test.js --network localhost
```

```sh
npx hardhat run test/deploy/startReplication.js --network localhost
```



## Deploying to Mumbai

Deploy mock ERC20 tokens first

```sh
npx hardhat run test/deploy/deployTokens.js --network mumbai
```

Then go and add liquidity on Uniswap on mumbai

```sh
npx hardhat run test/deploy/deploy.js --network mumbai
```

```sh
npx hardhat run test/deploy/startReplication.js --network localhost
```



Addresses.json for Mumbai testnet fork: 

{"sDAI":"0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063","sWETH":"0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619","Statslib":"0x6b43dA4ed31e42506c1B84118E63B9929cEEe578","HedgeMathlib":"0xEAf918cc3aba362aDFBf6Ce1D95039bF4EbDB259","BSlib":"0xEC6B0295fDb988952652ed75e1EECC3e94237A46","optionstorage":"0x6E9355354c162252E473CFf3e5902603883d93A5","bsoptionmaker":"0x60c0410B32c353b2198864BE81B44Acc74856387","optionmaker":"0x90DfA64fF1E169D7b9A496Baa64Bf423CE83b67e"}





Notes:
if you get the OLD error message from uniswap, adjust secondsAgo variable in estimateAmountOut function...