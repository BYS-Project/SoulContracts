// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SoulKey is ERC721{

    // To Do:
    /*
        Find a decent names for "normal" and "op" keys!
        Does every metadata be different?
        Discuss about "The limit normal keys cannot be modified"
    */

    // Normal key Variables
    uint256 internal normalPrice;       // Price of a normal key
    uint256 internal normalMinted;      // Updated number of keys minted
    uint256 internal normalBound;       // Maximum amount of normal keys
    string internal normalDefaultURI;   // Default URI for normal keys
    // OP ket Variables
    uint256 internal opPrice;
    uint256 internal opMinted;
    uint256 internal opBound;
    uint256 internal opMintLimit;       // How many keys can be minted with a single OP Key?
    string internal opDefaultURI;
    // Other Variables
    address internal creator;           // Who's the creator of this smart contract?
    mapping(uint256 => string) internal tokens;         // Mapping of the tokens' numbers with the relative URI
    // Admin privileges
    mapping(address => bool) internal adminAddresses;   // List of addresses with admin privilege
    // Contructor. Empty arguments! Everything must be setted with setter/getter methods
    constructor() ERC721("Soul Key", "SOUK"){
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
        normalDefaultURI = "default_normal";
        opDefaultURI = "default_op";
    }
    // Minting of Normal keys
    function mintSKN(address _to, string memory _uri) public payable{
        require(normalMinted < normalBound, "Normal sold out!");
        require(msg.value >= normalPrice, "You must specify a greater amount!");
        uint256 tokenSupply = normalMinted + opMinted;
        _mint(_to, tokenSupply);
        if(!equals(_uri, "")){
            tokens[tokenSupply] = _uri;
        }else{
            tokens[tokenSupply] = normalDefaultURI;
        }
        normalMinted++;
    }
    // Minting of OP keys
    function mintSKOP(address _to, string memory _uri) public payable{
        require(normalMinted < normalBound, "Normal sold out!");
        require(msg.value >= opPrice, "You must specify a greater amount!");
        for(uint256 i = 0; i < opMintLimit; i++){
            uint256 tokenSupply = normalMinted + opMinted;
            _mint(_to, tokenSupply);
            if(!equals(_uri, "")){
                tokens[tokenSupply] = _uri;
            }else{
                tokens[tokenSupply] = opDefaultURI;
            }
            opMinted++;
        }
    }
    // Function for getting the token URI (used by OpenSea f.e.)
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        uint256 tokenSupply = normalMinted + opMinted;
        require(_tokenId < tokenSupply, "The token specified does not exists!");
        // require(bytes(tokens[_tokenId]).length > 0, "Cannot find the specified token");
        return tokens[_tokenId];
    }
    // Getters & Setters
        // Token Supply
    function getTokenSupply() public view returns (uint256){
        return normalMinted + opMinted;
    }
        // For normal keys
    function getNormalPrice() public view returns (uint256){
        return normalPrice;
    }
    function setNormalPrice(uint256 _normalPrice) public{
        require((msg.sender == creator) || (adminAddresses[msg.sender]), "You cannot perform this action!");
        require(_normalPrice > 0, "The price must be greater than zero!");
        normalPrice = _normalPrice;
    }
        // The amount of minted normal keys cannot be modified
    function getNormalMinted() public view returns (uint256){
        return normalMinted;
    }
        // The limit normal keys cannot be modified
    function getNormalBound() public view returns (uint256){
        return normalBound;
    }
    function getNormalDefaultURI() public view returns (string memory){
        return normalDefaultURI;
    }
    function setNormalDefaultURI(string memory _normalDefaultURI) public{
        require((msg.sender == creator) || (adminAddresses[msg.sender]), "You cannot perform this action!");
        require(!equals(_normalDefaultURI, ""), "The URI must not be null!");
        normalDefaultURI = _normalDefaultURI;
    }
        // For OP keys
    function getOPPrice() public view returns (uint256){
        return opPrice;
    }
    function setOPPrice(uint256 _opPrice) public{
        require((msg.sender == creator) || (adminAddresses[msg.sender]), "You cannot perform this action!");
        require(_opPrice > 0, "The price must be greater than zero!");
        opPrice = _opPrice;
    }
        // The amount of minted normal keys cannot be modified
    function getOPMinted() public view returns (uint256){
        return opMinted;
    }
        // The limit normal keys cannot be modified
    function getOPBound() public view returns (uint256){
        return opBound;
    }
    function getOPMintLimit() public view returns (uint256){
        return opMintLimit;
    }
    function setOPMintLimit(uint256 _opMintLimit) public{
        require((msg.sender == creator) || (adminAddresses[msg.sender]), "You cannot perform this action!");
        require(_opMintLimit > 0, "The mint limit must be greater than zero!");
        opMintLimit = _opMintLimit;
    }
    function getOPDefaultURI() public view returns (string memory){
        return opDefaultURI;
    }
    function setOPDefaultURI(string memory _opDefaultURI) public{
        require((msg.sender == creator) || (adminAddresses[msg.sender]), "You cannot perform this action!");
        require(!equals(_opDefaultURI, ""), "The URI must not be null!");
        opDefaultURI = _opDefaultURI;
    }
    // Withdraw function
    function withdraw() public{
        require((msg.sender == creator) || (adminAddresses[msg.sender]), "You cannot perform this action!");
        require(address(this).balance > 0 wei, "This contract has no founds :C");
        payable(creator).transfer(address(this).balance);
    }
    // Admin functions
    function addAdmin(address _admin) public{
        require((msg.sender == creator) || (adminAddresses[msg.sender]), "You cannot perform this action!");
        adminAddresses[_admin] = true;
    }
    function removeAdmin(address _admin) public{
        require((msg.sender == creator) || (adminAddresses[msg.sender]), "You cannot perform this action!");
        adminAddresses[_admin] = false;
    }
    // Utility Functions
    function equals(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}