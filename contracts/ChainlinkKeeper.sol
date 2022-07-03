// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "hardhat/console.sol";

// Import chainlink

contract Keeper {
    function canExecute() public pure returns (bool) {
        return true;
    }

    function executeAutomation() public view {
        console.log("Automation submitted");
    }

    /**
     * @dev chainlink keeper checkUpkeep function to constantly check whether we need function call
     **/

    function checkUpkeep(bytes memory)
        public
        pure
        returns (bool upkeepNeeded, bytes memory)
    {
        // TODO: define the time when automated termination should come in and end the stream
        // Currently using default termination window
        upkeepNeeded = canExecute();
    }

    /**
     * @dev once checkUpKeep been triggered, keeper will call performUpKeep
     **/
    function performUpkeep(bytes calldata) external {
        (bool upkeepNeeded, ) = checkUpkeep("");
        require(
            upkeepNeeded,
            "[IP]: conditions for automated termination not met"
        );

        executeAutomation();
    }

    function createKeeperAutomation() public {
        // TODO: create variable for keeper registry contract and use it here.
        // Currently using rinkeby testnet contract address
        // IKeeperRegistry(0x409CF388DaB66275dA3e44005D182c12EeAa12A0)
        //     .registerUpkeep(address(this), uint32(2300), address(this), "");
    }
}
