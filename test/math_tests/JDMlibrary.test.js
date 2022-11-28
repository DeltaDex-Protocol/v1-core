const { expect, assert } = require("chai");
require("@nomiclabs/hardhat-waffle");
const { parseUnits } = require("ethers/lib/utils");
const { ethers, network } = require("hardhat");

describe("Test math libraries ", () => {
  // input parameters
  let S = "100";
  let K = "100";
  let T = "1";
  let r = "1";
  let sigma = "1";
  let m = "1";
  let v = "1";
  let lam = "1";

  let k = "1";
  let k_fact = "1";

  S = ethers.utils.parseUnits(S);
  K = ethers.utils.parseUnits(K);
  T = ethers.utils.parseUnits(T);
  r = ethers.utils.parseUnits(r);
  sigma = ethers.utils.parseUnits(sigma);
  m = ethers.utils.parseUnits(m);
  v = ethers.utils.parseUnits(v);
  lam = ethers.utils.parseUnits(lam);

  k = ethers.utils.parseUnits(k);
  k_fact = ethers.utils.parseUnits(k_fact);

  // library addresses
  let Statslib;
  let JDMlib;

  it("Should deploy libraries", async () => {
    signers = await ethers.getSigners();

    const Statistics = await ethers.getContractFactory("Statistics");
    Statslib = await Statistics.deploy();
    await Statslib.deployed();
    console.log("stats library:", Statslib.address);

    // @dev deploy Jump Diffusion model library
    const JDM = await ethers.getContractFactory("JDMtest", {
      signer: signers[0],
      libraries: {
        Statistics: Statslib.address,
      },
    });
    JDMlib = await JDM.deploy();
    await JDMlib.deployed();
    console.log("JDM library:", JDMlib.address);
  });

  it("Should calculate factorial", async () => {
    let input = ethers.utils.parseUnits("4");
    let factorial = await JDMlib.factorial(input);
    factorial = ethers.BigNumber.from(factorial);
    console.log(factorial);
  });

  it("Should calculate D1", async () => {
    let D1 = await JDMlib.D1(S, K, r, sigma, T);
    D1 = ethers.BigNumber.from(D1);
    console.log(D1);
  });

  it("Should calculate D2", async () => {
    let D1 = await JDMlib.D1(S, K, r, sigma, T);
    let D2 = await JDMlib.D2(D1, sigma, T);

    D2 = ethers.BigNumber.from(D2);
    console.log(D2);
  });

  it("Should calculate BS Call", async () => {
    let BScall = await JDMlib.BS_CALL(S, K, T, r, sigma);

    BScall = ethers.BigNumber.from(BScall);
    console.log(BScall);
  });

  it("Should calculate BS Put", async () => {
    let BSput = await JDMlib.BS_PUT(S, K, T, r, sigma);

    BSput = ethers.BigNumber.from(BSput);
    console.log(BSput);
  });

  it("Should calculate delta BS Call", async () => {
    let BSput = await JDMlib.delta_BS_CALL(S, K, T, r, sigma);

    BSput = ethers.BigNumber.from(BSput);
    console.log(BSput);
  });

  it("Should calculate delta BS Put", async () => {
    let BSput = await JDMlib.delta_BS_PUT(S, K, T, r, sigma);

    BSput = ethers.BigNumber.from(BSput);
    console.log(BSput);
  });

  it("Should calculate RK", async () => {
    let RK = await JDMlib.RK(r, lam, m, k, T);

    RK = ethers.BigNumber.from(RK);
    console.log(RK);
  });

  it("Should calculate sigma K", async () => {
    let SIGMA_K = await JDMlib.SIGMA_K(sigma, k, v, T);

    SIGMA_K = ethers.BigNumber.from(SIGMA_K);
    console.log(SIGMA_K);
  });

  it("Should calculate MJCnum", async () => {
    let MJCnum = await JDMlib.MJCnum(m, lam, T, k, k_fact);

    MJCnum = ethers.BigNumber.from(MJCnum);
    console.log(MJCnum);
  });

  it("Should calculate MERTON_CALL", async () => {
    const input = [S, K, T, r, sigma, m, v, lam];

    let price_delta = await JDMlib.MERTON_CALL(input);

    let price = ethers.BigNumber.from(price_delta[0]);
    let delta = ethers.BigNumber.from(price_delta[1]);
    console.log("price", price);
    console.log("delta", delta);
  });

  it("Should calculate price MERTON_CALL", async () => {
    const input = [S, K, T, r, sigma, m, v, lam];

    let price = await JDMlib.pMERTON_CALL(input);

    price = ethers.BigNumber.from(price);
    console.log("price", price);
  });

  it("Should calculate delta_MERTON_CALL", async () => {
    const input = [S, K, T, r, sigma, m, v, lam];

    let delta = await JDMlib.delta_MERTON_CALL(input);

    delta = ethers.BigNumber.from(delta);
    console.log("delta", delta);
  });

  it("Should calculate MERTON_PUT", async () => {
    const input = [S, K, T, r, sigma, m, v, lam];

    let price_delta = await JDMlib.MERTON_PUT(input);

    let price = ethers.BigNumber.from(price_delta[0]);
    let delta = ethers.BigNumber.from(price_delta[1]);
    console.log("price", price);
    console.log("delta", delta);
  });

  it("Should calculate price MERTON_PUT", async () => {
    const input = [S, K, T, r, sigma, m, v, lam];

    let price = await JDMlib.pMERTON_PUT(input);

    price = ethers.BigNumber.from(price);
    console.log("price", price);
  });

  it("Should calculate delta_MERTON_PUT", async () => {
    const input = [S, K, T, r, sigma, m, v, lam];

    let delta = await JDMlib.delta_MERTON_PUT(input);

    delta = ethers.BigNumber.from(delta);
    console.log("delta", delta);
  });
});

// describe('Correctness of computations', () => {
//   let PRICES = ['125', '175', '25', '50', '75', '100', '150'];
//   let STRIKES = ['75', '125', '50', '175', '200', '150', '100'];
//   let TIMES = ['0.89', '0.67', '0.23', '0.01', '1.11', '1.33', '0.45'];
//   let M = ['1.33', '0.67', '1.11', '0.89', '0.23', '0.45', '0.01'];
//   let V = ['1.33', '0.01', '1.11', '0.23', '0.89', '0.67', '0.45'];
//   let LAM = ['0.45', '1.33', '0.89', '0.01', '0.23', '1.11', '0.67'];
//   let SIGMA = ['1.11', '0.67', '0.23', '0.45', '0.01', '0.89', '1.33'];

//   let OUTS = [79.2068738, 73.1326067, 1.4476936, 0.0, 0.0269222, 45.5088572, 88.5227507];

//   let r = 0.1;

//   for (let i = 0; i < OUTS.length; i++) {
//     it("Should calculate price MERTON_PUT",  () => {
//       let input = [PRICES[i], STRIKES[i], TIMES[i], r, SIGMA[i], M[i], V[i], LAM[i]]

//     });
//   }
// })
