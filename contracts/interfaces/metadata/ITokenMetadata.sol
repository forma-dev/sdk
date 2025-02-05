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
    /**
     * @dev Modifying immutable token metadata is not allowed.
     */
    error TokenMetadataImmutable(uint256 _tokenId);

    /**
     * @dev Indicates whether any token metadata exist with a given id, or not.
     * @param _tokenId The ID of the token to check
     * @return bool True if metadata exists, false otherwise
     */
    function exists(uint256 _tokenId) external view returns (bool);

    /**
     * @dev Get the metadata for a given token ID
     * @param _tokenId The ID of the token to get metadata for
     * @return string The token's metadata as a JSON string
     */
    function getTokenMetadata(uint256 _tokenId) external view returns (string memory);
}
