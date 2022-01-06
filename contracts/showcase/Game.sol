// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./interfaces/IDigimon.sol";
import "../inheritance/ERC721.sol";
import "../interfaces/IERC721Receiver.sol";
import "../interfaces/IERC4610.sol";
import "../interfaces/IERC20.sol";

contract Game is IERC721Receiver {

    struct Digimon {
        uint256 level;
    }

    // ERC4610 token address
    address private _digimon;
    // ERC20 token address
    address private _gold;

    // Mapping from tokenId to Digimon
    mapping(uint256 => Digimon) public digimons;
    
    // Mapping from tokenId to owner
    mapping(uint256 => address) public jungle;

    /**
     * @dev Initializes the contract by setting `digimon` and `gold`.
     */
    constructor(address digimon, address gold) {
        _digimon = digimon;
        _gold = gold;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    /**
     * @dev claim gold rewards
     * @notice Transfer ERC20 to NFT `owner`, not `delegator`
     */
    function claim(uint256 tokenId) external _onlyOwnerOrDelegator(tokenId) {
        uint256 rewards = 1000 * 1e18;   
        address recipient = IERC4610(_digimon).ownerOf(tokenId);
        IERC20(_gold).transfer(recipient, rewards);
    }

    /**
     * @dev spend gold to level up digimon
     * @notice Transfer ERC20 from NFT `owner`, not `delegator`
     */
    function levelUp(uint256 tokenId) external _onlyOwnerOrDelegator(tokenId) {
        address sender = IERC4610(_digimon).ownerOf(tokenId);
        IERC20(_gold).transferFrom(sender, address(this), 1000*1e18);
        Digimon storage digimon = digimons[tokenId];
        digimon.level += 1;
    }

    /**
     * @dev breed will mint a new digimon
     * @notice Transfer ERC721 to `owner`, not `delegator`
     */
    function breed(uint256 tokenId) external _onlyOwnerOrDelegator(tokenId) {
        address recipient = IERC4610(_digimon).ownerOf(tokenId);
        IDigimon(_digimon).mint(recipient, block.number);
    }

    /**
     * @dev digimon goes jungle adventure
     * @notice Transfer ERC721 from `owner`, not `delegator`
     * keep `delegator` when transferring
     */
    function adventure(uint256 tokenId) external _onlyOwnerOrDelegator(tokenId) {
        address sender = IERC4610(_digimon).ownerOf(tokenId);
        IERC4610(_digimon).safeTransferFrom(sender, address(this), tokenId, true);
        jungle[tokenId] = sender;
    }

    /**
     * @dev digimon go home from jungle
     * @notice Transfer ERC721 to `owner`, not `delegator`
     * keep `delegator` when transferring
     */
    function home(uint256 tokenId) external {
        address recipient = jungle[tokenId];
        address delegator = IERC4610(_digimon).delegatorOf(tokenId);

        require(
            msg.sender == recipient ||
            msg.sender == delegator,
            "only owner or delegator can call"
        );

        jungle[tokenId] = address(0);
        IERC4610(_digimon).safeTransferFrom(address(this), recipient, tokenId, true);
    }

    // Checks whether the msg.sender is owner or delegator
    modifier _onlyOwnerOrDelegator(uint256 tokenId) {
        require(
            msg.sender == IERC4610(_digimon).ownerOf(tokenId) || 
            msg.sender == IERC4610(_digimon).delegatorOf(tokenId),
            "only owner or delegator can call"
        );
        _;
    }

}