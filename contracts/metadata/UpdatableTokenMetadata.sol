// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Attribute, StdTokenMetadata } from "../interfaces/metadata/ITokenMetadata.sol";
import { IUpdatableTokenMetadata } from "../interfaces/metadata/IUpdatableTokenMetadata.sol";
import { TokenMetadata } from "./TokenMetadata.sol";
import { TokenMetadataEditor } from "./TokenMetadataEditor.sol";

abstract contract UpdatableTokenMetadata is TokenMetadata, IUpdatableTokenMetadata {
    using TokenMetadataEditor for string;

    modifier onlyTokenMetadataEditor(uint256 _tokenId) {
        if (!_canSetTokenMetadata(_tokenId)) {
            revert IUpdatableTokenMetadata.TokenMetadataUnauthorized(_tokenId);
        }
        _;
    }

    function setTokenMetadata(
        uint256 _tokenId,
        StdTokenMetadata memory _data
    ) external virtual onlyTokenMetadataEditor(_tokenId) {
        _setTokenMetadata(_tokenId, _tokenMetadataToJson(_data));
    }

    function setTokenMetadataRaw(
        uint256 _tokenId,
        string memory _jsonBlob
    ) external virtual onlyTokenMetadataEditor(_tokenId) {
        _setTokenMetadata(_tokenId, _jsonBlob);
    }

    function setTokenMetadata(
        uint256 _tokenId,
        string memory _path,
        string memory _value
    ) external virtual onlyTokenMetadataEditor(_tokenId) {
        _setTokenMetadata(_tokenId, _path, _value);
    }

    function setTokenAttribute(
        uint256 _tokenId,
        Attribute memory _attribute
    ) external virtual onlyTokenMetadataEditor(_tokenId) {
        _setTokenAttribute(_tokenId, _attribute);
    }

    function setTokenAttribute(
        uint256 _tokenId,
        string memory _traitType,
        string memory _value
    ) external virtual onlyTokenMetadataEditor(_tokenId) {
        _setTokenAttribute(_tokenId, _traitType, _value);
    }

    function setTokenAttribute(
        uint256 _tokenId,
        string memory _traitType,
        int256 _value
    ) external virtual onlyTokenMetadataEditor(_tokenId) {
        _setTokenAttribute(_tokenId, _traitType, _value);
    }

    function setTokenAttribute(
        uint256 _tokenId,
        string memory _traitType,
        uint256 _value
    ) external virtual onlyTokenMetadataEditor(_tokenId) {
        _setTokenAttribute(_tokenId, _traitType, _value);
    }

    function setTokenAttribute(
        uint256 _tokenId,
        string memory _traitType,
        bool _value
    ) external virtual onlyTokenMetadataEditor(_tokenId) {
        _setTokenAttribute(_tokenId, _traitType, _value);
    }

    function _setTokenMetadata(uint256 _tokenId, string memory _metadata) internal virtual override {
        _setTokenMetadataForced(_tokenId, _metadata);
        emit MetadataUpdate(_tokenId);
    }

    function _setTokenMetadata(uint256 _tokenId, string memory _path, string memory _value) internal virtual {
        string memory metadata = _getTokenMetadata(_tokenId);
        _setTokenMetadata(_tokenId, metadata.setTokenMetadata(_path, _value));
    }

    function _setTokenAttribute(uint256 _tokenId, Attribute memory _attribute) internal virtual {
        string memory metadata = _getTokenMetadata(_tokenId);
        _setTokenMetadata(_tokenId, metadata.setTokenAttribute(_attribute));
    }

    function _setTokenAttribute(uint256 _tokenId, string memory _traitType, string memory _value) internal virtual {
        string memory metadata = _getTokenMetadata(_tokenId);
        _setTokenMetadata(_tokenId, metadata.setTokenAttribute(_traitType, _value));
    }

    function _setTokenAttribute(uint256 _tokenId, string memory _traitType, int256 _value) internal virtual {
        string memory metadata = _getTokenMetadata(_tokenId);
        _setTokenMetadata(_tokenId, metadata.setTokenAttribute(_traitType, _value));
    }

    function _setTokenAttribute(uint256 _tokenId, string memory _traitType, uint256 _value) internal virtual {
        string memory metadata = _getTokenMetadata(_tokenId);
        _setTokenMetadata(_tokenId, metadata.setTokenAttribute(_traitType, _value));
    }

    function _setTokenAttribute(uint256 _tokenId, string memory _traitType, bool _value) internal virtual {
        string memory metadata = _getTokenMetadata(_tokenId);
        _setTokenMetadata(_tokenId, metadata.setTokenAttribute(_traitType, _value));
    }

    /// @dev Returns whether token metadata can be set in the given execution context.
    function _canSetTokenMetadata(uint256 _tokenId) internal view virtual returns (bool);
}
