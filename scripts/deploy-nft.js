const hre = require("hardhat");
 
//whitelist contract address
const contractAddress = "0xc8e924625E12a9f61A7633CbFa2bF326E03173a3";

async function sleep(ms){
    return new Promise((resolve)=>
        setTimeout(resolve,ms));
}

async function main(){
    const nftContract = await hre.ethers.deployContract("CryptoDevs",[contractAddress]);

    await nftContract.waitForDeployment();

    console.log("NFT Contract Address:",nftContract.target);

    await sleep(30*1000); // 30s

    await hre.run("verify:verify",{
        address: nftContract.target,
        constructorArguments:[contractAddress],
    });
}

main()
    .then(()=> process.exit(0))
    .catch((error)=>{
        console.log(error);
        process.exit(1);
    });

