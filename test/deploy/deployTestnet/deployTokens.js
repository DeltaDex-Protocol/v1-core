async function main() {
  const deployer = await ethers.getSigners();

  console.log(deployer[0].address);

  // console.log("Deploying contracts with the account:", deployer.address);
  // console.log("Account balance:", (await deployer.getBalance()).toString());

  // DEPLOYING //
  // DAI
  const DAI = await ethers.getContractFactory("DeltaDexDAI", {
    deployer: deployer[0],
  });
  sDAI = await DAI.deploy();
  await sDAI.deployed();

  // WETH
  const WETH = await ethers.getContractFactory("DeltaDexWETH", {
    deployer: deployer[0],
  });
  sWETH = await WETH.deploy();
  await sWETH.deployed();

  console.log("DAI address", sDAI.address);
  console.log("WETH address", sWETH.address);

  const user_DAI_balance = await sDAI.balanceOf(deployer[0].address);
  const user_WETH_balance = await sWETH.balanceOf(deployer[0].address);

  console.log("User DAI balance", user_DAI_balance);
  console.log("User WETH balance", user_WETH_balance);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
