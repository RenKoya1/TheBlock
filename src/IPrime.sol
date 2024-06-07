// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IPrime {
    function isPrime(uint256 _tokenId) external view returns (bool);
}