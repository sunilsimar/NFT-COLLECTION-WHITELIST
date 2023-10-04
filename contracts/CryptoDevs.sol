// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Whitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    //  _price is the price of one Crypto Dev NFT
    uint256 public constant _price = 0.01 ether;

    //max number of cryptodevs that can ever exist
    uint public constant maxTokenIds = 20;

    //whitelist contract instance
    Whitelist whitelist;

    //number of tokens reserved for whitelisted memebers
    uint public reservedTokens;
    uint public reservedTokensClaimed = 0;

    constructor(address whitelistContract) ERC721("Crypto Devs", "CD") {
        whitelist = Whitelist(whitelistContract);
        reservedTokens = whitelist.maxWhitelistedAddresses(); //this gives the no of whitelisted tokens
    }

    //totalSupply is the inbuilt function written under ERC721Enumberable.sol
    //this function returns the total tokens stored by the contract
    //return type uint256
    function mint() public payable {
        require(
            totalSupply() + reservedTokens - reservedTokensClaimed <
                maxTokenIds,
            "EXCEEDED_MAX_SUPPLY"
        );

        // If user is part of the whitelist, make sure there is still reserved tokens left

        //whitelist.whitelistedAddresses means this first whitelist is finding a whitelistedAddresses in the whitelist smart contract
        if (whitelist.whitelistedAddresses(msg.sender) && msg.value < _price) {
            // Make sure user doesn't already own an NFT
            require(balanceOf(msg.sender) == 0, "ALREADY_OWNED");

            //balanceOf function gives the total number of nft owned by the msg.sender
            reservedTokensClaimed += 1;
        } else {
            // If user is not part of the whitelist, make sure they have sent enough ETH
            require(msg.value >= _price, "NOT_ENOUGH_ETHER");
        }
        uint tokenId = totalSupply();
        _safeMint(msg.sender, tokenId);
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
