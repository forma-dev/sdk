// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Attribute, StdTokenMetadata } from "../interfaces/metadata/ITokenMetadata.sol";
import { IUpdatableTokenMetadata } from "../interfaces/metadata/IUpdatableTokenMetadata.sol";
import { TokenMetadata } from "./TokenMetadata.sol";
import { CompressedJSON } from "../utils/CompressedJSON.sol";
import { JSON } from "../utils/JSON.sol";

abstract contract UpdatableTokenMetadata is TokenMetadata, IUpdatableTokenMetadata {
    modifier onlyTokenMetadataEditor(uint256 _tokenId) {
        if (!_canSetTokenMetadata(_tokenId)) {
            revert IUpdatableTokenMetadata.TokenMetadataUnauthorized(_tokenId);
        }
        _;
    }

    function setTokenMetadata(uint256 _tokenId, StdTokenMetadata memory _data) external virtual {
        _setTokenMetadata(_tokenId, _tokenMetadataToJson(_data));
    }

    function setTokenMetadataRaw(uint256 _tokenId, string memory _jsonBlob) external virtual {
        _setTokenMetadata(_tokenId, _jsonBlob);
    }

    function setTokenAttribute(uint256 _tokenId, Attribute memory _attribute) external virtual {
        string memory metadata = _getTokenMetadata(_tokenId);
        string memory path = _getTokenAttributePath(_attribute.traitType);
        bool exists = JSON.JSON_UTIL.exists(metadata, path);
        if (exists) {
            metadata = JSON.JSON_UTIL.subReplace(metadata, path, "value", _attribute.value);
        } else {
            metadata = JSON.JSON_UTIL.setRaw(metadata, "attributes.-1", _tokenAttributeToJson(_attribute));
        }
        _setTokenMetadata(_tokenId, metadata);
    }

    function setTokenAttribute(uint256 _tokenId, string memory _traitType, string memory _value) external virtual {
        string memory metadata = _getTokenMetadata(_tokenId);
        string memory path = _getTokenAttributePath(_traitType);
        bool exists = JSON.JSON_UTIL.exists(metadata, path);
        if (exists) {
            metadata = JSON.JSON_UTIL.subReplace(metadata, path, "value", _value);
        } else {
            string memory attribute = "{}";
            string[] memory paths = new string[](2);
            paths[0] = "trait_type";
            paths[1] = "value";
            string[] memory values = new string[](2);
            values[0] = _traitType;
            values[1] = _value;
            attribute = JSON.JSON_UTIL.set(attribute, paths, values);
            metadata = JSON.JSON_UTIL.setRaw(metadata, "attributes.-1", attribute);
        }

        _setTokenMetadata(_tokenId, metadata);
    }

    function setTokenAttribute(uint256 _tokenId, string memory _traitType, int256 _value) external virtual {
        string memory metadata = _getTokenMetadata(_tokenId);
        string memory path = _getTokenAttributePath(_traitType);
        bool exists = JSON.JSON_UTIL.exists(metadata, path);
        if (exists) {
            metadata = JSON.JSON_UTIL.subReplaceInt(metadata, path, "value", _value);
        } else {
            string memory attribute = JSON.JSON_UTIL.set("{}", "trait_type", _traitType);
            attribute = JSON.JSON_UTIL.setInt(attribute, "value", _value);
            metadata = JSON.JSON_UTIL.setRaw(metadata, "attributes.-1", attribute);
        }
        _setTokenMetadata(_tokenId, metadata);
    }

    function setTokenAttribute(uint256 _tokenId, string memory _traitType, uint256 _value) external virtual {
        string memory metadata = _getTokenMetadata(_tokenId);
        string memory path = _getTokenAttributePath(_traitType);
        bool exists = JSON.JSON_UTIL.exists(metadata, path);
        if (exists) {
            metadata = JSON.JSON_UTIL.subReplaceUint(metadata, path, "value", _value);
        } else {
            string memory attribute = JSON.JSON_UTIL.set("{}", "trait_type", _traitType);
            attribute = JSON.JSON_UTIL.setUint(attribute, "value", _value);
            metadata = JSON.JSON_UTIL.setRaw(metadata, "attributes.-1", attribute);
        }
        _setTokenMetadata(_tokenId, metadata);
    }

    function setTokenAttribute(uint256 _tokenId, string memory _traitType, bool _value) external virtual {
        string memory metadata = _getTokenMetadata(_tokenId);
        string memory path = _getTokenAttributePath(_traitType);
        bool exists = JSON.JSON_UTIL.exists(metadata, path);
        if (exists) {
            metadata = JSON.JSON_UTIL.subReplaceBool(metadata, path, "value", _value);
        } else {
            string memory attribute = JSON.JSON_UTIL.set("{}", "trait_type", _traitType);
            attribute = JSON.JSON_UTIL.setBool(attribute, "value", _value);
            metadata = JSON.JSON_UTIL.setRaw(metadata, "attributes.-1", attribute);
        }
        _setTokenMetadata(_tokenId, metadata);
    }

    function _setTokenMetadata(
        uint256 _tokenId,
        string memory _metadata
    ) internal virtual override onlyTokenMetadataEditor(_tokenId) {
        _tokenMetadata[_tokenId] = CompressedJSON.wrap(_metadata);
        emit MetadataUpdate(_tokenId);
    }

    /// @dev Returns whether token metadata can be set in the given execution context.
    function _canSetTokenMetadata(uint256 _tokenId) internal view virtual returns (bool);
}
