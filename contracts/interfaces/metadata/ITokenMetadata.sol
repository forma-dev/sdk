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

    /**
     * @notice Get the name of the token
     * @param _tokenId The ID of the token
     * @return The name of the token
     */
    function getTokenName(uint256 _tokenId) external view returns (string memory);

    /**
     * @notice Get the description of the token
     * @param _tokenId The ID of the token
     * @return The description of the token
     */
    function getTokenDescription(uint256 _tokenId) external view returns (string memory);

    function getTokenImage(uint256 _tokenId) external view returns (string memory);

    function getTokenExternalURL(uint256 _tokenId) external view returns (string memory);

    function getTokenAnimationURL(uint256 _tokenId) external view returns (string memory);

    function getTokenAttribute(uint256 _tokenId, string memory _traitType) external view returns (string memory);

    function getTokenAttributeInt(uint256 _tokenId, string memory _traitType) external view returns (int256);

    function getTokenAttributeUint(uint256 _tokenId, string memory _traitType) external view returns (uint256);

    function getTokenAttributeBool(uint256 _tokenId, string memory _traitType) external view returns (bool);

    function hasTokenAttribute(uint256 _tokenId, string memory _traitType) external view returns (bool);
}
