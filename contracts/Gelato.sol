// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Counter {
    /**
     * Public counter variable
     */
    uint public counter;

    /**
     * Use an interval in seconds and a timestamp to slow execution of Upkeep
     */
    uint public immutable interval;
    uint public lastTimeStamp;

    constructor(uint updateInterval) payable {
        interval = updateInterval;
        lastTimeStamp = block.timestamp;

        counter = 0;
    }

    function checkUpkeep() external view returns (bool upkeepNeeded) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
    }

    function performUpkeep() external {
        require((block.timestamp - lastTimeStamp) > interval);
        lastTimeStamp = block.timestamp;
        counter = counter + 1;
    }
}
