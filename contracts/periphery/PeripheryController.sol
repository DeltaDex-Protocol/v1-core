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

    // Token Addresses

    address public immutable WBTC = 0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6;
    address public immutable WETH = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
    address public immutable UNI = 0xb33EaAd8d922B1083446DC23f610c2567fB5180f;
    address public immutable DAI = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;

    mapping(address => address) public availablePairs;

    constructor(address _deployer) {
        deployer = _deployer;
        initAvailablePairs();
    }

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

    function initAvailablePairs() internal {
        availablePairs[WBTC] = DAI;
        availablePairs[WETH] = DAI;
        availablePairs[UNI] = DAI;
    }

    function checkTokenAddress(address token) internal view returns (bool) {
        if (availablePairs[token] == DAI) {
            return true;
        }
        else {
            return false;
        }
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