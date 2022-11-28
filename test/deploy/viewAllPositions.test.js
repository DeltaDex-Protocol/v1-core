const { expect } = require("chai");
const { ethers, network } = require("hardhat");
const { pageAssigner } = require("solidity-docgen/dist/site");

const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const WETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

const MAKER = "0x512F7469BcC83089497506b5df64c6E246B39925";

describe("Deployer", function () {
  it("Should get all positions of user: ", async () => {
    const optionmaker = await ethers.getContractAt("OptionMaker", MAKER);

    let accounts;

    accounts = await ethers.getSigners();

    const positions = await optionmaker.userIDlength(accounts[0].address);

    var value = ethers.BigNumber.from(positions).toString();
    value = parseInt(value);
    console.log("number of positions of user: ", positions);

    // to get all addresses of pairs, we can loop over mapping Positions[user] or call getUserPositions()
    // to get all addresses of pairs that the user has used.
    const pair = await optionmaker.getPair(DAI, WETH);

    function checkIfEmptyPosition(position) {
      if (position["tokenA"] == "0x0000000000000000000000000000000000000000") {
        return true;
      } else {
        return false;
      }
    }

    function onlyUnique(value, index, self) {
      return self.indexOf(value) === index;
    }

    async function allPositions(tokenPair) {
      let users = await optionmaker.getUserAddressesInPair(tokenPair);

      let uniqueUsers = users.filter(onlyUnique);

      console.log(uniqueUsers);
      // let positions = [];
      for (const user of uniqueUsers) {
        // addresses of token pairs that user is a part of
        let tokenPairs = await optionmaker.getUserPositions(user);

        console.log("token pairs", tokenPairs);

        // number of positions in this tokenPair
        let noOfPositionsInPair = tokenPairs.filter(
          (x) => x == tokenPair
        ).length;

        // console.log(noOfPositionsInPair);
        // let noOfPosiitons = optionmaker.userIDlength(user);

        let positions = [];

        for (let i = 0; i < noOfPositionsInPair; i++) {
          let JDM = await optionmaker.JDM_Options(tokenPair, user, i);

          var isEmpty = checkIfEmptyPosition(JDM);
          if (isEmpty == true) {
            // pass
          } else {
            positions.push(JDM);
            // console.log(BS);
          }

          let BS = await optionmaker.BS_Options(tokenPair, user, i);

          var isEmpty = checkIfEmptyPosition(BS);
          if (isEmpty == true) {
            // pass
          } else {
            positions.push(BS);
          }

          let BSC = await optionmaker.BSC_Options(tokenPair, user, i);
          var isEmpty = checkIfEmptyPosition(BSC);
          if (isEmpty == true) {
            // pass
          } else {
            positions.push(BSC);
          }
        }
        console.log(positions);
      }
    }
    // console.log(pair);
    await allPositions(pair);
  });
});
