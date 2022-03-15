## Summary
ERC-4610 is an extension of ERC-721 and it aims to provide standardized token rental and loanable protocol for ecological applications such as blockchain games. 
<br/>

## Specification
<br/>

### delegatorOf

Returns the delegator of ERC721.

Delegator is only an attribute of ERC721 for identification, and does not have any direct permissions like {approve}  {setApprovalForAll}  {transferFrom}  {safeTransferFrom}.

``` js
function delegatorOf(uint256 tokenId) external view returns (address);
```

### setDelegator

Set `_delegator` as the delegator of the ERC721 with tokenId as `_tokenId`.

Emits an {SetDelegator} event.

The delegator attribute can be set to address(0), which means the ERC721 has no delegator.

``` js
function setDelegator(address _delegator, uint256 _tokenId) external returns (bool);
```

### safeTransferFrom

Safely transfers `tokenId` token from `from` to `to` and `delegator` won't be cleared if `reserved` is true.

``` js
function safeTransferFrom(address from, address to, uint256 tokenId, bool reserved) external;
```

<br/>

## Implementation

see contracts/ERC4610.sol

<br/>

## How it works

Application running on the blockchain, such as blockchain game, can be defined as a state machine. Most blockchain games are based on ERC-721, that is, only the `owner` has the permission to send a valid transaction that can cause state transition, and it's inconvenience in scenarios such as lending.

![state](https://github.com/AFKDAO/ERC4610/blob/main/docs/state.png)

ERC-4610 aims to provide standardized token rental and loanable protocol for ecological applications such as blockchain games. ERC-4610 is an extension of ERC-721. In ERC-721, we use `owner` to determine who has the unique ownership of NFTs. And in ERC-4610, we added a role called `delegator`.

`delegator` has no permission to transefer or approve the token, it's a tag of ERC-721. What the `delegaotr` can do depends on the design and development of the application or game. In general, without affecting the security of assets, the `delegator` should have the same permissions as the `owner`. In this way, the `delegator` can also send a valid transaction and change the state machine.

Note that  `delegator` is only an operator of `owner` , therefore, the transaction sent by `delegator` should eventually change the state of `owner`, not `delegator`. When it comes to the transfer of assets, the `sender` should be the `owner` (not `delegator`) or other (depending on your app logic), and when the assets are to be transferred out, the `recipient` should be the `owner` or other. 

![how_it_works](https://github.com/AFKDAO/ERC4610/blob/main/docs/how_it_works.png)

The figure above shows how game or applications that are based on ERC-4610 will achieve the goal of NFTs lending and borrowing in a decentralized way. 

<br/>

## Example

In the contracts/showcase, you will see an example of how to develop your application or game based on ERC-4610. 

In the example, gold is the revenue token, and Digimon is the NFT token. There are a total of five methods involing asset flow, and these five methods will be called by the delegator.

### 1. claim

User can claim gold rewards from the Game. 

![claim](https://github.com/AFKDAO/ERC4610/blob/main/docs/claim.png)

### 2. Levelup

User can levelup his NFT level, and it will consume some gold tokens.

![levelup](https://github.com/AFKDAO/ERC4610/blob/main/docs/levelup.png)

### 3. breed

User breeds a Digimon, and will get a new Digimon NFT

![breed](https://github.com/AFKDAO/ERC4610/blob/main/docs/breed.png)

### 4. adventure

User's Digimon goes on an adventure, the NFT will transfer to game contract from owner.

![adventure](https://github.com/AFKDAO/ERC4610/blob/main/docs/adventure.png)

### 5. home

User withdraws his or her Digimon NFT.

![home](https://github.com/AFKDAO/ERC4610/blob/main/docs/home.png)

## Cautions

1. The developers of ERC-4610 should strictly distinguish between `owner` and `delegator` from `msg.sender`.  `require(_onlyOwnerOrDelegator(tokenId))` can be used instead of `require(_onlyOwner(tokenId))` for identity verification of `msg.sender` . 
2. The delegator has the permission to send a valid transaction, but does not hold or handle any related assets. When it comes to the transfer of assets, the `sender` should be the `owner` (not delegator) or other (depending on your app logic), and when the assets are to be transferred out, the `recipient` should be the `owner` or other.
3.  `delegator` should generally have no permission for functions that may cause the loss of `owner` assets, such as burning NFTs.
4. In some cases, the loan contract may not support the transfer of NFTs to the game contract or application contract. Please pay attention to this.

<br/>
