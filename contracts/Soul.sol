// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721_bys.sol";
import "../interfaces/SoulKeyInterface.sol";
import "../interfaces/UtilsInterface.sol";

contract Soul is ERC721_bys{

    /*
        Riunione dei metadata !!!!! DA ASPETTARE FINO A QUANDO I SOUL NON SI DECIDONO

        Fare una firma che altrimenti il disma mi copa

        DICHIARE VARIABILI GIA' CHE VADANO BENE NON NEL COSTRUTTORE

        POLICY E DOCUMENTAZIONE!!! https://etherscan.io/address/0x348fc118bcc65a92dc033a951af153d14d945312#code

        PREVEDERE GIVEAWAY SOUL / SOULKEY
            // -> Fare address a parte da usare sul sito o usare quella del creator?
            // ... Soul Key normale nelle felpe compresa tra le 3k  Raccogliere prima gli address?

        1155 VS 721 D:

        Staking
    */

    // Token attributes
    uint private tokenMintLimit;
    uint private tokenPrice;
    uint private maxSoulPerAddress;
    // SoulKey Contract Address and SoulKey Contract
    address private soulKeyContract;
    // How many keys shoul the contract mint given an Op Soul Key
    uint private opKeyMints;
    // Is the contract ready to accept payments?
    bool private contractOnline;
    bool private allowKeys;
    // Utils Smart Contract Address
    address private utils;
    // Events
    event ContractOnlineStatusChanged(bool _newStatus);
    event AllowKeysStatusChanged(bool _newStatus);
    // When a contract is created it has not a soulKeyContract associated nor a contractOnline = true status
    constructor(uint _tokenMintLimit, uint _tokenPrice, string memory _baseURI, address _utils, uint _maxSoulPerAddress) ERC721_bys("Soul", "SOU"){
        tokenMintLimit = _tokenMintLimit;
        tokenPrice = _tokenPrice;
        baseURI = _baseURI;
        utils = _utils;
        maxSoulPerAddress = _maxSoulPerAddress;
        contractCreator = msg.sender;
    }
    // ""
    function mint(uint amount) public payable{
        require(contractOnline, "You must wait before buying those Souls");
        require(tokenSupply < tokenMintLimit, "Soul were sold out!");
        require(tokenSupply + amount < tokenMintLimit, "Please, specify a smaller amount to buy!");
        require(balanceOf(msg.sender) < maxSoulPerAddress, "You cannot buy other Souls. Max amount reached!");
        require(msg.value >= tokenPrice * amount, "You must specify a greater amount!");
        _mint(msg.sender, amount);
    }
    // ""
    function tokenURI(uint _tokenId) public view override returns (string memory) {
        require(_tokenId < tokenSupply, "The token specified does not exists!");
        string memory uri = string(abi.encodePacked(baseURI, "/", BYS_Utils(utils).toString(tokenSupply), ".json"));
        require(bytes(uri).length > 0, "Cannot find the specified token");
        return uri;
    }
    // Convert a SoulKet into a Soul
    function returnSoul(address _to, uint _tokenId) public{
        require(msg.sender == soulKeyContract, "You cannot perform this action!");
        require(allowKeys, "You must wait before buying those Souls");
        uint amount = 1;
        if(SoulKey(soulKeyContract).keyType(_tokenId) == 2){
            amount = SoulKey(soulKeyContract).getSoulMintedWithOpKey();
        }
        _mint(_to, amount);
    }
    // Setters
    function setSoulKeyContract(address _soulKeyContract) public{
        require(msg.sender == contractCreator, "You cannot perform this action!");
        require(_soulKeyContract != soulKeyContract, "Same address is already specified!");
        soulKeyContract = _soulKeyContract;
    }
    function setContractOnline(bool _contractOnline) public{
        require(msg.sender == contractCreator, "You cannot perform this action!");
        require(_contractOnline != contractOnline, "Same value is already specified!");
        emit ContractOnlineStatusChanged(_contractOnline);
        contractOnline = _contractOnline;
    }
    function setAllowKeys(bool _allowKeys) public{
        require(msg.sender == contractCreator, "You cannot perform this action!");
        require(_allowKeys != allowKeys, "Same value is already specified!");
        emit AllowKeysStatusChanged(_allowKeys);
        allowKeys = _allowKeys;
    }
    // Withdraw function
    function withdraw() public{
        require(msg.sender == contractCreator, "You cannot perform this action!");
        require(address(this).balance > 0 wei, "This contract has no funds");
        payable(contractCreator).transfer(address(this).balance);
    }
}