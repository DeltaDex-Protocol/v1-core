/** @type import('hardhat/config').HardhatUserConfig */
require("hardhat-deploy");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("hardhat-abi-exporter");
require("solidity-docgen");
require("solidity-coverage");
require("@nomiclabs/hardhat-etherscan");
require('solidity-coverage')

require('dotenv').config();

module.exports = {
  networks: {
    hardhat: {
      forking: {
        url: `https://rpc.ankr.com/polygon_mumbai`,
      },
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [
        `${process.env.RINKEBY_PRIVATE_KEY_1}`,
        `${process.env.RINKEBY_PRIVATE_KEY_2}`,
        `${process.env.RINKEBY_PRIVATE_KEY_3}`,
      ],
      gasLimit: 25 * 10 ** 6,
    },
    mumbai: {
      url: `https://rpc.ankr.com/polygon_mumbai`,
      accounts: [
        `${process.env.RINKEBY_PRIVATE_KEY_1}`,
        `${process.env.RINKEBY_PRIVATE_KEY_2}`,
        `${process.env.RINKEBY_PRIVATE_KEY_3}`,
      ],
      gasLimit: 25 * 10 ** 6,
    },
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  abiExporter: {
    path: "./data/abi",
    runOnCompile: true,
    clear: true,
    flat: true,
    only: [":ERC20$"],
    spacing: 2,
    format: "minimal",
  },
  etherscan: {
    apiKey: {
      rinkeby: `${process.env.ETHERSCAN_KEY}`,
    },
  },
};