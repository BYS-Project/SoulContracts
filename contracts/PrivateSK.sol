// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PrivateSK is ERC721{

    // Normal Variables
    uint256 internal normalPrice;
    uint256 internal normalMinted;
    uint256 internal normalBound;
    string internal normalDefaultURI;
    // OP Variables
    uint256 internal opPrice;
    uint256 internal opMinted;
    uint256 internal opBound;
    uint256 internal opMintLimit;
    string internal opDefaultURI;
    // Other Variables
    address internal creator;
    mapping(uint256 => string) internal tokens;
    // Admin privileges
    mapping(address => bool) internal adminAddresses;

    constructor() ERC721("BYS_Project_PrivateSK", "BYSP"){
        creator = msg.sender;
        normalMinted = 0;
        normalBound = 3000;
        opMinted = 0;
        opBound = 3000; // 3000 / 3 = 1000 -> There will be created 3000 S with a total of 1000 OPSK
        opMintLimit = 3;
        // Prices
        // Normal: 0.05 ether = 50 milliether = 50.000.000 gwei
        // OP: 0.15 ether = 150 milliether =  = 150.000.000 gwei
        normalPrice = 50000000 gwei;
        opPrice = 150000000 gwei;
        // Default URIs
        normalDefaultURI = "";
        opDefaultURI = "";
    }

    // Minting
    function mintSKN(address _to, string memory _uri) public payable{
        require(normalMinted < normalBound, "Normal sold out!");
        require(msg.value >= normalPrice, "You must specify a greater amount!");
        uint256 tokenSupply = normalMinted + opMinted;
        _mint(_to, tokenSupply);
        tokens[tokenSupply] = _uri;
        normalMinted++;
    }

    function mintSKOP(address _to, string memory _uri) public payable{
        require(normalMinted < normalBound, "Normal sold out!");
        require(msg.value >= opPrice, "You must specify a greater amount!");
        for(uint256 i = 0; i < opMintLimit; i++){
            uint256 tokenSupply = normalMinted + opMinted;
            _mint(_to, tokenSupply);
            tokens[tokenSupply] = _uri;
            opMinted++;
        }
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        uint256 tokenSupply = normalMinted + opMinted;
        require(_tokenId < tokenSupply, "The token specified does not exists!");
        require(bytes(tokens[_tokenId]).length > 0, "Cannot find the specified token");
        return tokens[_tokenId];
    }

    function getTokenSupply() public view returns (uint256){
        return normalMinted + opMinted;
    }
    function getNormalMinted() public view returns (uint256){
        return normalMinted;
    }
    function getNormalPrice() public view returns (uint256){
        return normalPrice;
    }
    function setNormalPrice(uint256 _normalPrice) public{
        require((msg.sender == creator) || (adminAddresses[msg.sender]), "You cannot perform this action!");
        normalPrice = _normalPrice;
    }
    function getOPMinted() public view returns (uint256){
        return opMinted; // Returns the amount of SK minted with the OP key -> Max will be 3000; If you want to number of key used do getOPMinted()/getOPMintLimit()
    }
    function getOPMintLimit() public view returns (uint256){
        return opMintLimit;
    }
    function getOPPrice() public view returns (uint256){
        return opPrice;
    }
    function setOPPrice(_opPrice) public{
        require((msg.sender == creator) || (adminAddresses[msg.sender]), "You cannot perform this action!");
        opPrice = _opPrice;
    }

    function withdraw() public{
        require((msg.sender == creator) || (adminAddresses[msg.sender], "You cannot perform this action!");
        require(address(this).balance > 0 wei, "This contract has no founds :C");
        payable(creator).transfer(address(this).balance);
    }

    function addAdmin(address _admin) public{
        require((msg.sender == creator) || (adminAddresses[msg.sender]), "You cannot perform this action!");
        adminAddresses[_admin] = true;
    }

    function removeAdmin(address _admin) public{
        require((msg.sender == creator) || (adminAddresses[msg.sender]), "You cannot perform this action!");
        adminAddresses[_admin] = false;
    }
}