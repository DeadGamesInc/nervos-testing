// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./access/Ownable.sol";
import "./interfaces/IERC721.sol";
import "./interfaces/IERC721Receiver.sol";
import "./token/ERC721/extensions/IERC721Metadata.sol";
import "./token/ERC721/extensions/IERC721Enumerable.sol";
import "./utils/Address.sol";
import "./utils/Strings.sol";
import "./utils/Counters.sol";
import "./utils/introspection/ERC165.sol";

abstract contract OblivionNft is Ownable, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
    using Address for address;
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter internal _tokenIds;

    string      public override name;
    string      public override symbol;
    string      public          baseURI;
    uint256[]   public          allTokens;
    uint256     public          maxSupply;

    mapping(uint256 => address) public owners;
    mapping(address => uint256) public balances;
    mapping(uint256 => address) public tokenApprovals;
    mapping(uint256 => uint256) public ownedTokensIndex;
    mapping(uint256 => uint256) public allTokensIndex;
    mapping(address => bool)    public adminWhitelist;

    mapping(address => mapping(address => bool))    public operatorApprovals;
    mapping(address => mapping(uint256 => uint256)) public ownedTokens;

    event MintNft(address to, uint date, address nft, uint tokenId, string tokenURI);

    constructor (string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function setMaxSupply(uint256 _maxSupply) public onlyOwner() {
        maxSupply = _maxSupply;
    }

    function setTokenURI(string memory _newTokenURI) public onlyOwner() {
        require(bytes(baseURI).length == 0, 'TokenURI is already set');
        baseURI = _newTokenURI;
    }

    function whitelistAdmin(address _admin, bool _isAdmin) public onlyOwner() {
        adminWhitelist[_admin] = _isAdmin;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return allTokens.length;
    }

    function exists(uint256 _tokenId) internal view virtual returns (bool) {
        return owners[_tokenId] != address(0);
    }

    function getApproved(uint256 _tokenId) public view virtual override returns (address) {
        require(exists(_tokenId), "ERC721: approved query for nonexistent token");
        return tokenApprovals[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) public view virtual override returns (bool) {
        return operatorApprovals[_owner][_operator];
    }

    function supportsInterface(bytes4 _interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return _interfaceId == type(IERC721).interfaceId || 
               _interfaceId == type(IERC721Metadata).interfaceId || 
               _interfaceId == type(IERC721Enumerable).interfaceId ||
               super.supportsInterface(_interfaceId);
    }

    function balanceOf(address _owner) public view virtual override returns (uint256) {
        require(_owner != address(0), "ERC721: balance query for the zero address");
        return balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view virtual override returns (address) {
        address owner = owners[_tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view virtual override returns (uint256) {
        require(_index < balanceOf(_owner), "ERC721Enumerable: owner index out of bounds");
        return ownedTokens[_owner][_index];
    }

    function tokenByIndex(uint256 _index) public view virtual override returns (uint256) {
        require(_index < totalSupply(), "ERC721Enumerable: global index out of bounds");
        return allTokens[_index];
    }

    function approve(address _to, uint256 _tokenId) public virtual override {
        address owner = ownerOf(_tokenId);
        require(_to != owner, "ERC721: approval to current owner");
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "ERC721: approve caller is not owner nor approved for all");
        _approve(_to, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) public virtual override {
        _setApprovalForAll(msg.sender, _operator, _approved);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public virtual override {
        require(_isApprovedOrOwner(msg.sender, _tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public virtual override {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public virtual override {
        require(_isApprovedOrOwner(msg.sender, _tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(_from, _to, _tokenId, _data);
    }

    function _safeTransfer(address _from, address _to, uint256 _tokenId, bytes memory _data) internal virtual {
        _transfer(_from, _to, _tokenId);
        require(_checkOnERC721Received(_from, _to, _tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _isApprovedOrOwner(address _spender, uint256 _tokenId) internal view virtual returns (bool) {
        require(exists(_tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(_tokenId);
        return (_spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender));
    }

    function _transfer(address _from, address _to, uint256 _tokenId) internal virtual {
        require(ownerOf(_tokenId) == _from, "ERC721: transfer from incorrect owner");
        require(_to != address(0), "ERC721: transfer to the zero address");
        _beforeTokenTransfer(_from, _to, _tokenId);
        _approve(address(0), _tokenId);
        balances[_from] -= 1;
        balances[_to] += 1;
        owners[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function _approve(address _to, uint256 _tokenId) internal virtual {
        tokenApprovals[_tokenId] = _to;
        emit Approval(ownerOf(_tokenId), _to, _tokenId);
    }

    function _setApprovalForAll(address _owner, address _operator, bool _approved) internal virtual {
        require(_owner != _operator, "ERC721: approve to caller");
        operatorApprovals[_owner][_operator] = _approved;
        emit ApprovalForAll(_owner, _operator, _approved);
    }

    function _checkOnERC721Received(address _from, address _to, uint256 _tokenId, bytes memory _data) internal returns (bool) {
        if (_to.isContract()) {
            try IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId) internal virtual {
        if (_from == address(0)) {
            _addTokenToAllTokensEnumeration(_tokenId);
        } else if (_from != _to) {
            _removeTokenFromOwnerEnumeration(_from, _tokenId);
        }

        if (_to == address(0)) {
            _removeTokenFromAllTokensEnumeration(_tokenId);
        } else if (_to != _from) {
            _addTokenToOwnerEnumeration(_to, _tokenId);
        }
    }

    function _addTokenToOwnerEnumeration(address _to, uint256 _tokenId) private {
        uint256 length = balanceOf(_to);
        ownedTokens[_to][length] = _tokenId;
        ownedTokensIndex[_tokenId] = length;
    }

    function _addTokenToAllTokensEnumeration(uint256 _tokenId) private {
        allTokensIndex[_tokenId] = allTokens.length;
        allTokens.push(_tokenId);
    }

    function _removeTokenFromOwnerEnumeration(address _from, uint256 _tokenId) private {
        uint256 lastTokenIndex = balanceOf(_from) - 1;
        uint256 tokenIndex = ownedTokensIndex[_tokenId];

        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = ownedTokens[_from][lastTokenIndex];
            ownedTokens[_from][tokenIndex] = lastTokenId;
            ownedTokensIndex[lastTokenId] = tokenIndex;
        }

        delete ownedTokensIndex[_tokenId];
        delete ownedTokens[_from][lastTokenIndex];
    }

    function _removeTokenFromAllTokensEnumeration(uint256 _tokenId) private {
        uint256 lastTokenIndex = allTokens.length - 1;
        uint256 tokenIndex = allTokensIndex[_tokenId];
        uint256 lastTokenId = allTokens[lastTokenIndex];
        allTokens[tokenIndex] = lastTokenId;
        allTokensIndex[lastTokenId] = tokenIndex;
        delete allTokensIndex[_tokenId];
        allTokens.pop();
    }
}