// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Attribute, StdTokenMetadata } from "./ITokenMetadata.sol";

interface IUpdatableTokenMetadata {
    event MetadataUpdate(uint256 _tokenId);

    error TokenMetadataUnauthorized(uint256 _tokenId);

    function setTokenMetadata(uint256 _tokenId, StdTokenMetadata memory _data) external;

    function setTokenMetadataRaw(uint256 _tokenId, string memory _jsonBlob) external;

    function setTokenAttribute(uint256 _tokenId, Attribute memory _attribute) external;

    function setTokenAttribute(uint256 _tokenId, string memory _traitType, string memory _value) external;

    function setTokenAttribute(uint256 _tokenId, string memory _traitType, int256 _value) external;

    function setTokenAttribute(uint256 _tokenId, string memory _traitType, uint256 _value) external;

    function setTokenAttribute(uint256 _tokenId, string memory _traitType, bool _value) external;
}
