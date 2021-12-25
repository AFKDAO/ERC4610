// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../ERC721/ERC721.sol";
import "../IERC721Delegator.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/IGame.sol";
import "./interfaces/IDigimon.sol";

contract Game is IGame, IERC721Receiver {

    struct Digimon {
        uint256 parentId;
        uint256 workDay;
        uint256 level;
        bool isWorking;
    }

    // ERC721 token, full name => DigitalMonster
    address private _digimon;
    // ERC20 token
    address private _energy;

    // Mapping from tokenId to Digimon
    mapping(uint256 => Digimon) private _digimons;
    
    // Mapping from tokenId to owner
    mapping(uint256 => address) private _labs;

    /**
     * @dev Initializes the contract by setting a `digimon` and a `energy`.
     */
    constructor(address digimon, address energy) {
        _digimon = digimon;
        _energy = energy;
    }

    // work can earn energy(ERC20)
    function work(uint256 tokenId) external override returns (bool) {
        require(_onlyOwnerOrDelegator(tokenId),"Game: only owner or delegator can call");
        Digimon memory digimon = _digimons[tokenId];
        digimon.isWorking = true;
        digimon.workDay += 1;
        _digimons[tokenId] = digimon;
        return true;
    }

    // quit work
    function quit(uint256 tokenId) external override returns (bool) {
        require(_onlyOwnerOrDelegator(tokenId),"Game: only owner or delegator can call");
        Digimon memory digimon = _digimons[tokenId];
        digimon.isWorking = false;
        _digimons[tokenId] = digimon;
        return true;
    }

    // claim earned energy(ERC20)
    function claim(uint256 tokenId) external override returns (bool) {
        require(_onlyOwnerOrDelegator(tokenId),"Game: only owner or delegator can call");
        uint256 salary = 1000 * _digimons[tokenId].workDay * 1e18;
        
        // energy(ERC20) should be transfered to owner, not delegator
        IERC20(_energy).transfer(_getOwnerIfDelegator(tokenId), salary);
        return true;
    }

    // breed will mint a new digimon(ERC721Delegator)
    function breed(uint256 tokenId) external override returns (bool) {
        require(_onlyOwnerOrDelegator(tokenId),"Game: only owner or delegator can call");
        uint256 childTokenId = tokenId + 100; 
        
        // new digimon(ERC721Delegator) token should be transfered to owner, not delegator
        IDigimon(_digimon).mint(_getOwnerIfDelegator(tokenId), childTokenId);
        return true;
    }

    // evolution costs energy(ERC20) tokens
    function evolution(uint256 tokenId) external override returns (bool) {
        require(_onlyOwnerOrDelegator(tokenId),"Game: only owner or delegator can call");
        
        // sender should be owner, not delegator
        address sender = _getOwnerIfDelegator(tokenId);
        
        // energy(ERC20) tokens should be transfered from owner, not delegator
        IERC20(_energy).transferFrom(sender, address(this), 1000);
        
        // digimon(ERC721Delegator) token should be transfered from owner, not delegator
        IERC721Delegator(_digimon).safeTransferFrom(sender,address(this),tokenId);
        _labs[tokenId] = sender;
        return true;
    }

    function recall(uint256 tokenId) external override returns (bool) {
        require(_onlyOwnerOrDelegator(tokenId),"Game: only owner or delegator can call");
       
        // digimon(ERC721Delegator) token should be transfered to owner, not delegator
        IERC721Delegator(_digimon).safeTransferFrom(address(this),_labs[tokenId],tokenId);
        
        Digimon memory digimon = _digimons[tokenId];
        digimon.level += 1;
        _digimons[tokenId] = digimon;
        return true;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // Checks whether the msg.sender is owner or delegator
    function _onlyOwnerOrDelegator(uint256 tokenId) internal view virtual returns (bool) {
        return 
            msg.sender == IERC721Delegator(_digimon).ownerOf(tokenId) || 
            msg.sender == IERC721Delegator(_digimon).delegatorOf(tokenId);
    }

    // Get owner if the msg.sender is delegator
    function _getOwnerIfDelegator(uint256 tokenId) internal view virtual returns (address) {
        address recipient = msg.sender;
        if (msg.sender == IERC721Delegator(_digimon).delegatorOf(tokenId)) {
            recipient = IERC721Delegator(_digimon).ownerOf(tokenId);
        }
        return recipient;
    }


    

}