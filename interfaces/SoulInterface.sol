// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface Soul{
    function mint(address _to, string memory _uri) external payable;
    function tokenURI(uint256 _tokenId) external view returns (string memory);
    function returnSoul(address _to, uint256 _tokenId) external;
}