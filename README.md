# Summary
ERC4610 is an extension of ERC721. With ERC4610, ERC721 can be loaned and borrowed while the lender only has the right to use, but cannot transfer the assets.



# Specification



## Methods



### delegatorOf

Returns the delegator of an ERC721.

**Attention:** Delegator is only an attribute of ERC721 for identification, and does not have any direct permissions like {approve}  {setApprovalForAll}  {transferFrom}  {safeTransferFrom}.

``` js
function delegatorOf(uint256 tokenId) external view returns (address);
```



### setDelegator

Set `_delegator` as the delegator of the ERC721 with tokenId as `_tokenId`.

**Attention:** The delegator attribute can be set to address(0), which means the ERC721 has no delegator.

``` js
function setDelegator(address _delegator, uint256 _tokenId) external returns (bool);
```



### safeTransferFrom

Safely transfers `tokenId` token from `from` to `to` and `delegator` won't be cleared if `reserved` is true.

``` js
function safeTransferFrom(address from, address to, uint256 tokenId, bool reserved) external;
```



# Implementation

see contracts/ERC4610.sol



# Notice

The developers of ERC4610 interface should strictly distinguish between `owner` and `delegator` from `msg.sender`. The delegator is always an attribute (like a tag) for identification, and does not hold or handle any related assets.

That means, use `require(_onlyOwnerOrDelegator(tokenId))` instead of `require(_onlyOwner(tokenId))` for identity verification of `msg.sender` . When it comes to the transfer of assets, the `sender` should be the `owner` (not delegator) or other (depending on your game logic), and when the assets are to be transferred out, the `recipient` should be the `owner` or other.

Warn: If there is an NFT burning function in the game logic, please make sure the caller is the owner, otherwise it may cause losses to the owner.
