// Copyright 2022 DeltaDex
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {SafeERC20} from "./dependencies/openzeppelin/SafeERC20.sol";
import "contracts/dependencies/openzeppelin/IERC20.sol";

import "contracts/libraries/BlackScholesModel.sol";
import "contracts/libraries/HedgeMath.sol";
import "contracts/UniswapV3Swapper.sol";

import "hardhat/console.sol";

contract OptionHedger is V3Swapper {
    using PRBMathSD59x18 for int256;
    using SafeERC20 for IERC20;

    int public maxSlippage = 1e18;

    // @dev User 2 can read params, recalculate delta, and hedge the position
    function BS_HEDGE(address pair, address user, uint ID) public nonReentrant returns (uint payment) {
        bool isHedgeable = BSgetHedgeAvailability(pair, user, ID);

        require(isHedgeable == true, "Can't hedge option yet");

        (address tokenA, address tokenB) = storageContract.BS_tokenAddr(pair, user, ID);

        int price = getPrice(tokenB, tokenA);

        int previousDelta = HedgeMath.calculatePreviousDelta(
            storageContract.BS_Options_tokenB_balance(pair, user, ID), 
            storageContract.BS_Options_contractAmount(pair, user, ID));

        int newTparam = HedgeMath.convertSecondstoYear(
            storageContract.BS_Options_expiry(pair, user, ID) - block.timestamp);

        int delta = BSgetDelta(price, pair, user, ID);

        int dDelta = delta - previousDelta;

        // @dev if delta is positive
        if (dDelta > 0) {
            uint amount_tokenA_Out = uint(dDelta.mul(price).mul(int(storageContract.BS_Options_contractAmount(pair, user, ID))));

            require(amount_tokenA_Out < storageContract.BS_Options_tokenA_balance(pair, user, ID), "BAL");

            uint amountOut = _swapExactInputSingle(tokenA, tokenB, amount_tokenA_Out);

            require(HedgeMath.checkSlippageAmount(int(amount_tokenA_Out), int(amountOut), price, maxSlippage), "S");

            storageContract.BS_Options_subA_addB(pair, user, ID, amount_tokenA_Out, amountOut);

        } else {
            uint amount_tokenB_Out = uint(dDelta.abs().div(price).mul(int(storageContract.BS_Options_contractAmount(pair, user, ID))));

            require(amount_tokenB_Out < storageContract.BS_Options_tokenB_balance(pair, user, ID), "BAL");

            uint amountOut = _swapExactInputSingle(tokenB, tokenA, amount_tokenB_Out);

            require(HedgeMath.checkSlippageAmount(int(amount_tokenB_Out), int(amountOut), price, maxSlippage), "S");

            storageContract.BS_Options_subB_addA(pair, user, ID, amount_tokenB_Out, amountOut);
        }

        storageContract.BS_Options_updateTimeStamp(pair, user, ID, block.timestamp);
        storageContract.BS_Options_updateT(pair, user, ID, newTparam);

        payment = storageContract.BS_Options_hedgeFee(pair, user, ID);
        storageContract.BS_Options_updateHedgeFee(pair, user, ID, payment);

        IERC20(DAI).safeTransfer(msg.sender, payment);
        return payment;
    }


    /// @dev Check if the option is hedgeable
    function BSgetHedgeAvailability(address pair, address user, uint ID) public view returns (bool isHedgeable) {
        (uint perDay, uint lastHedgeTimeStamp) = storageContract.BSgetHedgeAvailabilityParams(pair, user, ID);

        uint interval = HedgeMath.getTimeStampInterval(perDay);
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

        if (isCall) {
            delta = BS.delta_BS_CALL(input);
        } else {
            delta = BS.delta_BS_PUT(input);
        }
        return delta;
    }
}
