import { ethers, run, network } from "hardhat";

export const verify = async (contractAddress: string, args: any[]) => {
    if (network.config.chainId === 4 && process.env.ETHERSCAN_API_KEY) {
        console.log("Verifying contract...");
        try {
            await run("verify:verify", {
                address: contractAddress,
                constructorArguments: args,
            });
        } catch (e: any) {
            if (e.message.toLowerCase().includes("already verified")) {
                console.log("Already verified!");
            } else {
                console.log(e);
            }
        }
    }
};
