// Copyright 2022 DeltaDex
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./StorageController.sol";

interface ICORE {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

contract PairStorage is StorageController {
    // @dev currently not in use
    struct Pair {
        address tokenA;
        // uint tokenA_balance;

        address tokenB;
        // uint tokenB_balance;
    }

    // get address of Pair
    mapping(address => mapping(address => address)) public getPair;

    // all pool addresses
    address[] public allPairs;

    // @dev not used yet | pool data
    mapping(address => Pair) public Pairs;

    // address TokenPair => array of addresses
    mapping(address => address[]) public PairUsers;

    // address user => array of IDs
    mapping(address => address[]) public Positions;


    // @dev WRITE FUNCTIONS // 

    // @dev initialize available pairs
    function initializeAvailablePair(address tokenA, address tokenB) external onlyDeployer {
        ICORE(CORE).createPair(tokenA, tokenB);
    }


    // @dev link address token pair to user address
    function addPairtoUserPositions(address positionOwner, address pair) external onlyTrusted returns (bool) {
        Positions[positionOwner].push(pair);
        return true;
    }


    // @dev add address user to token pair
    function addPairUser(address positionOwner, address pair) external onlyTrusted returns (bool) {
        PairUsers[pair].push(positionOwner);
        return true;
    }


    // @dev populate mapping in both directions
    function setPair(address token0, address token1, address pair) external onlyTrusted {
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair;
    }


    function pushToAllPairs(address pair) external onlyTrusted {
        allPairs.push(pair);
    }


    // @dev pools mapping | not used yet
    function setTokensInPair(address pair, address token0, address token1) external onlyTrusted {
        Pairs[pair].tokenA = token0;
        Pairs[pair].tokenB = token1;
    }

    // @dev READ FUNCTIONS // 

    // @dev returns number of all pairs in contract
    function numOfPairs() external view returns (uint) {
        return allPairs.length;
    }


    // @dev returns address pair by ID in contract
    function returnPairAddress(uint ID) external view returns (address pair) {
        return allPairs[ID];
    }


    // @dev returnPairData by pair address in contract
    function returnPairData(address pair) external view returns (Pair memory) {
        return Pairs[pair];
    }


    // @dev gets # of open option positons of user
    function userIDlength(address user) external view returns (uint) {
        return Positions[user].length;
    }


    // @dev return all pair addresses of user
    function getUserPositions(address user) external view returns (address[] memory) {
        return Positions[user];
    }


    // @dev gets number of users in token pair
    function getNumberOfUsersInPair(address pair) external view returns (uint) {
        return PairUsers[pair].length;
    }


    // @dev return all addresses of users in token pair
    // @dev currently only called by frontend
    function getUserAddressesInPair(address pair) external view returns (address[] memory) {
        return PairUsers[pair];
    }


    // @dev gets address of user in pair
    function getPairUserAddress(address pair, uint ID) external view returns (address user) {
        user = PairUsers[pair][ID];
        return user;
    }
}
