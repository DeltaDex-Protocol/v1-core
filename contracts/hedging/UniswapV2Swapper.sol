// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {SafeERC20} from "contracts/dependencies/openzeppelin/SafeERC20.sol";
import "contracts/dependencies/openzeppelin/IERC20.sol";

import "contracts/dependencies/uniswap-0.8/TransferHelper.sol";
import "contracts/dependencies/uniswap-0.8/IUniswapV2.sol";

/// @title UniswapV2 Swapper Contract
/// @author DeltaDex
/// @notice Swaps token0 for token1 on Uniswap V2 (sushiswap, pancakeswap etc)
/// @dev Currently this contract is not being inherited by the main DeltaDex contract
contract UniswapV2Swap {
  address public constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
  address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

  function swapV2(
    address token0,
    address token1,
    uint amountIn,
    uint amountOutMin
  ) internal {

    TransferHelper.safeTransferFrom(
        token0,
        address(this),
        address(this),
        amountIn
    );
    TransferHelper.safeApprove(token0, address(UNISWAP_V2_ROUTER), amountIn);

    address[] memory path;

    path = new address[](2);
    path[0] = token0;
    path[1] = token1;

    IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(
      amountIn,
      amountOutMin,
      path,
      address(this),
      block.timestamp
    );
  }

  function getAmountOutMin(address _tokenIn, address _tokenOut) public view returns (uint) {
    // @dev path of token swap on uniswap v2
    address[] memory path;

    if (_tokenIn == WETH || _tokenOut == WETH) {
      path = new address[](2);
      path[0] = _tokenIn;
      path[1] = _tokenOut;
    } else {
      path = new address[](3);
      path[0] = _tokenIn;
      path[1] = WETH;
      path[2] = _tokenOut;
    }

    // same length as path
    uint[] memory amountOutMins =
      IUniswapV2Router(UNISWAP_V2_ROUTER).getAmountsOut(1e18, path);

    return amountOutMins[path.length - 1];
  }
}