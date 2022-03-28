// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IOblivionNft {
    function owner() external view returns (address);
    function mint(address _to) external returns (uint256);
    function mint(address _to, uint256 _tokenId) external returns (uint256);
}