import { task } from "hardhat/config";

task("block-number", "Prints the current block number").setAction(
    async (taskArgs, hre) => {
        const blockNum = await hre.ethers.provider.getBlockNumber();
        console.log(`Current block number is: ${blockNum}`);
    }
);

module.exports = {};
