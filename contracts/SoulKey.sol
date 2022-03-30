// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721_bys.sol";
import "../interfaces/SoulInterface.sol";
import "../interfaces/UtilsInterface.sol";

contract SoulKey is ERC721_bys{
    // Key prices
    uint private normalPrice;
    uint private opPrice;
    // Keys mint limits
    uint private normalMintLimit;
    uint private opMintLimit;
    // How many soul have to be minted with an op key?
    uint private soulMintedWithOpKey;
    // Soul Contract address and Soul Contract
    address private soulContract;
    // Are Soul Keys setContractOnline?
    bool private contractOnline;
    // Utils Address
    address private utils;
    // Token URIs
    mapping(uint => uint) private tokens;
    mapping(uint=> bool) private burnedKeys;
    // Mint limit for addresses
    uint private maximumNormalForAddress;
    uint private maximumOpForAddress;
    // Events
    event SoulContractOnline(bool _newStatus);
    // When a contract is created it has not a soulContract associated nor a contractOnline = true status
    constructor(string memory _baseURI, uint _normalPrice, uint _opPrice, uint _normalMintLimit, uint _opMintLimit, uint _soulMintedWithOpKey, address _utils, 
    uint _maximumNormalForAddress, uint _maximumOpForAddress) ERC721_bys("Soul Key", "SOUK"){
        baseURI = _baseURI;
        normalPrice = _normalPrice;
        opPrice = _opPrice;
        normalMintLimit = _normalMintLimit;
        opMintLimit = _opMintLimit;
        soulMintedWithOpKey = _soulMintedWithOpKey;
        utils = _utils;
        maximumNormalForAddress = _maximumNormalForAddress;
        maximumOpForAddress = _maximumOpForAddress;
        contractCreator = msg.sender;
    }
    // Mint functions
    function mintSKN(uint amount) public payable{
        require(contractOnline, "You must wait before buying those keys");
        require(amount > 0, "The amount must be greater than zero");
        require(getNormalMinted() <= normalMintLimit, "Normal Keys were sold out!");
        require(getNormalMinted() + amount <= normalMintLimit, "Plase, specify a lower amount of tokens to mint");
        require(normalBalanceOf(msg.sender) + amount <= maximumNormalForAddress, "You cannot buy this amount of keys!");
        require(msg.value >= normalPrice * amount, "You must specify a greater amount!");
        _mint(msg.sender, amount);

        tokens[tokenSupply - 1] = 1;
    }
    function mintSKOP(uint amount) public payable{
        require(contractOnline, "You must wait before buying those keys");
        require(amount > 0, "The amount must be greater than zero");
        require(getOpMinted() <= opMintLimit, "OP Keys were sold out!");
        require(getOpMinted() + amount <= opMintLimit, "Plase, specify a lower amount of tokens to mint");
        require(opBalanceOf(msg.sender) + amount <= maximumOpForAddress, "You cannot buy this amount of keys!");
        require(msg.value >= opPrice * amount, "You must specify a greater amount!");
        _mint(msg.sender, amount);
        
        tokens[tokenSupply - 1] = 2;
    }


    // TokenURI function, used by OpenSea
    function tokenURI(uint _tokenId) public view override returns (string memory) {
        require(_tokenId < tokenSupply, "The specified token does not exists!");
        if(keyType(_tokenId) == 1){
            return string(abi.encodePacked(baseURI, "/", BYS_Utils(utils).toString(_tokenId), "_normal", ".json"));
        }else if(keyType(_tokenId) == 2){
            return string(abi.encodePacked(baseURI, "/", BYS_Utils(utils).toString(_tokenId), "_op", ".json"));
        }
        return "";
    }


    // Converts the Key NFT into a Soul NFT
    function convertToSoul(uint _tokenId) public {
        require(soulContract != address(0), "A Soul Smart Contract is not specified yet!");
        require(_tokenId < tokenSupply, "The specified token does not exists!");
        require(burnedKeys[_tokenId] == false, "This key was already used");
        require(_isApprovedOrOwner(msg.sender, _tokenId), "ERC721: transfer caller is not owner nor approved");
        transferFrom(msg.sender, soulContract, _tokenId);
        Soul(soulContract).returnSoul(msg.sender, _tokenId);
        burnedKeys[_tokenId] = true;
    }

    // Is the key specified a normal or an op one?
    /*
        1  = Normal
        2  = Op
        0 = Error
    */
    function keyType(uint _tokenId) public view returns (uint){
        require(_tokenId < tokenSupply, "The specified token does not exists!");
        for(uint i = _tokenId; i < tokenSupply; i++){
            if(tokens[i] == 1){
                return 1;
            }else if(tokens[i] == 2){
                return 2;
            }
        }
        return 0;
    }

    // Getters
    function getNormalMinted() public view returns (uint){
        uint normalMinted;
        uint currentMinted;
        for(uint i; i < tokenSupply; i++){
            currentMinted++;
            if(tokens[i] != 0){
                if(tokens[i] == 1){
                    normalMinted += currentMinted;
                }
                currentMinted = 0;
            }
        }
        return normalMinted;
    }
    function getOpMinted() public view returns (uint){
        uint opMinted;
        uint currentMinted;
        for(uint i; i < tokenSupply; i++){
            currentMinted++;
            if(tokens[i] != 0){
                if(tokens[i] == 2){
                    opMinted += currentMinted;
                }
                currentMinted = 0;
            }
        }
        return opMinted;
    }
    function normalBalanceOf(address _address) public view returns (uint){
        uint currentBalance;
        uint balance;
        for(uint i; i < tokenSupply; i++){
            if(ownerOf(i) == _address){
                if(tokens[i] == 0 || tokens[i] == 1){
                    currentBalance++;
                    if(tokens[i] == 1){
                        balance += currentBalance;
                        currentBalance = 0;
                    }
                }
                else if(tokens[i] == 2){
                    currentBalance = 0;
                }
            }
        }
        return balance;
    }
    function opBalanceOf(address _address) public view returns (uint){
        uint currentBalance;
        uint balance;
        for(uint i; i < tokenSupply; i++){
            if(ownerOf(i) == _address){
                if(tokens[i] == 0 || tokens[i] == 2){
                    currentBalance++;
                    if(tokens[i] == 2){
                        balance += currentBalance;
                        currentBalance = 0;
                    }
                }
                else if(tokens[i] == 1){
                    currentBalance = 0;
                }
            }
        }
        return balance;
    }
    function getSoulMintedWithOpKey() public view returns (uint){
        return soulMintedWithOpKey;
    }

    // Setters
    function setSoulContract(address _soulContract) public{
        require(msg.sender == contractCreator, "You cannot perform this action!");
        require(_soulContract != soulContract, "The specified contract already exists");
        soulContract = _soulContract;
    }
    function setContractOnline(bool _contractOnline) public{
        require(msg.sender == contractCreator, "You cannot perform this action!");
        require(_contractOnline != contractOnline, "This value is already specified");
        emit SoulContractOnline(_contractOnline);
        contractOnline = _contractOnline;
    }
    // Withdraw function
    function withdraw() public{
        require(msg.sender == contractCreator, "You cannot perform this action!");
        require(address(this).balance > 0 wei, "This contract has no funds");
        payable(contractCreator).transfer(address(this).balance);
    }
}