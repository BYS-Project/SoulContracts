// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface SoulKey{
    function mintSKN() external payable;
    function mintSKOP() external payable;
    function tokenURI(uint256 _tokenId) external view returns (string memory);
    function convertToSoul(uint256 _tokenId) external;
    function keyType(uint256 _tokenId) external view returns (uint256);
    function getSoulMintedWithOpKey() external view returns (uint256);
    function setSoulContract(address _soulContract) external;
    function setBuyable(bool _buyable) external;
    function withdraw() external;
}