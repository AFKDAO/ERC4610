// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../inheritance/ERC20.sol";

// revenue token
contract Gold is ERC20 {

    constructor(uint256 initialSupply) ERC20("Gold", "Gold") {
        _mint(msg.sender, initialSupply);
    }

}