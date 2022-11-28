// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// @dev libraries
import "contracts/libraries/BlackScholesModel.sol";
import "contracts/libraries/JumpDiffusionModel.sol";

import "./PairStorage.sol";

contract OptionStorage is PairStorage {

    // @dev BS Calls & Puts 
    // address TokenPair => address user => positinoID => position 
    mapping(address => mapping(address => mapping(uint => BS.BS_params))) public BS_Options;

    // @dev JDM Calls & Puts
    // address TokenPair => address user => positinoID => position 
    mapping(address => mapping(address => mapping(uint => JDM.JDM_params))) public JDM_Options;


    // Black Scholes Merton Model
    function write_BS_Options(address pair, address user, uint ID, BS.BS_params memory _params) public onlyTrusted {
        BS_Options[pair][user][ID] = _params;
    }

    function BS_edit_params(address pair, address user,uint ID, BS.BS_params memory _params) public onlyTrusted {
        // @dev nested struct params
        BS_Options[pair][user][ID].parameters.K = _params.parameters.K;
        BS_Options[pair][user][ID].parameters.T = _params.parameters.T;
        BS_Options[pair][user][ID].parameters.r = _params.parameters.r;
        BS_Options[pair][user][ID].parameters.sigma = _params.parameters.sigma;

        BS_Options[pair][msg.sender][ID].perDay = _params.perDay;
    }

    function BS_addFee(address pair,uint ID, uint feeAmount) public onlyTrusted {
        BS_Options[pair][tx.origin][ID].fees += feeAmount;
    }

    function BSgetHedgeAvailabilityParams(address pair, address user, uint ID) public view returns (uint perDay,uint lastHedgeTimeStamp) {
        perDay = BS_Options[pair][user][ID].perDay;
        lastHedgeTimeStamp = BS_Options[pair][user][ID].lastHedgeTimeStamp;

        return (perDay, lastHedgeTimeStamp);
    }

    function BS_getDeltaParams(address pair, address user, uint ID) public view returns (int K, int T, int r, int sigma, bool isCall) {
        K = BS_Options[pair][user][ID].parameters.K;
        T = BS_Options[pair][user][ID].parameters.T;
        r = BS_Options[pair][user][ID].parameters.r;
        sigma = BS_Options[pair][user][ID].parameters.sigma;
        isCall = BS_Options[pair][user][ID].isCall;
        return (K,T,r,sigma,isCall);
    }

    function BS_PositionParams(address pair, address user, uint ID) public view returns (uint amount, uint expiry, uint fees, uint perDay, uint hedgeFee, uint lastHedgeTimeStamp){
        amount = BS_Options[pair][user][ID].amount;
        expiry= BS_Options[pair][user][ID].expiry;
        fees = BS_Options[pair][user][ID].fees;
        perDay = BS_Options[pair][user][ID].perDay;
        hedgeFee= BS_Options[pair][user][ID].hedgeFee;
        lastHedgeTimeStamp = BS_Options[pair][user][ID].lastHedgeTimeStamp;
        return (amount, expiry, fees, perDay, hedgeFee, lastHedgeTimeStamp);
    }

    function BS_tokenAddr(address pair, address user, uint ID) public view returns (address tokenA, address tokenB) {
        tokenA = BS_Options[pair][user][ID].tokenA;
        tokenB = BS_Options[pair][user][ID].tokenB;
        return (tokenA, tokenB);
    }

    function BS_Options_tokenB_balance(address pair, address user, uint ID) public view returns (uint tokenB_balance) {
        tokenB_balance = BS_Options[pair][user][ID].tokenB_balance;
        return tokenB_balance;
    }

    function BS_Options_amount(address pair, address user, uint ID) public view returns (uint amount) {
        amount = BS_Options[pair][user][ID].amount;
        return amount;
    }
    
    function BS_Options_expiry(address pair, address user, uint ID) public view returns (uint expiry) {
        expiry = BS_Options[pair][user][ID].expiry;
        return expiry;
    }

    function BS_Options_updateT(address pair, address user, uint ID, int newTparam) public onlyTrusted {
        BS_Options[pair][user][ID].parameters.T = newTparam;
    }

    function BS_Options_updateTimeStamp(address pair, address user, uint ID, uint lastHedgeTimeStamp) public onlyTrusted {
        BS_Options[pair][user][ID].lastHedgeTimeStamp = lastHedgeTimeStamp;
    }

    function BS_Options_getAmount(address pair, address user, uint ID) public view returns (uint) {
        return BS_Options[pair][user][ID].amount;
    }

    function BS_Options_getTokenA_bal(address pair, address user, uint ID) public view returns (uint) {
        return BS_Options[pair][user][ID].tokenA_balance;
    }

    function BS_Options_getTokenB_bal(address pair, address user, uint ID) public view returns (uint) {
        return BS_Options[pair][user][ID].tokenB_balance;
    }

    function BS_Options_hedgeFee(address pair, address user, uint ID) public view returns (uint) {
        return BS_Options[pair][user][ID].hedgeFee;
    }

    function BS_Options_updateHedgeFee(address pair, address user, uint ID, uint subFee) public onlyTrusted {
        BS_Options[pair][user][ID].fees -= subFee;
    }

    function BS_Options_subA_addB(address pair, address user, uint ID, uint subA, uint addB) public onlyTrusted {
        BS_Options[pair][user][ID].tokenA_balance -= subA;
        BS_Options[pair][user][ID].tokenB_balance += addB;
    }

    function BS_Options_subB_addA(address pair, address user, uint ID, uint subB, uint addA) public onlyTrusted {
        BS_Options[pair][user][ID].tokenB_balance -= subB;
        BS_Options[pair][user][ID].tokenA_balance += addA;
    }

    function BS_getWithdrawParams(address pair, address user,uint ID) public view returns (address, address, uint, uint, uint) {
        address tokenA = BS_Options[pair][user][ID].tokenA;
        address tokenB = BS_Options[pair][user][ID].tokenB;

        uint tokenA_balance = BS_Options[pair][user][ID].tokenA_balance;
        uint tokenB_balance = BS_Options[pair][user][ID].tokenB_balance;
        uint feeBalance = BS_Options[pair][user][ID].fees;

        return (tokenA,tokenB,tokenA_balance,tokenB_balance,feeBalance);
    }

    function BS_withdraw(address pair, address user,uint ID) public onlyTrusted {
        BS_Options[pair][user][ID].tokenA_balance = 0;
        BS_Options[pair][user][ID].tokenB_balance = 0;
        BS_Options[pair][user][ID].fees = 0;
    }

    function BS_hedge(address pair, address user,uint ID, uint tokenA_balance, uint tokenB_balance, uint fees) public onlyTrusted {
        BS_Options[pair][user][ID].tokenA_balance = tokenA_balance;
        BS_Options[pair][user][ID].tokenB_balance = tokenB_balance;
        BS_Options[pair][user][ID].fees = fees;
    }

    // Jump Diffusion Model
    function write_JDM_Options(address pair, address user, uint ID, JDM.JDM_params memory _params) public onlyTrusted {
        JDM_Options[pair][user][ID] = _params;
    }

    function JDM_edit_params(address pair, address user,uint ID, JDM.JDM_params memory _params) public onlyTrusted {
        // @dev nested struct params
        JDM_Options[pair][user][ID].parameters.K = _params.parameters.K;
        JDM_Options[pair][user][ID].parameters.T = _params.parameters.T;
        JDM_Options[pair][user][ID].parameters.r = _params.parameters.r;
        JDM_Options[pair][user][ID].parameters.sigma = _params.parameters.sigma;

        JDM_Options[pair][msg.sender][ID].perDay = _params.perDay;
    }

    function JDM_addFee(address pair,uint ID, uint feeAmount) public onlyTrusted {
        JDM_Options[pair][tx.origin][ID].fees += feeAmount;
    }

    function JDMgetHedgeAvailabilityParams(address pair, address user, uint ID) public view returns (uint perDay,uint lastHedgeTimeStamp) {
        perDay = JDM_Options[pair][user][ID].perDay;
        lastHedgeTimeStamp = JDM_Options[pair][user][ID].lastHedgeTimeStamp;

        return (perDay, lastHedgeTimeStamp);
    }

    function JDM_getDeltaParams(address pair, address user, uint ID) public view returns (int K, int T, int r, int sigma, bool isCall) {
        K = JDM_Options[pair][user][ID].parameters.K;
        T = JDM_Options[pair][user][ID].parameters.T;
        r = JDM_Options[pair][user][ID].parameters.r;
        sigma = JDM_Options[pair][user][ID].parameters.sigma;
        isCall = JDM_Options[pair][user][ID].isCall;
        return (K,T,r,sigma,isCall);
    }


    function JDM_PositionParams(address pair, address user, uint ID) public view returns (uint amount, uint expiry, uint fees, uint perDay, uint hedgeFee, uint lastHedgeTimeStamp){
        amount = JDM_Options[pair][user][ID].amount;
        expiry= JDM_Options[pair][user][ID].expiry;
        fees = JDM_Options[pair][user][ID].fees;
        perDay = JDM_Options[pair][user][ID].perDay;
        hedgeFee= JDM_Options[pair][user][ID].hedgeFee;
        lastHedgeTimeStamp = JDM_Options[pair][user][ID].lastHedgeTimeStamp;
        return (amount, expiry, fees, perDay, hedgeFee, lastHedgeTimeStamp);
    }


    function JDM_tokenAddr(address pair, address user, uint ID) public view returns (address tokenA, address tokenB) {
        tokenA = JDM_Options[pair][user][ID].tokenA;
        tokenB = JDM_Options[pair][user][ID].tokenB;
        return (tokenA, tokenB);
    }

    function JDM_Options_tokenB_balance(address pair, address user, uint ID) public view returns (uint tokenB_balance) {
        tokenB_balance = JDM_Options[pair][user][ID].tokenB_balance;
        return tokenB_balance;
    }

    function JDM_Options_amount(address pair, address user, uint ID) public view returns (uint amount) {
        amount = JDM_Options[pair][user][ID].amount;
        return amount;
    }
    
    function JDM_Options_expiry(address pair, address user, uint ID) public view returns (uint expiry) {
        expiry = JDM_Options[pair][user][ID].expiry;
        return expiry;
    }

    function JDM_Options_updateT(address pair, address user, uint ID, int newTparam) public onlyTrusted {
        JDM_Options[pair][user][ID].parameters.T = newTparam;
    }

    function JDM_Options_updateTimeStamp(address pair, address user, uint ID, uint lastHedgeTimeStamp) public onlyTrusted {
        JDM_Options[pair][user][ID].lastHedgeTimeStamp = lastHedgeTimeStamp;
    }

    function JDM_Options_getAmount(address pair, address user, uint ID) public view returns (uint) {
        return JDM_Options[pair][user][ID].amount;
    }

    function JDM_Options_getTokenA_bal(address pair, address user, uint ID) public view returns (uint) {
        return JDM_Options[pair][user][ID].tokenA_balance;
    }

    function JDM_Options_getTokenB_bal(address pair, address user, uint ID) public view returns (uint) {
        return JDM_Options[pair][user][ID].tokenB_balance;
    }

    function JDM_Options_hedgeFee(address pair, address user, uint ID) public view returns (uint) {
        return JDM_Options[pair][user][ID].hedgeFee;
    }

    function JDM_Options_updateHedgeFee(address pair, address user, uint ID, uint subFee) public onlyTrusted {
        JDM_Options[pair][user][ID].fees -= subFee;
    }

    function JDM_Options_subA_addB(address pair, address user, uint ID, uint subA, uint addB) public onlyTrusted {
        JDM_Options[pair][user][ID].tokenA_balance -= subA;
        JDM_Options[pair][user][ID].tokenB_balance += addB;
    }

    function JDM_Options_subB_addA(address pair, address user, uint ID, uint subB, uint addA) public onlyTrusted {
        JDM_Options[pair][user][ID].tokenB_balance -= subB;
        JDM_Options[pair][user][ID].tokenA_balance += addA;
    }

    function JDM_getWithdrawParams(address pair, address user,uint ID) public view returns (address, address, uint, uint, uint) {
        address tokenA = JDM_Options[pair][user][ID].tokenA;
        address tokenB = JDM_Options[pair][user][ID].tokenB;

        uint tokenA_balance = JDM_Options[pair][user][ID].tokenA_balance;
        uint tokenB_balance = JDM_Options[pair][user][ID].tokenB_balance;
        uint feeBalance = JDM_Options[pair][user][ID].fees;

        return (tokenA,tokenB,tokenA_balance,tokenB_balance,feeBalance);
    }

    function JDM_withdraw(address pair, address user,uint ID) public onlyTrusted {
        JDM_Options[pair][user][ID].tokenA_balance = 0;
        JDM_Options[pair][user][ID].tokenB_balance = 0;
        JDM_Options[pair][user][ID].fees = 0;
    }

    function JDM_hedge(address pair, address user,uint ID, uint tokenA_balance, uint tokenB_balance, uint fees) public onlyTrusted {
        JDM_Options[pair][user][ID].tokenA_balance = tokenA_balance;
        JDM_Options[pair][user][ID].tokenB_balance = tokenB_balance;
        JDM_Options[pair][user][ID].fees = fees;
    }
}