import { ethers, run, network } from "hardhat";
import { verify } from "./helper_functions";

async function main() {
    if (network.config.chainId === 4) {
        const gelatoFactory = await ethers.getContractFactory("Gelato");

        // rinkeby chain chainId
        const gelatoAddress = "0x8c089073a9594a4fb03fa99feee3efff0e2bc58a"; // rinkeby
        const gelato = await gelatoFactory.deploy(gelatoAddress, {
            value: ethers.utils.parseEther("0.01"),
        });

        await gelato.deployed();

        console.log("Gelato contract deployed to:", gelato.address);
        console.log("Waiting for the transaction confirmation...");
        await gelato.deployTransaction.wait(6);
        await verify(gelato.address, [gelatoAddress]);
    } else {
        console.log("Error: Not a rinkeby network.");
    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
