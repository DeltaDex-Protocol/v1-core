// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "contracts/dependencies/openzeppelin/ERC20/ERC20.sol";

contract DeltaDexDAI is ERC20 {
    uint constant _initial_supply = 10**50 * (10**18);

    constructor() ERC20("DeltaDexDAI", "DD_DAI") {
        _mint(msg.sender, _initial_supply);
    }

    function mint(uint256 amount) external {
        require(amount < 10_000*1e18, "amount minted must me less than 10_000*1e18");
        _mint(msg.sender, amount);
    }
}