// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./IPrime.sol";

contract SexyPrime is ERC721URIStorage, Ownable {
    string public baseURI; 
    IPrime private primeContract;
    mapping(uint256 tokenId => bool) public idToIsSexyPrime;

    constructor(address _prime) ERC721("SexyPrime", "SEXYPRIME") Ownable(msg.sender){
        primeContract = IPrime(_prime);
    }
    function setBaseURI(string memory newBaseURI) external onlyOwner {
        baseURI = newBaseURI;
    }
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
    function mint(uint256 _tokenId) public payable returns(bool) {
        require(!idToIsSexyPrime[_tokenId], "already checked");
        (bool success, ) = owner().call{value: msg.value}("");
        require(success, "Transfer failed");
        if(primeContract.isPrime(_tokenId) && primeContract.isPrime(_tokenId + 6)){
            _mint(msg.sender, _tokenId * (_tokenId + 6));
            return true;
        }
        return false;
    }
    
    
}



