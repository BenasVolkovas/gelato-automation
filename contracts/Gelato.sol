// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {IGelatoOps} from "./interfaces/IGelatoOps.sol";

import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Gelato {
    uint256 public lastExecuted;
    uint256 public count;
    IGelatoOps public gelatoOps;
    address payable public gelato;

    // solhint-disable not-rely-on-time
    constructor(IGelatoOps _gelatoOps) payable {
        gelatoOps = _gelatoOps;
        gelato = gelatoOps.gelato();
        lastExecuted = block.timestamp;

        startGelatoTask();
    }

    modifier canGelatoTerminateMilestoneFinal() {
        require(
            canGelatoTerminateMilestoneStreamFinal(),
            "[IP]: gelato cannot terminate stream for this milestone"
        );
        _;
    }

    function canGelatoTerminateMilestoneStreamFinal()
        public
        view
        returns (bool)
    {
        return ((block.timestamp - lastExecuted) > 180);
    }

    function gelatoChecker()
        external
        view
        returns (bool canExec, bytes memory execPayload)
    {
        // Check if gelato can terminate stream of current milestone
        canExec = canGelatoTerminateMilestoneStreamFinal();

        execPayload = abi.encodeWithSelector(
            this.gelatoTerminateMilestoneStreamFinal.selector
        );
    }

    function startGelatoTask() public {
        // Register task to run it automatically
        gelatoOps.createTask(
            address(this),
            this.gelatoTerminateMilestoneStreamFinal.selector,
            address(this),
            abi.encodeWithSelector(this.gelatoChecker.selector)
        );
    }

    // solhint-disable not-rely-on-time
    function gelatoTerminateMilestoneStreamFinal()
        public
        canGelatoTerminateMilestoneFinal
    {
        lastExecuted = block.timestamp;
        count += 1;

        uint256 fee;
        address feeToken;

        (fee, feeToken) = gelatoOps.getFeeDetails();

        _gelatoTransfer(fee, feeToken);
    }

    function _gelatoTransfer(uint256 _amount, address _paymentToken) internal {
        if (_paymentToken == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
            // If ETH address
            (bool success, ) = gelato.call{value: _amount}("");
            require(success, "_gelatoTransfer: ETH transfer failed");
        } else {
            // Else it is ERC20 token
            SafeERC20.safeTransfer(IERC20(_paymentToken), gelato, _amount);
        }
    }

    event Fee(uint256 fee, address feeToken);

    function getFeeInfo() public {
        uint256 fee;
        address feeToken;

        (fee, feeToken) = gelatoOps.getFeeDetails();

        emit Fee(fee, feeToken);
    }

    // Enable smart contract to receive tokens
    receive() external payable {}
}
