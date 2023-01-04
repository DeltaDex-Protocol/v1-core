// Copyright 2022 DeltaDex
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "contracts/libraries/BlackScholesModel.sol";

import "./PairStorage.sol";

contract OptionStorage is PairStorage {
    // @dev Initial Token Amounts
    struct InitialTokenAmounts {
        uint tokenA_balance;
        uint tokenB_balance;
        bool isClosed;
    }

    // address TokenPair => address user => positionID => amounts
    mapping(address => mapping(address => mapping(uint => InitialTokenAmounts))) public InitialAmounts;

    // @dev BS Calls & Puts
    // address TokenPair => address user => positionID => position
    mapping(address => mapping(address => mapping(uint => BS.BS_params))) public BS_Options;

    /* WRITE FUNCTIONS */
    function write_BS_Options(
        address pair, 
        address user, 
        uint ID, 
        BS.BS_params memory _params
    ) external onlyTrusted returns (bool) {
        BS_Options[pair][user][ID] = _params;
        return true;
    }

    function addInitialAmounts(
        address pair, 
        address user, 
        uint ID, 
        uint tokenA_balance, 
        uint tokenB_balance
    ) external onlyTrusted returns (bool) {
        InitialAmounts[pair][user][ID].tokenA_balance = tokenA_balance;
        InitialAmounts[pair][user][ID].tokenB_balance = tokenB_balance;
        return true;
    }

    function BS_edit_params(
        address pair, 
        address user, 
        uint ID, 
        BS.BS_params memory _params
    ) external onlyTrusted returns (bool) {
        BS_Options[pair][user][ID].parameters.K = _params.parameters.K;
        BS_Options[pair][user][ID].parameters.T = _params.parameters.T;
        BS_Options[pair][user][ID].parameters.r = _params.parameters.r;
        BS_Options[pair][user][ID].parameters.sigma = _params.parameters.sigma;
        BS_Options[pair][msg.sender][ID].perDay = _params.perDay;
        return true;
    }

    function BS_addFee(
        address pair, 
        address positionOwner, 
        uint ID, uint feeAmount
    ) external onlyTrusted returns (bool) {
        BS_Options[pair][positionOwner][ID].fees += feeAmount;
        return true;
    }

    function BS_Options_updateT(address pair, address user, uint ID, int newTparam) external onlyTrusted {
        BS_Options[pair][user][ID].parameters.T = newTparam;
    }

    function BS_Options_updateTimeStamp(
        address pair, 
        address user, 
        uint ID, 
        uint lastHedgeTimeStamp) external onlyTrusted {
        BS_Options[pair][user][ID].lastHedgeTimeStamp = lastHedgeTimeStamp;
    }

    function BS_Options_updateHedgeFee(
        address pair, 
        address user, 
        uint ID, 
        uint subFee
    ) external onlyTrusted {
        BS_Options[pair][user][ID].fees -= subFee;
    }

    function BS_Options_subA_addB(
        address pair, 
        address user, 
        uint ID, 
        uint subA, 
        uint addB
    ) external onlyTrusted {
        BS_Options[pair][user][ID].tokenA_balance -= subA;
        BS_Options[pair][user][ID].tokenB_balance += addB;
    }

    function BS_Options_subB_addA(
        address pair, 
        address user, 
        uint ID, 
        uint subB, 
        uint addA
    ) external onlyTrusted {
        BS_Options[pair][user][ID].tokenB_balance -= subB;
        BS_Options[pair][user][ID].tokenA_balance += addA;
    }

    function BS_withdraw(address pair, address user, uint ID) external onlyTrusted returns (bool) {
        BS_Options[pair][user][ID].tokenA_balance = 0;
        BS_Options[pair][user][ID].tokenB_balance = 0;
        BS_Options[pair][user][ID].fees = 0;
        InitialAmounts[pair][user][ID].isClosed = true;
        return true;
    }

    /* VIEW FUNCTIONS */
    function getPositionStatus(address pair, address user, uint ID) external view returns (bool) {
        return InitialAmounts[pair][user][ID].isClosed;
    }

    function BSgetHedgeAvailabilityParams(
        address pair, 
        address user, 
        uint ID
    ) external view returns (
        uint perDay, 
        uint lastHedgeTimeStamp
    ) {
        perDay = BS_Options[pair][user][ID].perDay;
        lastHedgeTimeStamp = BS_Options[pair][user][ID].lastHedgeTimeStamp;
        return (perDay, lastHedgeTimeStamp);
    }

    function BS_allPositionParams(
        address pair, 
        address user, 
        uint ID
    ) external view returns (BS.BS_params memory) {
        return BS_Options[pair][user][ID];
    }

    function getInitialBalance(
        address pair, 
        address user, 
        uint ID
    ) external view returns (
        uint tokenA_balance, 
        uint tokenB_balance
    ) {
        tokenA_balance = InitialAmounts[pair][user][ID].tokenA_balance;
        tokenB_balance = InitialAmounts[pair][user][ID].tokenB_balance;
        return (tokenA_balance, tokenB_balance);
    }

    function BS_getDeltaParams(
        address pair, 
        address user, 
        uint ID
    ) external view returns (
        int K, 
        int T, 
        int r, 
        int sigma, 
        bool isCall
    ) {
        K = BS_Options[pair][user][ID].parameters.K;
        T = BS_Options[pair][user][ID].parameters.T;
        r = BS_Options[pair][user][ID].parameters.r;
        sigma = BS_Options[pair][user][ID].parameters.sigma;
        isCall = BS_Options[pair][user][ID].isCall;
        return (K , T, r, sigma, isCall);
    }

    function BS_PositionParams(
        address pair, 
        address user, 
        uint ID
    ) external view returns (
        uint amount, 
        uint expiry,
        uint fees, 
        uint perDay, 
        uint hedgeFee, 
        uint lastHedgeTimeStamp
    ) {
        amount = BS_Options[pair][user][ID].amount;
        expiry = BS_Options[pair][user][ID].expiry;
        fees = BS_Options[pair][user][ID].fees;
        perDay = BS_Options[pair][user][ID].perDay;
        hedgeFee = BS_Options[pair][user][ID].hedgeFee;
        lastHedgeTimeStamp = BS_Options[pair][user][ID].lastHedgeTimeStamp;
        return (amount, expiry, fees, perDay, hedgeFee, lastHedgeTimeStamp);
    }

    function BS_tokenAddr(
        address pair, 
        address user, 
        uint ID
    ) external view returns (address tokenA, address tokenB) {
        tokenA = BS_Options[pair][user][ID].tokenA;
        tokenB = BS_Options[pair][user][ID].tokenB;
        return (tokenA, tokenB);
    }

    function BS_Options_expiry(address pair, address user, uint ID) external view returns (uint expiry) {
        expiry = BS_Options[pair][user][ID].expiry;
        return expiry;
    }

    function getLastHedgeTimeStamp(address pair, address user, uint ID) external view returns (uint) {
        return BS_Options[pair][user][ID].lastHedgeTimeStamp;
    }

    function BS_Options_contractAmount(
        address pair, 
        address user, 
        uint ID
    ) external view returns (uint amount) {
        amount = BS_Options[pair][user][ID].amount;
        return amount;
    }

    function BS_Options_tokenA_balance(address pair, address user, uint ID) external view returns (uint) {
        return BS_Options[pair][user][ID].tokenA_balance;
    }

    function BS_Options_tokenB_balance(address pair, address user, uint ID) external view returns (uint) {
        return BS_Options[pair][user][ID].tokenB_balance;
    }

    function BS_Options_fee_balance(address pair, address user, uint ID) external view returns (uint) {
        return BS_Options[pair][user][ID].fees;
    }

    function BS_Options_hedgeFee(address pair, address user, uint ID) external view returns (uint) {
        return BS_Options[pair][user][ID].hedgeFee;
    }

    function BS_getWithdrawParams(
        address pair,
        address user,
        uint ID
    ) external view returns (
        address tokenA, 
        address tokenB, 
        uint tokenA_balance, 
        uint tokenB_balance, 
        uint feeBalance
    ) {
        tokenA = BS_Options[pair][user][ID].tokenA;
        tokenB = BS_Options[pair][user][ID].tokenB;

        tokenA_balance = BS_Options[pair][user][ID].tokenA_balance;
        tokenB_balance = BS_Options[pair][user][ID].tokenB_balance;
        feeBalance = BS_Options[pair][user][ID].fees;

        return (tokenA, tokenB, tokenA_balance, tokenB_balance, feeBalance);
    }
}
