// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./OptionHedger.sol";

import "contracts/periphery/BSMOptionMaker.sol";
    
/// @title OptionMaker
/// @author DeltaDex
/// @notice This contract contains the main logic for initializing option replication positions
/// @dev using delegatecall to run logic of BSOptionMaker and JDMOptionMaker

contract OptionMaker is OptionHedger {
    using SafeERC20 for IERC20;

    // periphery
    BSMOptionMaker public BSM_MAKER;

    constructor (OptionStorage _storage, BSMOptionMaker _BSM_MAKER) {
        deployer = msg.sender;

        storageContract = _storage;

        addrBSM_MAKER = address(_BSM_MAKER);

        BSM_MAKER = _BSM_MAKER;
    }

    function transferIn(address token, uint amount) public nonReentrant onlyTrusted returns(bool success) {
        IERC20(token).safeTransferFrom(tx.origin, address(this), amount);
        success = true;
        return success;
    }

    function withdraw_transfer(address tokenA, address tokenB, uint tokenA_balance, uint tokenB_balance, uint feeBalance) public nonReentrant onlyTrusted returns(bool success) {
        IERC20(tokenA).safeTransfer(tx.origin, tokenA_balance);
        IERC20(tokenB).safeTransfer(tx.origin, tokenB_balance);
        IERC20(DAI).safeTransfer(tx.origin, feeBalance);
        success = true;
        return success;
    }

    function createPair(address tokenA, address tokenB) public onlyTrusted returns (address pair) {
        return _createPair(tokenA,tokenB);
    }

    function swapExactInputSingle(address token0, address token1, uint amountIn) public onlyTrusted returns (uint amountOut) {
        return _swapExactInputSingle(token0, token1, amountIn);
    }

    // @dev BS OptionMaker functions 
    function BS_START_REPLICATION(BS.BS_params memory _params) public returns (address pair,uint amountOut) {
        (pair, amountOut) = BSM_MAKER.BS_START_REPLICATION(_params);
        return (pair, amountOut);
    }

    // @dev require check that msg.sender is owner of position!
    function BS_edit_params(address pair, uint ID, uint feeAmount, BS.BS_params memory _params) public nonReentrant returns (bool) {
        bool success = BSM_MAKER.BS_edit_params(pair,ID,feeAmount,_params);
        return success;
    }
    
    // @dev require check that msg.sender is owner of position!
    function BS_Withdraw(address pair, uint ID) public nonReentrant returns (bool success) {
        success = BSM_MAKER.BS_Withdraw(pair,ID);
        return success;
    }
}