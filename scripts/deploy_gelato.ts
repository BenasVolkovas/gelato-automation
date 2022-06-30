import { ethers, run } from "hardhat";

async function main() {
    const Counter = await ethers.getContractFactory("Counter");
    const arg = 60;
    const counter = await Counter.deploy(arg, {
        value: ethers.utils.parseEther("0.01"),
    });

    await counter.deployed();

    console.log("Greeter deployed to:", counter.address);
    console.log("Waiting for the transaction confirmation...");
    await counter.deployTransaction.wait(6);
    await verify(counter.address, [arg]);
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
