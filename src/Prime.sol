// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Prime is ERC721URIStorage, Ownable {
    string public baseURI; 
    mapping(uint256 tokenId => bool) public idToIsPrime;
    mapping(uint256 tokenId => uint256) public idToCurrentDivisor;
    
    event Progress(uint256 indexed tokenId, uint256 indexed divisor, bool isPrimeSoFar);

    constructor() ERC721("Prime", "PRIME") Ownable(msg.sender){}
    function setBaseURI(string memory newBaseURI) external onlyOwner {
        baseURI = newBaseURI;
    }
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function mint(uint256 _tokenId, uint256 steps) public payable returns (bool) {
        require(block.number > _tokenId, "wait for the block");
        require(msg.value >= 0.002 ether, "insufficient value");
        require(!idToIsPrime[_tokenId], "already checked");
        require(_tokenId > 1, "_tokenId must be lager than 1");

        (bool success, ) = owner().call{value: msg.value}("");
        require(success, "Transfer failed");

        if(idToCurrentDivisor[_tokenId] == 0){
            idToCurrentDivisor[_tokenId] = 2;
        } 
        for (uint256 i = 0; i < steps; i++) {
            if (idToCurrentDivisor[_tokenId] * idToCurrentDivisor[_tokenId] > _tokenId) {
                _mint(msg.sender, _tokenId);
                idToIsPrime[_tokenId] = true;
                emit Progress(_tokenId, idToCurrentDivisor[_tokenId], true);
                return true;
            }

            if (_tokenId % idToCurrentDivisor[_tokenId] == 0) {
                emit Progress(_tokenId, idToCurrentDivisor[_tokenId], false);
                return false; 
            }

            idToCurrentDivisor[_tokenId] = (idToCurrentDivisor[_tokenId] == 2) ? 3 : idToCurrentDivisor[_tokenId] + 2;
        }

        emit Progress(_tokenId, idToCurrentDivisor[_tokenId], false);
        return false; 
    }

    function isPrime(uint256 _tokenId) external view returns (bool) {
        return idToIsPrime[_tokenId];
    }
    
}



