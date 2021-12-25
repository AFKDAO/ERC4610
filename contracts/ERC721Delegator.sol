// SPDX-License-Identifier: Apache

pragma solidity ^0.8.0;

import "./ERC721/ERC721.sol";
import "./IERC721Delegator.sol";

contract ERC721Delegator is ERC721, IERC721Delegator {

    // Mapping from token ID to delegator address
    mapping(uint256 => address) private _delegators;

    /** 
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
    }

    /**
     * @dev See {IERC721Delegator-delegatorOf}.
     */
    function delegatorOf(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721Delegator: delegated query for nonexistent token");
        address delegator = _delegators[tokenId];
        return delegator;
    }

    /**
     * @dev See {IERC721Delegator-setDelegator}.
     */
    function setDelegator(address delegator, uint256 tokenId) public virtual override returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        require(delegator != owner, "ERC721Delegator: setDelegator to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721Delegator: setDelegator caller is not owner nor approved for all"
        );

        _setDelegator(delegator, tokenId);
        return true;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721,IERC165) returns (bool) {
        return
            interfaceId == type(IERC721Delegator).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev Set `delegator` as the delegator of `tokenId`.
     *
     * Emits a {SetDelegator} event.
     */
    function _setDelegator(address delegator, uint256 tokenId) internal virtual {
        _delegators[tokenId] = delegator;
        emit SetDelegator(_msgSender(), delegator, tokenId);
    }

}
