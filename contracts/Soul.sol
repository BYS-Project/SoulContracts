// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../interfaces/SoulKeyInterface.sol";

contract Soul is ERC721{

    /*
        Per burnare mandare all'address 0 e non al nostro Smart Contract OPPURE fare in modo che una volta scambiata una key non si possa più scambiare
        Ottimizzazione secondo idee dell'ERC721 A
        Mint Randomici !!! 
        Ottimizzazione degli uint256 in uintxyz ! 
        Sicurezza delle funzioni !! 
        Sicurezza delle funzioni che eredito da ERC721 !!!
        Fare eventi in maniera decente (in funzione _mint()) !
        FARE IN MODO CHE LE VARIABILI "particolari" VADANO BENE !!!!
        Riunione dei metadata !!!!!

        Approfondire le funzioni per alloware le persone che non so a cosa servano
    */

    // Token attributes
    uint256 internal tokenSupply;
    uint256 internal tokenMintLimit;
    uint256 internal tokenPrice;
    string internal tokenDirURI;
    // Tokens URIs
    mapping(uint256 => string) internal tokens;
    // Creator
    address internal creator;
    // SoulKey Contract Address and SoulKey Contract
    address internal soulKeyContract;
    // How many keys shoul the contract mint given an Op Soul Key
    uint256 internal opKeyMints;
    // Are Soul buyable?
    bool internal buyable;
    // Events
    event SoulMinted(uint256 _soulMinted, address _to);
    event RequestedConversion(address _to, uint256 _soulKey);
    event SoulConverted(uint256 _soulConverted, address _to);
    event SoulBuyable(bool _buyable);
    // When a contract is created it has not a soulKeyContract associated nor a buyable = true status
    constructor(uint256 _tokenMintLimit, uint256 _tokenPrice, string memory _tokenURI) ERC721("Soul", "SOU"){
        tokenMintLimit = _tokenMintLimit;
        tokenPrice = _tokenPrice;
        tokenDirURI = _tokenURI;
        creator = msg.sender;
    }
    // ""
    function mint() public payable{
        require(buyable, "You must wait before buying those Souls");
        require(tokenSupply < tokenMintLimit, "Soul were sold out!");
        require(msg.value >= tokenPrice, "You must specify a greater amount!");
        _mint(msg.sender, tokenSupply);
        tokens[tokenSupply] = string(abi.encodePacked(tokenDirURI, toString(tokenSupply)));
        emit SoulMinted(tokenSupply, msg.sender);
        tokenSupply++;
    }
    // ""
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_tokenId < tokenSupply, "The token specified does not exists!");
        require(bytes(tokens[_tokenId]).length > 0, "Cannot find the specified token");
        return tokens[_tokenId];
    }
    // Returns a soul
    function returnSoul(address _to, uint256 _tokenId) public{
        require(msg.sender == soulKeyContract, "You cannot perform this action!");
        require(buyable, "You must wait before buying those Souls");
        emit RequestedConversion(_to, _tokenId);
        _mint(_to, tokenSupply);
        emit SoulConverted(tokenSupply, _to);
        tokens[tokenSupply] = string(abi.encodePacked(tokenDirURI, "/", toString(tokenSupply), ".json"));
        tokenSupply++;
        if(SoulKey(soulKeyContract).keyType(_tokenId) == 2){
            for(uint256 i; i < SoulKey(soulKeyContract).getSoulMintedWithOpKey() - 1; i++){
                _mint(_to, tokenSupply);
                emit SoulConverted(tokenSupply, _to);
                tokens[tokenSupply] = string(abi.encodePacked(tokenDirURI, "/", toString(tokenSupply), ".json"));
                tokenSupply++;
            }
        }
    }
    // Setters
    function setSoulKeyContract(address _soulKeyContract) public{
        require(msg.sender == creator, "You cannot perform this action!");
        require(_soulKeyContract != soulKeyContract, "Same address is already specified!");
        soulKeyContract = _soulKeyContract;
    }
    function setBuyable(bool _buyable) public{
        require(msg.sender == creator, "You cannot perform this action!");
        require(_buyable != buyable, "Same value is already specified!");
        emit SoulBuyable(_buyable);
        buyable = _buyable;
    }
    // Withdraw function
    function withdraw() public{
        require(msg.sender == creator, "You cannot perform this action!");
        require(address(this).balance > 0 wei, "This contract has no funds");
        payable(creator).transfer(address(this).balance);
    }
    // Utils...
    // From: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}