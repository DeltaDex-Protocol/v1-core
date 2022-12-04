// Copyright 2022 DeltaDex
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "contracts/dependencies/openzeppelin/ReentrancyGuard.sol";

import "contracts/storage/OptionStorage.sol";

contract CoreController is ReentrancyGuard {
    // deployer
    address public deployer;

    // storage
    OptionStorage public storageContract;

    // periphery
    address public addressBSMaker;

    address public DAI;

    modifier onlyDeployer {
        address msgSender = msg.sender;
        require(msgSender == deployer, "not owner");
        _;
    }

    modifier onlyTrusted {
        address sender = msg.sender;
        require(sender == address(addressBSMaker), "not trusted");
        _;
    }

    function getStorageAddr() public view returns (address) {
        return address(storageContract);
    }

    function getPeripheryAddr() public view returns (address) {
        return (address(addressBSMaker));
    }
}
