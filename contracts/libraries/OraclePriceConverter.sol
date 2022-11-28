// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// convert price given by oracle to 1e18 base
// should consider if necessary for future versions

library OraclePriceConverter  {

    // uniswaptwap
    // 1057596819
    function UNIto1e18(uint price) public pure returns (int) {
        price *= 1e12;
        return int(price);
    }

    // chainlink
    // 106004000000
    function LINKto1e18(int price) public pure returns (int) {
        price *= 1e10;
        return price;
    }
}
