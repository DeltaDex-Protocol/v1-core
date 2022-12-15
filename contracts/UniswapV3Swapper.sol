// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.17;

import "contracts/dependencies/uniswap-0.8/TransferHelper.sol";
import "contracts/dependencies/uniswap-0.8/ISwapRouter.sol";

import "contracts/dependencies/uniswap-0.8/IUniswapV3Factory.sol";
import "contracts/dependencies/uniswap-0.8/OracleLibrary.sol";

import "contracts/PairMaker.sol";

import "hardhat/console.sol";

/// @title UniswapV3 Swapper Contract
/// @author DeltaDex
/// @notice This contract swaps token0 for token1
/// @dev This contract currently provides the core functionality of the DeltaDex delta hedging strategy

contract V3Swapper is PairMaker {
    IUniswapV3Factory public constant v3Factory = IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);
    ISwapRouter public constant swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    // @dev swaps a fixed amount of WETH for a maximum possible amount of DAI
    function _swapExactInputSingle(address token0, address token1, uint amountIn) internal returns (uint amountOut) {
        TransferHelper.safeApprove(token0, address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
        .ExactInputSingleParams({
            tokenIn: token0,
            tokenOut: token1,
            fee: 500,
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

    // @dev gets price of token0 in terms of token1 
    function getPrice(address token0, address token1) public view returns (int) {
        int price = int(estimateAmountOut(token0, 1e18, 12, token1));
        return price;
    }

    // @dev gets price of tokenIn in terms of tokenOut
    function estimateAmountOut(
        address tokenIn,
        uint128 amountIn,
        uint32 secondsAgo,
        address tokenOut
    ) internal view returns (uint amountOut) {
        address pool = getPool(tokenIn, tokenOut, 500);

        // Code copied from OracleLibrary.sol, consult()
        uint32[] memory secondsAgos = new uint32[](2);
        secondsAgos[0] = secondsAgo;
        secondsAgos[1] = 0;

        (int56[] memory tickCumulatives, ) = IUniswapV3Pool(pool).observe(
            secondsAgos
        );

        int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];

        int24 tick = int24(tickCumulativesDelta / int56(uint56(secondsAgo)));

        if (tickCumulativesDelta < 0 && (tickCumulativesDelta % int56(uint56(secondsAgo)) != 0)) tick--;

        amountOut = OracleLibrary.getQuoteAtTick(
            tick,
            amountIn,
            tokenIn,
            tokenOut
        );
    }

    // @dev gets pool address of token pair on uniswap v3
    function getPool(address token0, address token1, uint24 fee) internal view returns (address) {
        address pool = v3Factory.getPool(token0, token1, fee);

        console.log("Pool!!!!!!!!!!!!!!!!");
        console.log(pool);

        require(pool != address(0), "DeltaDex: Pool doesn't exist on Uniswap V3, 85");
        return pool;
    }
}
