import { ethers, run } from "hardhat";

async function main() {
    const gelatoFactory = await ethers.getContractFactory("Gelato");
    const gelatoAddress = "0x8c089073a9594a4fb03fa99feee3efff0e2bc58a"; // rinkeby
    const gelato = await gelatoFactory.deploy(gelatoAddress, {
        value: ethers.utils.parseEther("0.01"),
    });

    await gelato.deployed();

    console.log("Greeter deployed to:", gelato.address);
    console.log("Waiting for the transaction confirmation...");
    await gelato.deployTransaction.wait(6);
    await verify(gelato.address, [gelatoAddress]);
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
