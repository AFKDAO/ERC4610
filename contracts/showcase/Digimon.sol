// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../ERC721Delegator.sol";
import "./interfaces/IDigimon.sol";

contract Digimon is ERC721Delegator, IDigimon {

    constructor(string memory name_, string memory symbol_) ERC721Delegator(name_, symbol_) {
    }

    function mint(address to, uint256 tokenId) external override {
        _mint(to, tokenId);
    }

}