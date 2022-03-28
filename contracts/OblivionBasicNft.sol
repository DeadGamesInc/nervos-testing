// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./OblivionNft.sol";

contract OblivionBasicNft is OblivionNft {   
    using Counters for Counters.Counter; 

    constructor (string memory _name, string memory _symbol) OblivionNft(_name, _symbol) { }    

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        require(exists(_tokenId) || _tokenId <= maxSupply || maxSupply == 0, "ERC721Metadata: URI query for nonexistent token");
        return baseURI;
    }

    function preMint(address _to, uint256 _quantity) public onlyOwner() {
        require(bytes(baseURI).length > 0, 'tokenURI is not set');
        require(maxSupply == 0 || totalSupply() + _quantity <= maxSupply, 'maximum mints reached');
        require(_to != address(0), "ERC721: mint to the zero address");

        uint256 newItemId;

        for (uint256 i = 0; i < _quantity; i++) {
            _tokenIds.increment();
            newItemId = _tokenIds.current();
            require(!exists(newItemId), "ERC721: token already minted");

            _beforeTokenTransfer(address(0), _to, newItemId);
            balances[_to] += 1;
            owners[newItemId] = _to;
            require(_checkOnERC721Received(address(0), _to, newItemId, ""), "ERC721: transfer to non ERC721Receiver implementer");
        }
    }

    function mint(address _to) public returns (uint256) {
        require(bytes(baseURI).length > 0, 'tokenURI is not set');
        require(adminWhitelist[msg.sender], 'must be called by whitelisted address');
        require(maxSupply == 0 || totalSupply() < maxSupply, 'maximum mints reached');
        require(_to != address(0), "ERC721: mint to the zero address");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        
        require(!exists(newItemId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), _to, newItemId);
        balances[_to] += 1;
        owners[newItemId] = _to;
        emit Transfer(address(0), _to, newItemId);

        require(_checkOnERC721Received(address(0), _to, newItemId, ""), "ERC721: transfer to non ERC721Receiver implementer");

        emit MintNft(_to, block.timestamp, address(this), newItemId, tokenURI(newItemId));        
        return newItemId;
    }

    
}