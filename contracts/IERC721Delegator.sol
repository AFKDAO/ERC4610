// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721/IERC721.sol";

interface IERC721Delegator is IERC721 {

    /**
     * @dev Emitted when `owner` or `approved account` enables `setDelegator` to manage the `tokenId` token.
     */
    event SetDelegator(address indexed caller, address indexed delegator, uint256 indexed tokenId);

    /**
     * @dev Set or remove `delegator` for the owner.
     * The delegator has no direct permission, just an additional attribute.
     *
     * Requirements:
     *
     * - The `delegator` cannot be the caller.
     * - `tokenId` must exist.
     *
     * Emits an {SetDelegator} event.
     */
    function setDelegator(address delegator, uint256 tokenId) external returns (bool);

    /**
     * @dev Returns the delegator of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function delegatorOf(uint256 tokenId) external view returns (address);

}