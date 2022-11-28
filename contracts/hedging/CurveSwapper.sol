// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "contracts/dependencies/openzeppelin/IERC20.sol";

/// @title Curve Swapper
/// @author Volatility Smilers @Polygon Buidl It Hackathon
/// @notice Swaps tokens on Curve
/// @dev Change stable_swap address for different token pairs 

interface StableSwap {
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
}

contract CurveSwap {

    address public STABLE_SWAP = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;

    address public DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

    address[] public TOKENS = [DAI,USDC,USDT];

      address private owner;

    // token to initial balance in contract
    mapping(address => uint) public balances;

    constructor () {
        owner = msg.sender;
    }

    function typeConvert(uint256 val) public pure returns (int128) {
        uint128 a = uint128(val);
        int128 b = int128(a);
        return b;
    }

    function deposit(address _token, uint _amount) public {
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        balances[_token] = _amount;
    }

    function withdraw(address _token, uint _amount) public {
        IERC20(_token).transfer(owner, _amount);
    }
    
    function swap(uint256 i, uint256 j) public {

        uint256 bal = IERC20(TOKENS[i]).balanceOf(address(this));
        uint256 min_dy = 1;

        IERC20(TOKENS[i]).approve(STABLE_SWAP, bal);

        int128 _i = typeConvert(i);
        int128 _j = typeConvert(j);

        StableSwap(STABLE_SWAP).exchange(_i,_j,bal,min_dy);
    }   
}