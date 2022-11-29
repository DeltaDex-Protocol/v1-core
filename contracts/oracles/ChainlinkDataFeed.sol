// Copyright 2022 DeltaDex
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../dependencies/chainlink/AggregatorV3Interface.sol";

/// @title Chainlink Data Feed
/// @author DeltaDex
/// @notice Gets price of token from Chainlink oracle
/// @dev Yet to be integrated to check against v3 twap

contract ChainlinkPriceFeed_ETHBTC {

    AggregatorV3Interface internal ETHprice;
    AggregatorV3Interface internal BTCprice;

    constructor() {
        ETHprice = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        BTCprice = AggregatorV3Interface(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c);
    }

    function PriceETH() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = ETHprice.latestRoundData();
        return price;
    }

    function PriceBTC() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = BTCprice.latestRoundData();
        return price;
    }
}