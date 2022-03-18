// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../interfaces/SoulInterface.sol";

contract SoulKey is ERC721{
    // Key Supply
    uint256 internal normalMinted;
    uint256 internal opMinted;
    // Key URIs
    string internal keysURI;
    // Key prices
    uint256 internal normalPrice;
    uint256 internal opPrice;
    // Ket mint limits
    uint256 internal normalMintLimit;
    uint256 internal opMintLimit;
    // How many soul have to be minted with an op key?
    uint256 internal soulMintedWithOpKey;
    // Owner of the Contract
    address internal creator;
    // Token URIs
    mapping(uint256 => string) internal tokens;
    // Soul Contract address and Soul Contract
    address internal soulContract;
    // Are Soul Keys buyable?
    bool internal buyable;
    // Events
    event NormalMinted(uint256 normalKeyMinted, address to);
    event OpMinted(uint256 opKeyMinted, address to);
    event ConvertedToSoul(uint256 fromSoulKey, address fromAddress);
    event SoulBuyable(bool _buyable);
    // When a contract is created it has not a soulContract associated nor a buyable = true status
    constructor(string memory _keysURI, uint256 _normalPrice, uint256 _opPrice, uint256 _normalMintLimit, uint256 _opMintLimit, uint256 _soulMintedWithOpKey) ERC721("Soul Key", "SOUK"){
        keysURI = _keysURI;
        normalPrice = _normalPrice;
        opPrice = _opPrice;
        normalMintLimit = _normalMintLimit;
        opMintLimit = _opMintLimit;
        soulMintedWithOpKey = _soulMintedWithOpKey;
        creator = msg.sender;
        buyable = false;
    }
    // Mint functions
    function mintSKN() public payable{
        require(buyable, "You must wait before buying those keys");
        require(normalMinted < normalMintLimit, "Normal Keys were sold out!");
        require(msg.value >= normalPrice, "You must specify a greater amount!");
        _mint(msg.sender, normalMinted + opMinted);
        tokens[normalMinted + opMinted] = string(abi.encodePacked(keysURI, "/", toString(normalMinted), "_normal.json"));
        emit NormalMinted(normalMinted + opMinted, msg.sender);
        normalMinted++;
    }
    function mintSKOP() public payable{
        require(buyable, "You must wait before buying those keys");
        require(normalMinted < opMintLimit, "Op Keys were sold out!");
        require(msg.value >= opPrice, "You must specify a greater amount!");
        _mint(msg.sender, normalMinted + opMinted);
        tokens[normalMinted + opMinted] = string(abi.encodePacked(keysURI, "/", toString(opMinted), "_op.json"));
        emit OpMinted(normalMinted + opMinted, msg.sender);
        opMinted++;
    }
    // TokenURI function, used by OpenSea
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_tokenId < normalMinted + opMinted, "The specified token does not exists!");
        require(bytes(tokens[_tokenId]).length > 0, "Cannot find the specified token");
        return tokens[_tokenId];
    }
    // Converts the Key NFT into a Soul NFT
    function convertToSoul(uint256 _tokenId) public {
        require(soulContract != address(0), "A Soul Smart Contract is not specified yet!");
        require(_tokenId < normalMinted + opMinted, "The specified token does not exists!");
        require(_isApprovedOrOwner(msg.sender, _tokenId), "ERC721: transfer caller is not owner nor approved");
        transferFrom(msg.sender, soulContract, _tokenId);
        // From è utile?
        Soul(soulContract).returnSoul(msg.sender, _tokenId);
        emit ConvertedToSoul(_tokenId, msg.sender);
    }
    // Is the key specified a normal or an op one?
    /*
        1  = Normal
        2  = Op
        0 = Error
    */
    function keyType(uint256 _tokenId) public view returns (uint256){
        require(_tokenId < normalMinted + opMinted, "The specified token does not exists!");
        if(contains(tokens[_tokenId], "_normal")){
            return 1;
        }else if(contains(tokens[_tokenId], "_op")){
            return 2;
        }else{
            return 0;
        }
    }
    // Getters
    function getSupply() public view returns (uint256){
        return normalMinted + opMinted;
    }
    function getNormalMinted() public view returns (uint256){
        return normalMinted;
    }
    function getOpMinted() public view returns (uint256){
        return opMinted;
    }
    function getSoulMintedWithOpKey() public view returns (uint256){
        return soulMintedWithOpKey;
    }
    // Setters
    function setSoulContract(address _soulContract) public{
        require(msg.sender == creator, "You cannot perform this action!");
        soulContract = _soulContract;
    }
    function setBuyable(bool _buyable) public{
        require(msg.sender == creator, "You cannot perform this action!");
        emit SoulBuyable(_buyable);
        buyable = _buyable;
    }

    // Utils...
    // Is a string equal to another?
    function equals(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
    // Does a string contain another one?
    function contains(string memory main, string memory subString) internal pure returns (bool){
        require(bytes(main).length >= bytes(subString).length, "Error in string comparsions");
        if(bytes(main).length == bytes(subString).length){
            return equals(main, subString);
        }else{
            for(uint256 i; i < bytes(main).length - bytes(subString).length; i++){
                if(equals(subString, getSlice(i, bytes(subString).length + i, main))){
                    return true;
                }
            }
            return false;
        }
    }
    // From: https://ethereum.stackexchange.com/questions/52246/solidity-extracting-slicing-characters-from-a-string
    function getSlice(uint256 begin, uint256 end, string memory text) public pure returns (string memory) {
        bytes memory a = new bytes(end - begin);
        for(uint256 i; i < end - begin; i++){
            a[i] = bytes(text)[begin + i];
        }
        return string(a);    
    }
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

    // Withdraw function
    function withdraw() public{
        require(msg.sender == creator, "You cannot perform this action!");
        require(address(this).balance > 0 wei, "This contract has no funds");
        payable(creator).transfer(address(this).balance);
    }
}