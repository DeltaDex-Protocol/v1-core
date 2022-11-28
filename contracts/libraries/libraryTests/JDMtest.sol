// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../Statistics.sol";

import "hardhat/console.sol";

contract JDMtest {
    using PRBMathSD59x18 for int256;

    /// @notice JDMOptionParams
    /// @dev nested struct JDM_params 
    struct JDMOptionParams {
        int K;
        int T;
        int r;
        int sigma;
        int m;
        int v;
        int lam;
    }

    /// @notice MertonInput
    /// @dev Only used internally by smart contract
    struct MertonInput {
        int S;
        int K; 
        int T; 
        int r; 
        int sigma; 
        int m;
        int v; 
        int lam;
    }

    /// @notice JDM_params
    /// @dev User 1 input
    struct JDM_params {
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

        JDMOptionParams parameters;
    }

    /// @notice factorial 1-5
    /// @dev factorial from 1 to 5 // https://ethereum.stackexchange.com/questions/51415/how-do-i-make-an-efficient-lookup-table
    /// @dev would be useful for it to take int256 and return int256 
    /// @param input input
    /// @return fact fact
    function factorial(int input) public pure returns (int fact) {
        input = input / 1e18;
        uint256 index = uint256(input);
        uint256 factu256 = uint8 (bytes (hex"010102061878") [index]);
        fact = int(factu256 * 1e18);
        return fact;
    }

    /// @notice d1 of Black Scholes
    /// @param S price
    /// @param K strike
    /// @param r risk free rate
    /// @param sigma volatility
    /// @param T expiry
    /// @return d1 d1
    function D1(int S,int K, int r, int sigma, int T) public pure returns (int){
        int d1 = ((S.div(K)).ln() + (r + ((sigma.pow(2e18)).div(2e18)).mul(T))).div(sigma.mul(T.sqrt()));
        return d1;
    }

    /// @notice d2 of Black Scholes
    /// @param d1 d1
    /// @param sigma volatility
    /// @param T expiry
    /// @return d2 d2
    function D2(int d1, int sigma, int T) public pure returns (int){
        int d2 = d1 - sigma.mul(T.sqrt());
        return d2;
    }

    /// @notice BS Call (returns price)
    /// @param S price
    /// @param K strike
    /// @param r risk free rate
    /// @param sigma volatility
    /// @param T expiry
    /// @return C price
    function BS_CALL(int S, int K, int T, int r, int sigma) public pure returns (int){
        int d1 = D1(S,K,r,sigma,T);
        int d2 = D2(d1,sigma,T);
        int C = S.mul(Statistics.cdf(d1)) - (K.mul((-r.mul(T)).exp()).mul(Statistics.cdf(d2)));
        return C;
    }

    /// @notice BS Put (returns price)
    /// @param S price
    /// @param K strike
    /// @param r risk free rate
    /// @param sigma volatility
    /// @param T expiry
    /// @return C price
    function BS_PUT(int S, int K, int T, int r, int sigma) public pure returns (int){
        int d1 = D1(S,K,r,sigma,T);
        int d2 = D2(d1,sigma,T);
        int C = K.mul((-r.mul(T)).exp()).mul(Statistics.cdf(-d2)) - (S.mul(Statistics.cdf(-d1)));
        return C;
    }

    /// @notice BS Call (returns delta)
    /// @param S price
    /// @param K strike
    /// @param r risk free rate
    /// @param sigma volatility
    /// @param T expiry
    /// @return delta price
    function delta_BS_CALL(int S, int K, int T, int r, int sigma) public pure returns (int){
        int d1 = D1(S,K,r,sigma,T);
        return Statistics.cdf(d1);
    }

    /// @notice BS Put (returns delta)
    /// @param S price
    /// @param K strike
    /// @param r risk free rate
    /// @param sigma volatility
    /// @param T expiry
    /// @return delta price
    function delta_BS_PUT(int S, int K, int T, int r, int sigma) public pure returns (int){
        int d1 = D1(S,K,r,sigma,T);
        return Statistics.cdf(d1) - 1e18;
    }

    /// @notice RK
    /// @dev rk of Jump Diffusion Model
    /// @param r risk free rate
    /// @param lam lam
    /// @param m m
    /// @param k for loop
    /// @return r_k r_k
    function RK(int r, int lam, int m, int k, int T) public pure returns (int) {
        int r_k = r - (lam.mul(m - 1e18)) + ((k.mul(m.ln())).div(T));
        return r_k;
    }

    /// @notice SIGMA_K
    /// @dev sigma k of Jump Diffusion Model
    /// @param sigma risk free rate
    /// @param k for loop
    /// @param v v
    /// @param T T
    /// @return sigma_k sigma_k
    function SIGMA_K(int sigma, int k, int v, int T) public pure returns (int) {
        int sigma_k = (sigma.pow(2e18) + (k.mul(v.pow(2e18))).div(T)).sqrt();           
        return sigma_k;
    }

    /// @notice MJCnum
    /// @dev Merton Jump Cost numerator
    /// @param m m
    /// @param lam lam
    /// @param T T
    /// @param k k
    /// @param k_fact k_fact
    /// @return num numerator
    function MJCnum(int m, int lam, int T, int k, int k_fact) public pure returns (int) {
        int one = (-m.mul(lam).mul(T)).exp();
        int two = ((m.mul(lam).mul(T)).pow(k)).div(k_fact);
        int num = one.mul(two);
        return num;
    }

    /// @notice MERTON_CALL
    /// @dev Merton Jump Diffusion model Call (returns price and delta)
    /// @param _params MertonInput
    /// @return C C
    /// @return delta delta
    function MERTON_CALL(MertonInput memory _params) public pure returns (int C, int delta) {
        C = 0;
        int d1 = 0;
        for (int i=0; i<5; i++){
            int k = i * 1e18;

            int r_k = RK(_params.r,_params.lam,_params.m,k,_params.T);
            int sigma_k = SIGMA_K(_params.sigma,k,_params.v,_params.T);
            int k_fact = factorial(k);

            C += MJCnum(_params.m,_params.lam,_params.T,k,k_fact).mul(BS_CALL(_params.S,_params.K,_params.T,r_k,sigma_k));
            d1 += MJCnum(_params.m,_params.lam,_params.T,k,k_fact).mul(D1(_params.S,_params.K,_params.r,_params.sigma,_params.T));
        }
        delta = Statistics.cdf(d1);
        return (C,delta);
    }

    /// @notice pMERTON_CALL
    /// @dev Merton Jump Diffusion model Call (returns price)
    /// @param _params MertonInput
    /// @return C C
    function pMERTON_CALL(MertonInput memory _params) public pure returns (int C) {
        C = 0;
        for (int i=0; i<5; i++){
            int k = i * 1e18;

            int r_k = RK(_params.r,_params.lam,_params.m,_params.K,_params.T);
            int sigma_k = SIGMA_K(_params.sigma,k,_params.v,_params.T);
            int k_fact = factorial(k);

            C += MJCnum(_params.m,_params.lam,_params.T,k,k_fact).mul(BS_CALL(_params.S,_params.K,_params.T,r_k,sigma_k));
        }
        return C;
    }

    /// @notice delta_MERTON_CALL
    /// @dev Merton Jump Diffusion model Call (returns delta)
    /// @param _params MertonInput
    /// @return delta delta
    function delta_MERTON_CALL(MertonInput memory _params) public pure returns (int delta) {
        int d1 = 0;
        for (int i=0; i<5; i++){
            int k = i * 1e18;

            int k_fact = factorial(k);

            d1 += MJCnum(_params.m,_params.lam,_params.T,k,k_fact).mul(D1(_params.S,_params.K,_params.r,_params.sigma,_params.T));
        }
        delta = Statistics.cdf(d1);
        return (delta);
    }

    /// @notice MERTON_PUT
    /// @dev Merton Jump Diffusion model Put (returns price and delta)
    /// @param _params MertonInput
    /// @return C C
    /// @return delta delta
    function MERTON_PUT(MertonInput memory _params) public pure returns (int C, int delta) {
        C = 0;
        int d1 = 0;
        for (int i=0; i<5; i++){
            int k = i * 1e18;

            int r_k = RK(_params.r,_params.lam,_params.m,_params.K,_params.T);
            int sigma_k = SIGMA_K(_params.sigma,k,_params.v,_params.T);
            int k_fact = factorial(k);

            C += MJCnum(_params.m,_params.lam,_params.T,k,k_fact).mul(BS_PUT(_params.S,_params.K,_params.T,r_k,sigma_k));
            d1 += MJCnum(_params.m,_params.lam,_params.T,k,k_fact).mul(D1(_params.S,_params.K,_params.r,_params.sigma,_params.T));
        }
        delta = Statistics.cdf(d1);
        return (C,delta);
    }

    /// @notice pMERTON_PUT
    /// @dev Merton Jump Diffusion model Put (returns price)
    /// @param _params MertonInput
    /// @return C C
    function pMERTON_PUT(MertonInput memory _params) public pure returns (int C) {
        C = 0;
        for (int i=0; i<5; i++){
            int k = i * 1e18;

            int r_k = RK(_params.r,_params.lam,_params.m,_params.K,_params.T);
            int sigma_k = SIGMA_K(_params.sigma,k,_params.v,_params.T);
            int k_fact = factorial(k);

            C += MJCnum(_params.m,_params.lam,_params.T,k,k_fact).mul(BS_PUT(_params.S,_params.K,_params.T,r_k,sigma_k));
        }
        return C;
    }

    /// @notice pMERTON_PUT
    /// @dev Merton Jump Diffusion model Put (returns delta))
    /// @param _params MertonInput
    /// @return delta delta
    function delta_MERTON_PUT(MertonInput memory _params) public pure returns (int delta) {
        int d1 = 0;
        for (int i=0; i<5; i++){
            int k = i * 1e18;
            
            int k_fact = factorial(k);

            d1 += MJCnum(_params.m,_params.lam,_params.T,k,k_fact).mul(D1(_params.S,_params.K,_params.r,_params.sigma,_params.T));
        }
        delta = Statistics.cdf(d1);
        return (delta);
    }
}