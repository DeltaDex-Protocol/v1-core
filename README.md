# v1-core

```sh
       _
__   _/ |       ___ ___  _ __ ___
\ \ / / |_____ / __/ _ \| '__/ _ \
 \ V /| |_____| (_| (_) | | |  __/
  \_/ |_|      \___\___/|_|  \___|
```

### 1) Fork Mainnet:

```sh
npx hardhat node
```

### 2) Deploy v1-core to mainnet fork:

```sh
npx hardhat --network localhost test test/deploy/newDeploy.test.js
```

#### To get ABI of OptionMaker.sol:

```sh
npx hardhat clean
npx hardhat compile
```

## @dev notes:

Any file marked with ending .sol~ is currently in development.
These files will be integrated in future commits.

#### Changing addresses of DAI for MAINNET vs TESTNET:

1. periphery/PeripheryController.sol
2. OptionHedger.sol

#### Verifying a contract on Etherscan in terminal:

npx hardhat verify --contract contracts/testnet/DeltaDexDAI.sol:DeltaDexDAI --network rinkeby 0xaaa31658EfA0da2a69fE925Ff652FeCb9cF94E24

#### Testnet DAI and WETH

DAI address 0x2dc042385a6b1efaeec4816118e704028a733bed
WETH address 0xA8132b63AdE6ff0eAFE2b6a8E7E252A2418eCCec

https://rinkeby.etherscan.io/address/0x2dc042385a6b1efaeec4816118e704028a733bed#writeContract
https://rinkeby.etherscan.io/address/0xA8132b63AdE6ff0eAFE2b6a8E7E252A2418eCCec#writeContract

#### Code Coverage 

```sh
npx hardhat coverage --testfiles "test/v1_tests.test.js""
```