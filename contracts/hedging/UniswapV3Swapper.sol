// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.17;

import "contracts/dependencies/uniswap-0.8/TransferHelper.sol";
import "contracts/dependencies/uniswap-0.8/ISwapRouter.sol";

import "contracts/oracles/UniswapV3Oracle.sol";
import "contracts/PairMaker.sol";

/// @title UniswapV3 Swapper Contract
/// @author DeltaDex
/// @notice This contract swaps token0 for token1
/// @dev This contract currently provides the core functionality of the DeltaDex delta hedging strategy

contract V3Swapper is UniswapV3twap, PairMaker {
    // Does not work with SwapRouter02
    ISwapRouter public constant swapRouter =
        ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    // @dev swaps a fixed amount of WETH for a maximum possible amount of DAI
    function _swapExactInputSingle(address token0, address token1, uint amountIn) internal returns (uint amountOut) {
        
        // TransferHelper.safeTransferFrom(
        //     token0,
        //     address(this),
        //     address(this),
        //     amountIn
        // );
        TransferHelper.safeApprove(token0, address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
        .ExactInputSingleParams({
            tokenIn: token0,
            tokenOut: token1,
            fee: 3000,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: 0,
            // NOTE: In production, this value can be used to set the limit
            // for the price the swap will push the pool to,
            // which can help protect against price impact
            sqrtPriceLimitX96: 0
        });
        amountOut = swapRouter.exactInputSingle(params);
    }
    /* 
    // @dev this function is not being used currently
    function swapExactOutputSingle(address token0, address token1, uint amountOut, uint amountInMaximum)
        internal
        returns (uint amountIn)
    {
        TransferHelper.safeTransferFrom(
            token0,
            msg.sender,
            address(this),
            amountInMaximum
        );
        TransferHelper.safeApprove(token0, address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter
            .ExactOutputSingleParams({
                tokenIn: token0,
                tokenOut: token1,
                fee: 3000,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        amountIn = swapRouter.exactOutputSingle(params);

        if (amountIn < amountInMaximum) {
            // Reset approval on router
            TransferHelper.safeApprove(token0, address(swapRouter), 0);

            TransferHelper.safeTransfer(
                token0,
                msg.sender,
                amountInMaximum - amountIn
            );
        }
    } */
}