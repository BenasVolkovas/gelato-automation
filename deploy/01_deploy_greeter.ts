import { network } from "hardhat";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const deployGreeter: DeployFunction = async (
    hre: HardhatRuntimeEnvironment
) => {
    // @ts-ignore
    const { getNamedAccounts, deployments } = hre;
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();
    const chainId = network.config.chainId;

    const greeter = await deploy("Greeter", {
        from: deployer,
        args: ["Good morning!"],
        log: true,
    });
};

export default deployGreeter;
