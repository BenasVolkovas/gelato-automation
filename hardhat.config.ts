import * as dotenv from "dotenv";

import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "./tasks/block-number";

dotenv.config();

const PRIVATE_KEY: string = process.env.PRIVATE_KEY || "";
const RINKEBY_URL: string = process.env.RINKEBY_URL || "";
const ETHERSCAN_API_KEY: string = process.env.ETHERSCAN_API_KEY || "";
const COINMARKETCAP_API_KEY: string = process.env.COINMARKETCAP_API_KEY || "";

const config: HardhatUserConfig = {
    solidity: "0.8.7",
    defaultNetwork: "hardhat",
    networks: {
        rinkeby: {
            chainId: 4,
            url: RINKEBY_URL || "",
            accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
        },
        localhost: {
            chainId: 31337,
            url: "http://127.0.0.1:8545/",
        },
    },
    gasReporter: {
        enabled: false,
        currency: "EUR",
        outputFile: "gas-report.txt",
        noColors: true,
        coinmarketcap: COINMARKETCAP_API_KEY,
        token: "ETH",
    },
    etherscan: {
        apiKey: ETHERSCAN_API_KEY,
    },
};

export default config;
