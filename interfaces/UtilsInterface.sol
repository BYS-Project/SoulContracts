// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface BYS_Utils{
    function toString(uint value) external pure returns (string memory);
    function contains(string memory main, string memory subString) external pure returns (bool);
    function getSlice(uint begin, uint end, string memory text) external pure returns (string memory);
    function equals(string memory a, string memory b) external pure returns (bool);
}