import { expect } from "chai";
import { ethers } from "hardhat";
import { Greeter, Greeter__factory } from "../typechain";

describe("Greeter", function () {
    let greeterFactory: Greeter__factory;
    let greeter: Greeter;

    it("Should return the new greeting once it's changed", async function () {
        greeterFactory = await ethers.getContractFactory("Greeter");
        greeter = await greeterFactory.deploy("Hello, world!");
        await greeter.deployed();

        expect(await greeter.greet()).to.equal("Hello, world!");

        const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

        // wait until the transaction is mined
        await setGreetingTx.wait();

        expect(await greeter.greet()).to.equal("Hola, mundo!");
    });
});
