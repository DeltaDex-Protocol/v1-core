// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

 import {SafeERC20} from "./dependencies/openzeppelin/SafeERC20.sol";
 import "contracts/dependencies/openzeppelin/IERC20.sol";

// @dev libraries
import "./libraries/BlackScholesModel.sol";
import "./libraries/HedgeMath.sol"; 

import "contracts/hedging/UniswapV3Swapper.sol";

import "hardhat/console.sol";

contract OptionHedger is V3Swapper {
    using PRBMathSD59x18 for int256;
    using SafeERC20 for IERC20;

    address public DAI = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;

    int public maxSlippage = 1e18;

    // @dev this could be a library function 
    // @dev Check if realized slippage is < 1%
    function checkSlippageAmount(int amountIn, int price, int amountOut) internal view returns (bool) {
        int amountOutOptimal = amountIn.mul(price);
        
        // maxSlippage= abs(trueAmountOut / amountOutOptimal - 1)
        int realizedSlippage = (amountOut.div(amountOutOptimal) - 1e18).abs();

        console.log("realized slippage:");
        console.logInt(realizedSlippage);

        require(realizedSlippage <= maxSlippage, "slippage too high");

        return true;
    }
        
    /// Black Scholes Model
    function BSgetHedgeAvailability(address pair,address user, uint ID) public view returns (bool isHedgeable) {
        // @dev calculate interval in seconds between hedges 
        (uint perDay, uint lastHedgeTimeStamp) = storageContract.BSgetHedgeAvailabilityParams(pair,user,ID);
        // @dev calculate interval in seconds between hedges 
        uint interval = HedgeMath.getTimeStampInterval(perDay);
        // @dev calculate time in seconds since last hedge
        uint current_interval = block.timestamp - lastHedgeTimeStamp;

        if (current_interval >= interval) {
            isHedgeable = true;
        } else {
            isHedgeable = false;
        }
    }

    // @dev get delta of call if isCall is true, else get delta of put
    function BSgetDelta(int price, address pair, address user, uint ID) internal view returns (int delta) {
        // @dev create in memory MertonInput struct as input 
        BS.BlackScholesInput memory input;

        bool isCall;
        input.S = price;

        (input.K, input.T, input.r, input.sigma, isCall) = storageContract.BS_getDeltaParams(pair, user, ID);

        if(isCall) {
            delta = BS.delta_BS_CALL(input);
        }
        else {
            delta = BS.delta_BS_PUT(input);
        }
        return delta;
    }

    // @dev User 2 can read params, recalculate delta, and hedge the position 
    // @dev needs to be tested with manual input of delta
    function BS_HEDGE(address pair, address user, uint ID) public nonReentrant returns (uint payment) {
        bool isHedgeable = BSgetHedgeAvailability(pair,user,ID);

        require(isHedgeable==true, "Can't hedge option yet");

        storageContract.BS_Options_updateTimeStamp(pair, user, ID, block.timestamp);
        
        (address tokenA, address tokenB) = storageContract.BS_tokenAddr(pair,user,ID);

        int price = int(getPrice(tokenB,tokenA));

        // @dev get previous delta
        int previousDelta = HedgeMath.calculatePreviousDelta(storageContract.BS_Options_tokenB_balance(pair, user, ID), storageContract.BS_Options_amount(pair, user, ID));

        // @dev update T parameter. What if block.timestamp > expiry i.e. expired contract? (add require)
        int newTparam = HedgeMath.convertSecondstoYear(storageContract.BS_Options_expiry(pair, user, ID) - block.timestamp);

        // @dev update T in mapping 
        storageContract.BS_Options_updateT(pair, user, ID, newTparam);

        // @dev calculate new delta
        int delta = BSgetDelta(price, pair, user, ID);

        // @dev calculate delta of Delta
        int dDelta = delta - previousDelta;

        // @dev if delta is positive
        if (dDelta > 0) {
            // buy amount dDelta (change in delta * price * amount of contracts = amount of tokenA to sell)
            uint amount_tokenA_Out = uint(dDelta.mul(price).mul(int(storageContract.BS_Options_getAmount(pair, user, ID))));

            require(amount_tokenA_Out<storageContract.BS_Options_getTokenA_bal(pair, user, ID), "Not enough balance to hedge, 108");

            // swapping
            uint amountOut = _swapExactInputSingle(tokenA, tokenB, amount_tokenA_Out);

            // there is a require in checkSlippageAmount
            require(checkSlippageAmount(int(amount_tokenA_Out), price, int(amountOut)), "checkSlippageAmount failed");

            // @dev update tokenA balance, only then do swap
            storageContract.BS_Options_subA_addB(pair, user, ID, amount_tokenA_Out, amountOut);

        } else {
            // sell amount dDelta
            // essentially, if the change in delta if negative, dDelta is amount of tokenB to sell
            uint amount_tokenB_Out = uint(dDelta.abs().div(price).mul(int(storageContract.BS_Options_getAmount(pair, user, ID))));

            require(amount_tokenB_Out < storageContract.BS_Options_getTokenB_bal(pair,user,ID), "Not enough balance to hedge, 127");

            // swapping
            uint amountOut = _swapExactInputSingle(tokenB, tokenA, amount_tokenB_Out);

            // there is a require in checkSlippageAmount
            require(checkSlippageAmount(int(amount_tokenB_Out), price, int(amountOut)), "checkSlippageAmount failed");

            // @dev update tokenB balance, only then do swap
            storageContract.BS_Options_subB_addA(pair,user,ID,amount_tokenB_Out, amountOut);
        }

        // @dev get amount to send to user 2 (there may be a way to gas optimize this..)
        payment = storageContract.BS_Options_hedgeFee(pair,user,ID);
        storageContract.BS_Options_updateHedgeFee(pair,user,ID,payment);

        // make payment 
        IERC20(DAI).safeTransfer(msg.sender, payment);
        return payment;
    }
}