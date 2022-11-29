// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./CoreController.sol";
import "contracts/storage/OptionStorage.sol";

/// @title PairMaker
/// @author DeltaDex
/// @notice Creates a token pair address
/// @dev This token pair address is used to keep track of of protocol fees accrued in the token pair

contract PairMaker is CoreController {
    // @dev creates pair if it doesn't already exist
    function _createPair(address tokenA, address tokenB) internal returns (address pair) {
        require(tokenA != tokenB, "DeltaDex: IDENTICAL_ADDRESSES");
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), "DeltaDex: ZERO_ADDRESS");
        require(storageContract.getPair(token0, token1) == address(0), "DeltaDex: PAIR_EXISTS"); // single check is sufficient

        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        pair = address(uint160(bytes20(salt)));

        storageContract.setPair(token0, token1, pair);
        storageContract.setPair(token1, token0, pair);

        storageContract.pushToAllPairs(pair);

        // // @dev Pools mapping
        storageContract.setTokensInPair(pair, token0, token1);

        return pair;
    }
}