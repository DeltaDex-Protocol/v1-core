// Copyright 2022 DeltaDex
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {SafeERC20} from "contracts/dependencies/openzeppelin/SafeERC20.sol";
import "contracts/dependencies/openzeppelin/IERC20.sol";

import "contracts/storage/OptionStorage.sol";
import "contracts/OptionMaker.sol";

import "contracts/libraries/HedgeMath.sol";

contract PeripheryController {
    OptionStorage public storageContract;
    OptionMaker public core;

    address public immutable deployer;
    address public DAI;

    mapping(address => address) public availablePairs;

    modifier onlyDeployer {
        address sender = msg.sender;
        require(sender == deployer, "not deployer");
        _;
    }

    modifier onlyCore {
        address sender = msg.sender;
        require(sender == address(core), "not core");
        _;
    }

    constructor(address _deployer, address _DAI) {
        DAI = _DAI;
        deployer = _deployer;
    }

    function initAvailablePairs(address tokenA, address tokenB) public onlyDeployer {
        availablePairs[tokenA] = tokenB;
        availablePairs[tokenB] = tokenA;
    }

    function setStorageAddr(OptionStorage _storage) public onlyDeployer {
        storageContract = _storage;
    }

    function setCoreAddr(OptionMaker _core) public onlyDeployer {
        core = _core;
    }

    function getStorageAddr() public view returns (address) {
        return address(storageContract);
    }

    function getCoreAddr() public view returns (address) {
        return address(core);
    }
}
