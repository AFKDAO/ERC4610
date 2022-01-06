// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../ERC4610.sol";

// Digital Monster Game Asset
contract Digimon is ERC4610 {

    constructor(string memory name_, string memory symbol_) ERC4610(name_, symbol_) {
    }

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }

}