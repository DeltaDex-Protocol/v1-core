// Copyright 2022 DeltaDex
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "contracts/CoreController.sol";
import "contracts/storage/OptionStorage.sol";

/// @title PairMaker
/// @author DeltaDex
/// @notice Creates a token pair address
contract PairMaker is CoreController {

    function _createPair(address tokenA, address tokenB) internal returns (address pair) {
        require(tokenA != tokenB, "DeltaDex: IDENTICAL_ADDRESSES");
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), "DeltaDex: ZERO_ADDRESS");
        require(storageContract.getPair(token0, token1) == address(0), "DeltaDex: PAIR_EXISTS");

        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        pair = address(uint160(bytes20(salt)));

        storageContract.setPair(token0, token1, pair);
        storageContract.pushToAllPairs(pair);

        return pair;
    }
}
