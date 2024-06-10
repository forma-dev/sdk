// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

struct Attribute {
    string traitType;
    string value;
    string displayType;
}

struct StdTokenMetadata {
    string name;
    string description;
    string image;
    string externalURL;
    string animationURL;
    Attribute[] attributes;
}

interface ITokenMetadata {
    error TokenMetadataImmutable(uint256 _tokenId);

    function uri(uint256 _tokenId) external view returns (string memory);
    function tokenURI(uint256 _tokenId) external view returns (string memory);
    function exists(uint256 _tokenId) external view returns (bool);
    function getTokenMetadata(uint256 _tokenId) external view returns (string memory);
}
