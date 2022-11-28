// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "contracts/dependencies/prb-math/PRBMathSD59x18.sol";
import "contracts/oracles/UniswapV3Oracle.sol";
import "contracts/dependencies/openzeppelin/ERC20/IERC20Metadata.sol";
import "contracts/libraries/HedgeMath.sol";

import "hardhat/console.sol";

contract PriceConverter is UniswapV3twap {

    using PRBMathSD59x18 for int256;

    function getPrice1e18(address token0, address token1) public view returns (uint, uint) {
        // t0 decimals
        // uint t0decimals = IERC20Metadata(token0).decimals();
        uint t0decimals = 18;
        console.log("t0 decimals");
        console.logUint(t0decimals);
        // t1 decimals
        // uint t1decimals = IERC20Metadata(token1).decimals();
        uint t1decimals = 6;
        console.log("t1 decimals");
        console.logUint(t1decimals);
        // value uniswap oracle

        // int value = getPrice(token0, token1);
        int value = 1579453860;
        console.log("val");
        console.logInt(value);
        // scaled value to 1e18 base
        uint scaledVal =  HedgeMath.scaleTo(t1decimals, 18, uint(value));
        console.log("scaledVal");
        console.logUint(scaledVal);

        // token 1 in terms of token0
        uint res = uint(int(1e18).div(int(scaledVal)));
        console.log("res");
        console.logUint(res);

        // convert res back to scaledVal
        uint resConvert = uint(int(1e18).div(int(res)));
        console.log("resConvert");
        console.logUint(resConvert);

        // make sure this is equal to 1
        require(resConvert/scaledVal == 1, "error");
        // ==> set resConvert to scaledVal 

        // return amount of token0 to buy 0.5 token1
        uint amount_t0 = HedgeMath.scaleTo(t0decimals, 18, uint(int(res).div(2e18)));
        console.log("amount_t0");
        console.logUint(amount_t0);

        // return amount of token1 to buy 0.5 token0
        uint amount_t1 = HedgeMath.scaleTo(t0decimals, t0decimals, uint(int(value).div(2e18)));
        console.log("amount_t1");
        console.logUint(amount_t1);

        return (amount_t0, amount_t1);
    }
    


}