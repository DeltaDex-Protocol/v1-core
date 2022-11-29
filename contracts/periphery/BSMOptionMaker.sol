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

    constructor () PeripheryController(msg.sender) {}

    // @dev get delta of call if isCall is true, else get delta of put
    function getDelta(bool isCall, BS.BlackScholesInput memory input) internal pure returns (int delta) {
        if(isCall) {
            delta = BS.delta_BS_CALL(input).abs();
        }
        else {
            delta = BS.delta_BS_PUT(input).abs();
        }
        return delta;
    }

    function BS_START_REPLICATION(BS.BS_params memory _params, address positionOwner) public onlyCore returns (address pair,uint amountOut) {
        require(checkTokenAddress(_params.tokenB), "token not listed");

        // @dev get address of pair
        pair = storageContract.getPair(_params.tokenA, _params.tokenB);

        // @dev if pair address doesn't exist, create address of pair
        if (pair == address(0)) {
            pair = core.createPair(_params.tokenA, _params.tokenB);
        }

        require(_params.fees > 0, "must deposit fee to pay for replication");
        require(_params.perDay > 0, "must hedge at least once per day");

        // @dev transfer fee amount in DAI
        require(core.transferIn(positionOwner, DAI, _params.fees), "transfer failed");

        // @dev get # of option positions of user
        uint ID = storageContract.userIDlength(positionOwner);

        // @dev get price of tokenB in terms of tokenA
        int price = core.getPrice(_params.tokenB,_params.tokenA);

        // @dev create in memory MertonInput struct as input 
        BS.BlackScholesInput memory input;

        // @dev connect user input _params to MertonInput struct
        input.S = price;
        input.K = _params.parameters.K;
        input.T = _params.parameters.T;
        input.r = _params.parameters.r;
        input.sigma = _params.parameters.sigma;

        int delta = getDelta(_params.isCall, input);

        // @dev if call => user sends token0, if put => user sends token1
        if (_params.isCall == true) {

            // @dev check minimum required liquidity to replicate amount of contracts
            require(HedgeMath.minimum_Liquidity_Call(_params.amount,delta,price) < _params.tokenA_balance, "insufficient balance - Call");

            // @dev amount tokenB from user to transfer into this contract
            // @dev transfer uint _params.tokenA_balance to DeltaDex smart contract
            require(core.transferIn(positionOwner, _params.tokenA,_params.tokenA_balance), "transfer failed");

            // @dev calculate amount tokenA to send to Uniswap v3 in exchange for tokenB
            uint amount_tokenA_Out = uint(delta.mul(int(_params.amount)).mul(price));

            // @dev update tokenA balance to be written to struct
            _params.tokenA_balance -= amount_tokenA_Out;
            
            // @dev swap tokenA for tokenB in uniswap v3 => amountOut is amount of received tokenB (ether)
            _params.tokenB_balance += core.swapExactInputSingle(_params.tokenA, _params.tokenB, amount_tokenA_Out);

        } else {

            // @dev check minimum required liquidity to replicate amount of contracts
            require(HedgeMath.minimum_Liquidity_Put(_params.amount,delta) < _params.tokenB_balance, "insufficient balance - Put");

            // @dev amount tokenB from user to transfer into this contract
            // @dev transfer uint _params.tokenA_balance to DeltaDex smart contract
            require(core.transferIn(positionOwner, _params.tokenB,_params.tokenB_balance), "transfer failed");

            // @dev calculate amount tokenA to send to Uniswap v3 in exchange for tokenB
            uint amount_tokenB_Out = uint(delta.mul(int(_params.amount)));

            // @dev update tokenA balance to be written to struct
            _params.tokenB_balance -= amount_tokenB_Out;

            // @dev swap tokenA for tokenB in uniswap v3 => amountOut is amount of received tokenB (ether)
            _params.tokenA_balance += core.swapExactInputSingle(_params.tokenB, _params.tokenA, amount_tokenB_Out);
        }

        BS_Write_Position_to_Mapping(pair, positionOwner, ID, _params);

        return (pair,amountOut);
    }

    // @dev internal function that writes params to mapping
    function BS_Write_Position_to_Mapping(address pair, address positionOwner, uint ID, BS.BS_params memory _params) internal returns (bool) {
        _params.expiry = uint(HedgeMath.convertYeartoSeconds(_params.parameters.T)) + block.timestamp;
        _params.hedgeFee = uint(HedgeMath.calculatePerHedgeFee(_params.parameters.T,int(_params.fees),int(_params.perDay)));
        _params.lastHedgeTimeStamp = block.timestamp;

        // @dev write params in storage contract
        storageContract.write_BS_Options(pair, positionOwner, ID, _params);

        // @dev push ID to Positions array
        storageContract.addPairtoUserPositions(pair);

        // @dev push address user to PairUsers array
        storageContract.addPairUser(pair);

        return true;
    }


}