import { ethers } from "hardhat";

async function main() {
    const accounts = await ethers.getSigners();
    const deployer = accounts[0];
    const investorA = accounts[1];

    const tokensToMint = ethers.utils.parseEther("1");

    const holderFactory = await ethers.getContractFactory("ERC1155TokenHolder");
    const tokenHolder = await holderFactory.deploy();
    await tokenHolder.deployed();

    const erc1155TokenFactory = await ethers.getContractFactory("ERC1155Token");
    const erc1155Token = erc1155TokenFactory.attach(tokenHolder.TOKEN());

    const id = await tokenHolder.id();

    await tokenHolder.connect(investorA).mintTokens(tokensToMint);

    await erc1155Token.connect(investorA).setApprovalForAll(id, true);

    await tokenHolder.connect(investorA).transferTokens(id, tokensToMint);

    const holderBalance = await tokenHolder.contractBalance(
        tokenHolder.address
    );

    const investorBalance = await tokenHolder.contractBalance(
        investorA.address
    );

    console.log(holderBalance);
    console.log(investorBalance);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
