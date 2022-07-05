// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface IGelatoOps {
    function createTask(
        address _execAddress,
        bytes4 _execSelector,
        address _resolverAddress,
        bytes calldata _resolverData
    ) external returns (bytes32 task);

    function getFeeDetails() external view returns (uint256, address);

    function gelato() external view returns (address payable);
}
