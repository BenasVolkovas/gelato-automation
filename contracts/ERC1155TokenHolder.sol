// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "./ERC1155Token.sol";

contract ERC1155TokenHolder is ERC1155Holder {
    ERC1155Token public immutable TOKEN;
    uint256 public constant id = 1;

    constructor() {
        TOKEN = new ERC1155Token();
    }

    function mintTokens(uint256 _amount) public {
        TOKEN.mint(msg.sender, id, _amount, "");
    }

    function transferTokens(uint256 _amount) public {
        TOKEN.safeTransferFrom(msg.sender, address(this), id, _amount, "");
    }

    function mintForContract(uint256 _amount) public {
        TOKEN.mint(address(this), id, _amount, "");
    }

    function tokensBalance(address _account) public view {
        TOKEN.balanceOf(_account, id);
    }
}
