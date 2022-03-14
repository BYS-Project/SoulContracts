// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Soul is ERC721{

    // To be discussed
    /*
        1) URI choosen from the user or from the contact?
        Optimize code. F.e. not all the functions are going to be needed on the final smart contract. Discuss them before the upload on mainnet
        Guardare OpenSea se supporta solo contratti ERC o anche custom
    */

    uint256 internal tokenSupply;
    uint256 internal tokenBound;
    uint256 internal tokenPrice;
    mapping(uint256 => string) internal tokens;
    address internal creator;
    address internal soulKeyContractAddress;

    constructor() ERC721("Soul", "SOU"){
        creator = msg.sender;
    }

    // MINT DEVE AVERE IL PREZZO DI UN SOUL
    function mint(address _to, string memory _uri) public payable{
        require(tokenSupply < tokenBound, "Normal sold out!");
        require(msg.value >= tokenPrice, "You must specify a greater amount!");
        _mint(_to, tokenSupply);
        tokens[tokenSupply] = _uri;
        tokenSupply++;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_tokenId < tokenSupply, "The token specified does not exists!");
        require(bytes(tokens[_tokenId]).length > 0, "Cannot find the specified token");
        return tokens[_tokenId];
    }

    function returnSoul(address _to) public {
        // REQUIRE CHE IL TOKEN LO ABBIA IO
        _mint(_to, tokenSupply);
        tokens[tokenSupply] = "ipfs://QmUc7QARN2a5fYv1zfMRvEvAo6fZFqwp4LPnPMnXhVjmYU";
        tokenSupply++;
    }
    
}