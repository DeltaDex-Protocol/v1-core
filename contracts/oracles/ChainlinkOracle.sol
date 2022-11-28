// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "../dependencies/chainlink/AggregatorV3Interface.sol";

/// @title Chainlink Data Feed
/// @author DeltaDex
/// @notice Gets price of token from Chainlink oracle
/// @dev Yet to be integrated to check against v3 twap

contract ChainlinkPriceFeed {

    address internal WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal WETH_DATAFEED = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

    address internal WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address internal WBTC_DATAFEED = 0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c;
    
    address internal UNI = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
    address internal UNI_DATAFEED = 0x553303d460EE0afB37EdFf9bE42922D8FF63220e;

    address internal LINK = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
    address internal LINK_DATAFEED = 0x2c1d072e956AFFC0D435Cb7AC38EF18d24d9127c;

    address internal AAVE = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
    address internal AAVE_DATAFEED = 0x6Df09E975c830ECae5bd4eD9d90f3A95a4f88012;

    address internal COMP = 0xc00e94Cb662C3520282E6f5717214004A7f26888;
    address internal COMP_DATAFEED = 0xdbd020CAeF83eFd542f4De03e3cF0C28A4428bd5;

    address internal USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal USDC_DATAFEED = 0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6;

    address internal USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address internal USDT_DATAFEED = 0x3E7d1eAB13ad0104d2750B8863b489D65364e32D;

    address internal DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address internal DAI_DATAFEED = 0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9;

    // storing address token is not necessary
    struct OracleAddress {
        address token;
        address priceFeed;
        string name;
    }

    // address ERC20 token => Chainlink Datafeed address
    mapping(address => OracleAddress) public DataAddresses;

    // init addresses in mapping
    function initAddresses() public {

        DataAddresses[WETH].token = WETH;
        DataAddresses[WETH].priceFeed = WETH_DATAFEED;
        DataAddresses[WETH].name = "ETH/USD";

        DataAddresses[WBTC].token = WBTC;
        DataAddresses[WBTC].priceFeed = WBTC_DATAFEED;
        DataAddresses[WBTC].name = "BTC/USD";

        DataAddresses[UNI].token = UNI;
        DataAddresses[UNI].priceFeed = UNI_DATAFEED;
        DataAddresses[UNI].name = "UNI/USD";

        DataAddresses[LINK].token = LINK;
        DataAddresses[LINK].priceFeed = LINK_DATAFEED;
        DataAddresses[LINK].name = "LINK/USD";

        DataAddresses[AAVE].token = AAVE;
        DataAddresses[AAVE].priceFeed = AAVE_DATAFEED;
        DataAddresses[AAVE].name = "AAVE/USD";

        DataAddresses[COMP].token = COMP;
        DataAddresses[COMP].priceFeed = COMP_DATAFEED;
        DataAddresses[COMP].name = "COMP/USD";

        DataAddresses[USDC].token = USDC;
        DataAddresses[USDC].priceFeed = USDC_DATAFEED;
        DataAddresses[USDC].name = "USDC/USD";

        DataAddresses[USDT].token = USDT;
        DataAddresses[USDT].priceFeed = USDT_DATAFEED;
        DataAddresses[USDT].name = "USDT/USD";

        DataAddresses[DAI].token = DAI;
        DataAddresses[DAI].priceFeed = DAI_DATAFEED;
        DataAddresses[DAI].name = "DAI/USD";
    }

    // @dev input asset address and get price back from chainlink
    function ChainlinkPrice(address asset) public view returns (int) {
        AggregatorV3Interface Oracle = AggregatorV3Interface(DataAddresses[asset].priceFeed);
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = Oracle.latestRoundData();
        return price;
    }
}