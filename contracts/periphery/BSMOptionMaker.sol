// Copyright 2022 DeltaDex
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "contracts/periphery/PeripheryController.sol";
import "contracts/libraries/BlackScholesModel.sol";

import "hardhat/console.sol";

/// @title OptionMaker
/// @author DeltaDex
/// @notice This contract contains the main logic for initializing option replication positions
/// @dev Currently code composability is not optimal

contract BSMOptionMaker is PeripheryController {
    using PRBMathSD59x18 for int256;
    using SafeERC20 for IERC20;

    constructor (address _DAI) PeripheryController(msg.sender, _DAI) {}


    function BS_START_REPLICATION(BS.BS_params memory _params, address positionOwner) external onlyCore returns (address pair, uint amountOut) {
        require(checkTokenAddress(_params.tokenA, _params.tokenB), "token pair not listed");

        pair = storageContract.getPair(_params.tokenA, _params.tokenB);

        require(_params.fees > 0, "must deposit fee to pay for replication");
        require(_params.perDay > 0, "must hedge at least once per day");
        require(core.transferIn(positionOwner, DAI, _params.fees), "transfer failed");

        uint ID = storageContract.userIDlength(positionOwner);
        int price = core.getPrice(_params.tokenB, _params.tokenA);

        BS.BlackScholesInput memory input;

        input.S = price;
        input.K = _params.parameters.K;
        input.T = _params.parameters.T;
        input.r = _params.parameters.r;
        input.sigma = _params.parameters.sigma;

        int delta = getDelta(_params.isCall, input);

        if (_params.isCall == true) {
            require(HedgeMath.minimum_Liquidity_Call(_params.amount, delta, price) < _params.tokenA_balance, "insufficient balance - Call");
            require(core.transferIn(positionOwner, _params.tokenA, _params.tokenA_balance), "transfer failed");

            uint amount_tokenA_Out = uint(delta.mul(int(_params.amount)).mul(price));

            _params.tokenA_balance -= amount_tokenA_Out;
            _params.tokenB_balance += core.swapExactInputSingle(_params.tokenA, _params.tokenB, amount_tokenA_Out);

        } else {
            require(HedgeMath.minimum_Liquidity_Put(_params.amount, delta) < _params.tokenB_balance, "insufficient balance - Put");
            require(core.transferIn(positionOwner, _params.tokenB, _params.tokenB_balance), "transfer failed");

            uint amount_tokenB_Out = uint(delta.mul(int(_params.amount)));

            _params.tokenB_balance -= amount_tokenB_Out;
            _params.tokenA_balance += core.swapExactInputSingle(_params.tokenB, _params.tokenA, amount_tokenB_Out);
        }

        BS_Write_Position_to_Mapping(pair, positionOwner, ID, _params);

        return (pair, amountOut);
    }


    // @dev internal function that writes params to mapping
    function BS_Write_Position_to_Mapping(
            address pair, 
            address positionOwner, 
            uint ID, 
            BS.BS_params memory _params) 
        internal returns (bool) {

        _params.expiry = uint(HedgeMath.convertYeartoSeconds(_params.parameters.T)) + block.timestamp;
        _params.hedgeFee = uint(HedgeMath.calculatePerHedgeFee(_params.parameters.T, int(_params.fees), int(_params.perDay)));
        _params.lastHedgeTimeStamp = block.timestamp;

        require(storageContract.addInitialAmounts(pair, positionOwner, ID, _params.tokenA_balance, _params.tokenB_balance), "ST1");
        require(storageContract.write_BS_Options(pair, positionOwner, ID, _params), "ST2");
        require(storageContract.addPairtoUserPositions(positionOwner, pair), "ST3");
        require(storageContract.addPairUser(positionOwner, pair), "ST4");

        return true;
    }


    function checkTokenAddress(address tokenA, address tokenB) internal view returns (bool) {
        if (storageContract.getPair(tokenA, tokenB) != address(0)) {
            return true;
        } else {
            return false;
        }
    }


    // @dev get delta of call if isCall is true, else get delta of put
    function getDelta(bool isCall, BS.BlackScholesInput memory input) internal pure returns (int delta) {
        if (isCall) {
            delta = BS.delta_BS_CALL(input).abs();
        } else {
            delta = BS.delta_BS_PUT(input).abs();
        }
        return delta;
    }
}
