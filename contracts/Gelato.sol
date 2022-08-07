// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {IGelatoOps} from "./interfaces/IGelatoOps.sol";
import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Gelato {
    address payable public immutable gelato;
    IGelatoOps public gelatoOps;
    address public gelatoFeeToken;
    uint256 public lastExecuted;
    uint256 public count;

    // solhint-disable not-rely-on-time
    constructor(IGelatoOps _gelatoOps, address _token) payable {
        gelatoOps = _gelatoOps;
        gelato = gelatoOps.gelato();
        gelatoFeeToken = _token;
        lastExecuted = block.timestamp;

        startGelatoTask();
    }

    modifier canGelatoIncreaseCount() {
        require(canIncreaseCount(), "Not enough time has passed.");
        _;
    }

    function canIncreaseCount() public view returns (bool) {
        return ((block.timestamp - lastExecuted) > 180);
    }

    function startGelatoTask() public {
        // Register task to run it automatically
        gelatoOps.createTaskNoPrepayment(
            address(this),
            this.gelatoIncreaseCount.selector,
            address(this),
            abi.encodeWithSelector(this.gelatoChecker.selector),
            gelatoFeeToken
        );
    }

    function gelatoChecker()
        external
        view
        returns (bool canExec, bytes memory execPayload)
    {
        // Check if gelato can terminate stream of current milestone
        canExec = canIncreaseCount();

        execPayload = abi.encodeWithSelector(this.gelatoIncreaseCount.selector);
    }

    function gelatoIncreaseCount() public canGelatoIncreaseCount {
        uint256 fee;
        address feeToken;

        lastExecuted = block.timestamp;
        count += 1;

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

    // Enable smart contract to receive tokens
    receive() external payable {}
}
