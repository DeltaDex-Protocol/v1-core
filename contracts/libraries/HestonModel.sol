// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../dependencies/prb-math/PRBMathSD59x18.sol";
import "./Trigonometry.sol";

// import "./Complex.sol";

contract Heston {
    using PRBMathSD59x18 for int256;

    /*
    function gasTest(int re, int im, int runs) public pure returns (int,int) {
        for (int i = 0; i < runs; i++) {
            (re,im) = Complex.complexLN(re,im);
        }
        return (re,im);
    }
    */

    // ############### HESTON PRICING FUNCTION ############### 
    // @dev not completely written 

    int private iterations = 10_000;
    int private P = 0;
    int private maxNumber = 100;

    struct element {
        int a;
        int b;
        int c;
        int d;
    }
    element Vals;


    struct equation {
        int num1;
        int num2;
        int deno;
    }
    equation hestonEq;


    // eventually this will be mapped per token pair
    struct tokenVals {
        int rate;
        int sigma;
        int kappa;
        int theta;
        int volvol;
        int rho;
    }
/*
    tokenVals public tVals = tokenVals(1e17,1e17,2e17,1e17,1e17,1e17);


    struct fheston {
        int re;
        int im;
        int d1;
        int s2;
        int sir;
    }

     fheston fhVals;


    function fHeston(
        int s,
        int St,
        int K,
        int T
        )

    public view returns (int,int) {

    // ADDED SCOPE TO PREVENT STACK TOO DEEP
    
        int pre;
        int pim; // 7 vars
        {
            int prod = (tVals.rho * tVals.sigma * s) / 1e36;
            // prod @dev multiplying by i

            // test
            (pre,pim) = Complex.mul(prod,0,0,1e18);
            //(pre,pim) = mul2(prod,0,0,1e18); // 11 vars
        } // 7 vars

        int dre;
        int dim; //12 vars
        {
            int d1re;
            int d1im;
            // ########  CALCULATE D
            // D1
            // calculate d1
            (d1re,d1im) = Complex.sub(pre,pim,tVals.kappa,0);
            (d1re,d1im) = Complex.mul(d1re,d1im,d1re,d1im);
            // D2
            // complex part of d2
            (dre, dim) = Complex.mul(s,0,0,1e18);
            dre += (s**2)/1e18;
            (dre,dim) = Complex.mul(((tVals.sigma**2)/1e18),0,dre,dim);
            // D1 + D2
            (dre,dim) = Complex.add(dre,dim,d1re,d1im);
            // calculate sqrt.d
            (dre,dim) = Complex.complexSQRT(dre,dim); // 14 vars
        } // 12 vars

        int gre;
        int gim; // 14
        {
            int g1re;
            int g1im;
            // g1
            (g1re,g1im) = Complex.sub(tVals.kappa,0,pre,pim);
            (g1re,g1im) = Complex.sub(g1re,g1im,dre,dim);
            // g2
            (gre,gim) = Complex.sub(tVals.kappa,0,pre,pim);
            (gre,gim) = Complex.add(gre,gim,dre,dim);
            // G 
            // CHECKED TO HERE
            (gre,gim) = Complex.div(g1re,g1im,gre,gim); // 16
        } // 14
    }
    */

    /* 

    # Calculate first exponential
    exp1 = np.exp(np.log(St) * i * s) * np.exp(i * s * r * T)
    exp2 = 1 - g * np.exp(-d * T)
    exp3 = 1 - g
    mainExp1 = exp1 * np.power(exp2 / exp3, -2 * theta * kappa/(sigma**2))

    */ 


    /*
    function eHeston(int sre, int sim, int St, int T, int dre, int dim, int gre, int gim) public view returns (int,int) {
        // exp1
        int e1re;
        int e1im;
        {
            int a = St.ln();
            // multiplying a by i
            (e1re, e1im) = Complex.mul(a, 0, 0, 1e18);
            (e1re, e1im) = Complex.mul(e1re, e1im, sre, sim);
            (e1re, e1im) = Complex.complexEXP(e1re, e1im);

            // second part of exp1

            // rate * T 
            a = tVals.rate * T / 1e18;

            int e2re;
            int e2im; 

            // rt * i
            (e2re, e2im) = Complex.mul(a, 0, 0, 1e18);
            (e2re, e2im) = Complex.mul(e2re, e2im, sre, sim);

            (e2re, e2im) = Complex.complexEXP(e2re, e2im);

            // should complete exp1
            (e1re, e1im) = Complex.mul(e1re, e1im, e2re, e2im);
        }

        // exp2
        int e2re;
        int e2im;
        {
            // exp2 uses G which has re and im parts
            // @dev EXP2 HAS NEGATIVE D !!
            (dre, dim) = Complex.mul(dre, dim, -1e18, 0);
            (e2re, e2im) = Complex.mul(dre, dim, T, 0);
            (e2re, e2im) = Complex.complexEXP(e2re, e2im);
            (e2re, e2im) = Complex.mul(e2re, e2im, gre, gim);
            (e2re, e2im) = Complex.sub(1e18, 0, e2re, e2im);
        }
        // exp3
        int e3re;
        int e3im;
        {
            (e3re, e3im) = Complex.sub(1e18, 0, gre, gim);
        }

        return (e3re,e3im);

    }
    */
    


    // @dev WHAT NEEDS TO BE DONE:
    // 1) NUMERATOR 1 HAS ITS OWN RE AND IM PARTS
    // 2) NUMERATOR 2 HAS ITS OWN RE AND IM PARTS
    // ETC
    // YOU NEED TO STORE THESE RE AND IM PARTS OUTSIDE THE FOR LOOP

    /*
    function priceHestonMid(int St, int K, int r, int T) public returns (int) {

        int ds = maxNumber / iterations;

        // Element 1
        Vals.a = normalizeAmount((-r * T));
        Vals.b = Vals.a.exp();
        Vals.c = K * Vals.b;
        Vals.d = (St - normalizeAmount(Vals.c)) / 2;

        int re;
        int im;

        int s1;
        int s2;

        int P;


        for (int i = 1; i < iterations; i++) {
            s1 = ds * (2 * i + 1) / 2;
            s2 = s1 - i;

            // this is going to be in re and im parts
            hestonEq.num1 = fHeston(s2, St, K, r, T);
            hestonEq.num2 = K * fHeston(s2, St, K, r, T);

            // Denominator calculated through multiple steps

            (re,im) = Complex.mul((K.ln() * s1),0);

            (re,im) = Complex.complexEXP(re,im);

            (re,im) = Complex.mul(re,im);

            // denominator re and im parts
            re *= s1;
            im *= s1;

            return hestonEq.deno;

        }

        return hestonEq.deno;

    }

    */
    

}