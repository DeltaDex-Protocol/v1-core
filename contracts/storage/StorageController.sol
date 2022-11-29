// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract StorageController {

    address public deployer;

    // core
    address CORE;

    // periphery
    address public BSM_MAKER;


    modifier onlyDeployer {
        address msgSender = msg.sender;
        require(msg.sender == deployer, "not owner");
        _;
    }

    modifier onlyTrusted {
        address sender = msg.sender;
        require(sender == address(CORE) || sender == address(BSM_MAKER), "not trusted");
        _;
    }

    constructor () {
        deployer = msg.sender;
    }

    function getCoreAddr() public view returns (address) {
        return address(CORE);
    }

    function getPeripheryAddr() public view returns (address) {
        return (address(BSM_MAKER));
    }

    function setCoreAddr(address _CORE) public onlyDeployer {
        CORE = _CORE;
    }

    function setPeripheryAddr(address _BSM_MAKER) public onlyDeployer {
        BSM_MAKER = _BSM_MAKER;

    }
}