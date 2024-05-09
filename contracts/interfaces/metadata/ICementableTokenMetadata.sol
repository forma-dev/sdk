// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ICementableTokenMetadata {
    event MetadataCemented(uint256 _tokenId);

    error TokenMetadataCemented(uint256 _tokenId);

    function tokenURICemented(uint256 _tokenId) external view returns (bool);

    function cementTokenMetadata(uint256 _tokenId) external;
}
