// Copyright 2022 DeltaDex
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "contracts/periphery/BSMOptionMaker.sol";

import "contracts/OptionHedger.sol";

/// @title OptionMaker
/// @author DeltaDex
/// @notice This contract contains the main logic for initializing option replication positions
/// @dev using delegatecall to run logic of BSOptionMaker and JDMOptionMaker

contract OptionMaker is OptionHedger {
    using SafeERC20 for IERC20;


    // periphery
    BSMOptionMaker public BSM_MAKER;


    constructor (OptionStorage _storage, BSMOptionMaker _BSM_MAKER, address _DAI) {
        deployer = msg.sender;
        storageContract = _storage;
        addressBSMaker = address(_BSM_MAKER);

        BSM_MAKER = _BSM_MAKER;
        DAI = _DAI;
    }


    function transferIn(
        address positionOwner,
        address token,
        uint amount
    ) public onlyTrusted returns (bool) {
        IERC20(token).safeTransferFrom(positionOwner, address(this), amount);
        return true;
    }


    function createPair(address tokenA, address tokenB) external onlyTrusted returns (address pair) {
        return _createPair(tokenA, tokenB);
    }


    function swapExactInputSingle(
        address token0,
        address token1,
        uint amountIn
    ) external nonReentrant onlyTrusted returns (uint amountOut) {
        return _swapExactInputSingle(token0, token1, amountIn);
    }


    function BS_START_REPLICATION(BS.BS_params memory _params) external returns (address pair, uint amountOut) {
        address positionOwner = msg.sender;

        (pair, amountOut) = BSM_MAKER.BS_START_REPLICATION(_params, positionOwner);

        return (pair, amountOut);
    }


    // @dev User 1 can update the params of their option replication for BS model call
    // DAI-ETH Call replication => fee is in DAI
    function BS_edit_params(
        address pair, 
        uint ID, 
        uint feeAmount, 
        BS.BS_params memory _params
    ) external returns (bool) {
        address positionOwner = msg.sender;
        storageContract.BS_edit_params(pair, positionOwner, ID, _params);

        if (feeAmount > 0) {
            require(transferIn(positionOwner, DAI, feeAmount), "transfer failed");
            storageContract.BS_addFee(pair, positionOwner, ID, feeAmount);
        }
        return true;
    }


    function BS_Withdraw(address pair, uint ID) external nonReentrant returns (bool) {
        address positionOwner = msg.sender;

        (address tokenA,
        address tokenB,
        uint tokenA_balance,
        uint tokenB_balance,
        uint feeBalance) = storageContract.BS_getWithdrawParams(pair, positionOwner, ID);

        require(storageContract.BS_withdraw(pair, positionOwner, ID), "withdraw failed");
        require(withdraw_transfer(positionOwner, tokenA, tokenB, tokenA_balance, tokenB_balance, feeBalance), "transfer failed");

        return true;
    }


    function withdraw_transfer(
        address positionOwner, 
        address tokenA, 
        address tokenB, 
        uint tokenA_balance, 
        uint tokenB_balance, 
        uint feeBalance
    ) private returns (bool) {
        IERC20(tokenA).safeTransfer(positionOwner, tokenA_balance);
        IERC20(tokenB).safeTransfer(positionOwner, tokenB_balance);
        IERC20(DAI).safeTransfer(positionOwner, feeBalance);
        return true;
    }
}
