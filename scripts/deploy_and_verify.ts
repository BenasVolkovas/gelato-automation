import { ethers, run, network } from "hardhat";

async function main() {
    const greetingText = "Hello, Hardhat!";
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy(greetingText);

    await greeter.deployed();

    console.log("Greeter deployed to:", greeter.address);
    if (network.config.chainId === 4 && process.env.ETHERSCAN_API_KEY) {
        console.log("Waiting for the transaction confirmation...");
        await greeter.deployTransaction.wait(6);
        await verify(greeter.address, [greetingText]);
    }
}

const verify = async (contractAddress: string, args: any[]) => {
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
};

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
