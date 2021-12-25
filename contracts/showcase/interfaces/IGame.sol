// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IGame {

    /**
     * @dev The Owner or Delegator call the digimon to work.
     * @notice No asset transfer occurs
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     */
    function work(uint256 tokenId) external returns (bool);

    /**
     * @dev The Owner or Delegator call the digimon to quit work.
     * @notice No asset transfer occurs.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     */
    function quit(uint256 tokenId) external returns (bool);

    /**
     * @dev The Owner or Delegator claims salary after quitting work.
     * @notice Transfers ERC20 to recipient.
     *
     * ATTENTION: `recipient` should be owner if msg.sender == delegator.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     */
    function claim(uint256 tokenId) external returns (bool);

    /**
     * @dev The Owner or Delegator breeds the digimon.
     * @notice Transfers ERC721 to recipient.
     *
     * ATTENTION: `recipient` should be owner if msg.sender == delegator.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     */
    function breed(uint256 tokenId) external returns (bool);

    /**
     * @dev The Owner or Delegator send the digimon to evolution lab for leveling up.
     * @notice Transfers ERC721 to game contract.
     *
     * ATTENTION: `operator` should be owner if msg.sender == delegator.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     */
    function evolution(uint256 tokenId) external returns (bool);

    /**
     * @dev The Owner or Delegator recall the digimon from evolution lab.
     * @notice Transfers ERC721 from game contract to recipient.
     * 
     * ATTENTION: `recipient` should be owner if msg.sender == delegator.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     */
    function recall(uint256 tokenId) external returns (bool);

    




}