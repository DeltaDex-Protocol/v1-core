// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../Statistics.sol";

import "hardhat/console.sol";

library BSCtest {
    using PRBMathSD59x18 for int256;

    struct BSCurvedParams {
        int K; 
        int T; 
        int r; 
        int sigma;
        int tv0; 
    }

    struct CurvedInput {
        int S;
        int K; 
        int T; 
        int r; 
        int sigma;
        int tv0;
    }

    struct BSC_params {
        address tokenA;
        address tokenB;

        uint tokenA_balance;
        uint tokenB_balance;

        bool isCall;
        bool isLong;

        uint amount;
        uint expiry;
        uint fees;
        uint perDay;
        uint hedgeFee;

        uint lastHedgeTimeStamp;

        BSCurvedParams parameters;
    }

    // @dev x0 is amount of token0 (e.g. usdc) at the moment when
    // user put liquidity in AMM
    function Delta(CurvedInput memory _params, int z) public pure returns(int) {
        int z2 = Z2(_params);
        int _r = _params.r / 2;
        int _sigma = _params.sigma / 2;
        int _part1 =  ( (((-(_params.r.mul(_params.T))).exp()).mul(_params.tv0.div(2e18)))).div(((_params.K.mul(_params.S))).sqrt());
        int _part2 = ((-(((_sigma.pow(2e18).div(2e18)).mul(_params.T)))).exp()).mul((_r.mul(_params.T)).exp().mul(Statistics.cdf(z2.mul(z))));
        int delta = -(_part1.mul(_part2)).mul(z); 
        return delta; 
    }

    // @dev culculate RootFirstPart for put & call
    function RootFirstPart(CurvedInput memory _params, int z) public pure returns (int) {
        int z1 = Z1(_params);
        int first_part = (-_params.T.mul(_params.r)).exp().mul(_params.tv0.mul(Statistics.cdf(z1.mul(z))));
        return first_part;
    }

    // @dev culculate RootSecondPart for put & call
    function RootSecondPart(CurvedInput memory _params, int z) public pure returns (int) {  
        int _r = _params.r.div(2e18);
        int _sigma = _params.sigma.div(2e18);
        int z2 = Z2(_params);
        int part = -(_params.T.mul(_params.r).exp().mul(_params.tv0.mul((_params.S.div(_params.K)).sqrt())));
        int second_part = -(part.mul((-(_sigma.pow(2e18).div(2e18).mul(_params.T))).exp().mul((_r.mul(_params.T)).exp().mul(Statistics.cdf(z2.mul(z))))));
        return  second_part; 
    }

    // @dev culculate z1 
    function Z1(CurvedInput memory _params) public pure returns(int) {
        int z1 = -((_params.S.div(_params.K)).ln() + (_params.r - _params.sigma.pow(2e18).div(2e18)).mul(_params.T)).div(_params.T.sqrt().mul(_params.sigma));
        return z1;
    }

    // @dev culculate z2
    function Z2(CurvedInput memory _params) public pure returns(int) {
        int _sigma = _params.sigma.div(2e18);
        int z1 = Z1(_params);
        int z2 = z1 - _sigma.mul(_params.T.sqrt());
        return z2;
    }

    // @dev Put: culculate first part
    // z1
    function BSPutRootFirstPart(CurvedInput memory _params) public pure returns(int) {
        int z = 1e18;
        int first_part = RootFirstPart(_params, z);
        return first_part;
    }

    // @dev Put: culculate second part
    // z2 
    function BSPutRootSecondPart(CurvedInput memory _params) public pure returns(int) {
        int z = 1e18;
        int second_part = RootSecondPart(_params, z);
        return  second_part;
    }

    // @dev x0 is amount of token0 (e.g. usdc) at the moment when
    // user put liquidity in AMM
    // diff = difference
    function BS_root_put(CurvedInput memory _params) public pure returns(int) {
        int first_part = BSPutRootFirstPart(_params);
        int second_part = BSPutRootSecondPart(_params);
        int diff = first_part - second_part;
        return diff;
    }

    function delta_BS_root_put(CurvedInput memory _params) public pure returns(int) {
        int z = 1e18;
        int delta =  Delta(_params, z);
        return delta;  
    }

    // @dev Call: culculate first part
    // -z1
    function BSCallRootFirstPart(CurvedInput memory _params) public pure returns(int) {
        int z = -1e18;
        int first_part = RootFirstPart(_params, z);
        return first_part;
    }

    // @dev Call: culculate second part
    // -z2
    function BSCallRootSecondPart(CurvedInput memory _params) public pure returns(int) {
        int z = -1e18;
        int second_part = RootSecondPart(_params, z);
        return  second_part;
    }
   
    // @dev x0 is amount of token0 (e.g. usdc) at the moment when
    // user put liquidity in AMM
    // diff = difference 
    function BS_root_call(CurvedInput memory _params) public pure returns(int) {
        int first_part = BSCallRootFirstPart(_params);
        int second_part = BSCallRootSecondPart(_params);
        int diff = second_part - first_part;
        return diff;
    }

    // @dev x0 is amount of token0 (e.g. usdc) at the moment when
    // user put liquidity in AMM
    function delta_BS_root_call(CurvedInput memory _params) public pure returns(int) {
        int z = -1e18;
        int delta =  Delta(_params, z);
        return delta;  
    } 
}