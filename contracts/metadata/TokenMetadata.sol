// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ITokenMetadata, Attribute, StdTokenMetadata } from "../interfaces/metadata/ITokenMetadata.sol";
import { CompressedJSON } from "../utils/CompressedJSON.sol";
import { JSON } from "../utils/JSON.sol";
import { Strings } from "../utils/Strings.sol";

abstract contract TokenMetadata is ITokenMetadata {
    mapping(uint256 => bytes) internal _tokenMetadata;

    /// @dev Indicates whether any token exist with a given id, or not.
    function exists(uint256 _tokenId) external view virtual returns (bool) {
        return _exists(_tokenId);
    }

    /// @dev Returns the URI of the token with the given id.
    function uri(uint256 _tokenId) external view virtual returns (string memory) {
        return _getDataURI(_tokenId);
    }

    /// @dev Returns the URI of the token with the given id.
    function tokenURI(uint256 _tokenId) external view virtual returns (string memory) {
        return _getDataURI(_tokenId);
    }

    /// @dev Returns the name of the token with the given id.
    function getTokenName(uint256 _tokenId) external view virtual returns (string memory) {
        return _getTokenMetadataByPath(_tokenId, "name");
    }

    /// @dev Returns the description of the token with the given id.
    function getTokenDescription(uint256 _tokenId) external view virtual returns (string memory) {
        return _getTokenMetadataByPath(_tokenId, "description");
    }

    /// @dev Returns the image of the token with the given id.
    function getTokenImage(uint256 _tokenId) external view virtual returns (string memory) {
        return _getTokenMetadataByPath(_tokenId, "image");
    }

    /// @dev Returns the external URL of the token with the given id.
    function getTokenExternalURL(uint256 _tokenId) external view virtual returns (string memory) {
        return _getTokenMetadataByPath(_tokenId, "external_url");
    }

    /// @dev Returns the animation URL of the token with the given id.
    function getTokenAnimationURL(uint256 _tokenId) external view virtual returns (string memory) {
        return _getTokenMetadataByPath(_tokenId, "animation_url");
    }

    /// @dev Returns the attribute of the token with the given id and trait type as a string.
    function getTokenAttribute(
        uint256 _tokenId,
        string memory _traitType
    ) external view virtual returns (string memory) {
        string memory metadata = _getTokenMetadata(_tokenId);
        return JSON.JSON_UTIL.get(metadata, _getTokenAttributeValuePath(_traitType));
    }

    /// @dev Returns the attribute of the token with the given id and trait type as `int256`.
    function getTokenAttributeInt(uint256 _tokenId, string memory _traitType) external view virtual returns (int256) {
        string memory metadata = _getTokenMetadata(_tokenId);
        return JSON.JSON_UTIL.getInt(metadata, _getTokenAttributeValuePath(_traitType));
    }

    /// @dev Returns the attribute of the token with the given id and trait type as `uint256`.
    function getTokenAttributeUint(uint256 _tokenId, string memory _traitType) external view virtual returns (uint256) {
        string memory metadata = _getTokenMetadata(_tokenId);
        return JSON.JSON_UTIL.getUint(metadata, _getTokenAttributeValuePath(_traitType));
    }

    /// @dev Returns the attribute of the token with the given id and trait type as `bool`.
    function getTokenAttributeBool(uint256 _tokenId, string memory _traitType) external view virtual returns (bool) {
        string memory metadata = _getTokenMetadata(_tokenId);
        return JSON.JSON_UTIL.getBool(metadata, _getTokenAttributeValuePath(_traitType));
    }

    /// @dev Checks if the token with the given id has a specific attribute trait type.
    function hasTokenAttribute(uint256 _tokenId, string memory _traitType) external view virtual returns (bool) {
        string memory metadata = _getTokenMetadata(_tokenId);
        return JSON.JSON_UTIL.exists(metadata, _getTokenAttributePath(_traitType));
    }

    function _exists(uint256 _tokenId) internal view virtual returns (bool) {
        return _tokenMetadata[_tokenId].length > 0;
    }

    function _getDataURI(uint256 _tokenId) internal view returns (string memory) {
        if (!_exists(_tokenId)) {
            return "";
        }
        string memory jsonBlob = _getTokenMetadata(_tokenId);
        if (Strings.equal(jsonBlob, "{}")) {
            return "";
        }
        return JSON.JSON_UTIL.dataURI(jsonBlob);
    }

    function _getTokenMetadata(uint256 _tokenId) internal view returns (string memory) {
        return CompressedJSON.unwrap(_tokenMetadata[_tokenId]);
    }

    function _getTokenMetadataByPath(uint256 _tokenId, string memory _path) internal view returns (string memory) {
        string memory metadata = _getTokenMetadata(_tokenId);
        return JSON.JSON_UTIL.get(metadata, _path);
    }

    function _getTokenAttributePath(string memory _traitType) internal pure returns (string memory) {
        return Strings.replace('attributes.#(trait_type==":trait_type:")', ":trait_type:", _traitType, 1);
    }

    function _getTokenAttributeValuePath(string memory _traitType) internal pure returns (string memory) {
        return Strings.replace('attributes.#(trait_type==":trait_type:").value', ":trait_type:", _traitType, 1);
    }

    function _tokenMetadataToJson(StdTokenMetadata memory _data) internal pure returns (string memory) {
        string memory metadata = '{"attributes":[]}';

        string[] memory paths = new string[](4);
        paths[0] = "name";
        paths[1] = "description";
        paths[2] = "image";
        paths[3] = "external_url";
        string[] memory values = new string[](4);
        values[0] = _data.name;
        values[1] = _data.description;
        values[2] = _data.image;
        values[3] = _data.externalURL;
        metadata = JSON.JSON_UTIL.set(metadata, paths, values);

        for (uint8 i = 0; i < _data.attributes.length; i++) {
            metadata = JSON.JSON_UTIL.setRaw(metadata, "attributes.-1", _tokenAttributeToJson(_data.attributes[i]));
        }

        return metadata;
    }

    function _tokenAttributeToJson(Attribute memory _attribute) internal pure returns (string memory) {
        string memory attribute = "{}";
        string[] memory paths = new string[](2);
        paths[0] = "trait_type";
        paths[1] = "value";
        string[] memory values = new string[](2);
        values[0] = _attribute.traitType;
        values[1] = _attribute.value;
        attribute = JSON.JSON_UTIL.set(attribute, paths, values);
        if (bytes(_attribute.displayType).length > 0) {
            attribute = JSON.JSON_UTIL.set(attribute, "display_type", _attribute.displayType);
        }
        return attribute;
    }

    function _setTokenMetadata(uint256 _tokenId, string memory _metadata) internal virtual {
        if (_tokenMetadata[_tokenId].length > 0) {
            revert ITokenMetadata.TokenMetadataImmutable(_tokenId);
        }
        _tokenMetadata[_tokenId] = CompressedJSON.wrap(_metadata);
    }

    function _setTokenMetadata(uint256 _tokenId, StdTokenMetadata memory _data) internal virtual {
        _setTokenMetadata(_tokenId, _tokenMetadataToJson(_data));
    }
}
