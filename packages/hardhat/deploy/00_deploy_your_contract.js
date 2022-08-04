// deploy/00_deploy_your_contract.js

const { ethers } = require("hardhat");

const localChainId = "31337";

// const sleep = (ms) =>
//   new Promise((r) =>
//     setTimeout(() => {
//       console.log(`waited for ${(ms / 1000).toFixed(3)} seconds`);
//       r();
//     }, ms)
//   );

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  console.log("deployer: ", deployer);

  await deploy("YourContract", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    // args: [
    //   ["0x6367B680d138569476dB383F288acBd157b8d44f", "0x9a5f778c5411b7a89633E7D527dEF938032BCe17"],
    //   [ethers.utils.parseEther("2"), ethers.utils.parseEther("3")],
    //   24 * 60 * 60,
    //   24 * 60 * 60,
    // ],
    log: true,
    waitConfirmations: 5,
    // value: ethers.utils.parseEther("5")
  });

  // Getting a previously deployed contract
  // const YourContract = await ethers.getContract("YourContract", deployer);
  /*  await YourContract.setPurpose("Hello");
  
    // To take ownership of yourContract using the ownable library uncomment next line and add the 
    // address you want to be the owner. 
    
    await YourContract.transferOwnership(
      "ADDRESS_HERE"
    );

    //const YourContract = await ethers.getContractAt('YourContract', "0xaAC799eC2d00C013f1F11c37E654e59B0429DF6A") //<-- if you want to instantiate a version of a contract at a specific address!
  */

  // if (chainId == localChainId) {
  //   await deployer.sendTransaction({
  //     to: "0x9a5f778c5411b7a89633E7D527dEF938032BCe17",
  //     value: ethers.utils.parseEther("10")
  //   });
  // }

  /*

  ethereum.enable()
  account = "0xe16C1623c1AA7D919cd2241d8b36d9E79C1Be2A2"
  hash = "0x1bf2c0ce4546651a1a2feb457b39d891a6b83931cc2454434f39961345ac378c"
  ethereum.request({method: "personal_sign", params: [account, hash]})
  */

  //*
  //If you want to send value to an address from the deployer
  // const hash = await YourContract.getHash(ethers.utils.parseEther("0.05"));
  // const ethhash = await YourContract.getEthSignedHash(ethers.utils.parseEther("0.05"));
  // const [_,signer] = await ethers.getSigners();  
  // const sig = await signer.signMessage(hash); /// why this the signature is different from the one signed by metamask?
  // console.log("signer address: ", await signer.getAddress());
  // console.log("hash: ", hash);
  // console.log("ethhash: ", ethhash);
  // console.log("signed message: ", sig);

  // console.log("verify: ", await YourContract.verify2(ethhash, sig));
  /*
  await deployerWallet.sendTransaction({
    to: "0x34aA3F359A9D614239015126635CE7732c18fDF3",
    value: ethers.utils.parseEther("0.001")
  })
  */

  /*
  //If you want to send some ETH to a contract on deploy (make your constructor payable!)
  const yourContract = await deploy("YourContract", [], {
  value: ethers.utils.parseEther("0.05")
  });
  */

  /*
  //If you want to link a library into your contract:
  // reference: https://github.com/austintgriffith/scaffold-eth/blob/using-libraries-example/packages/hardhat/scripts/deploy.js#L19
  const yourContract = await deploy("YourContract", [], {}, {
   LibraryName: **LibraryAddress**
  });
  */

  // Verify from the command line by running `yarn verify`

  // You can also Verify your contracts with Etherscan here...
  // You don't want to verify on localhost
  // try {
  //   if (chainId !== localChainId) {
  //     await run("verify:verify", {
  //       address: YourContract.address,
  //       contract: "contracts/YourContract.sol:YourContract",
  //       constructorArguments: [],
  //     });
  //   }
  // } catch (error) {
  //   console.error(error);
  // }
};
module.exports.tags = ["YourContract"];
