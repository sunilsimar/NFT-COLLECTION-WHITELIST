//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Whitelist {
    // Max number of whitelisted addresses allowed
    uint8 public maxWhitelistedAddresses;

    // Create a mapping of whitelistedAddresses
    // if an address is whitelisted, we would set it to true,
    // it is false by default for all other addresses

    mapping(address => bool) public whitelistedAddresses;

    // numAddressesWhitelisted would be used to keep track of
    //  how many addresses have been whitelisted
    uint8 public numAddressesWhitelisted;

    constructor(uint8 _maxWhitelistedAddresses) {
        maxWhitelistedAddresses = _maxWhitelistedAddresses;
    }

    function addAdressToWhitelist() public {
        require(
            !whitelistedAddresses[msg.sender],
            "Sender has already been whitelisted"
        );

        require(
            numAddressesWhitelisted < maxWhitelistedAddresses,
            "More address cant be added, limit reached"
        );

        whitelistedAddresses[msg.sender] = true;

        numAddressesWhitelisted++;
    }
}
