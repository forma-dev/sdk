// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ICementableTokenMetadata } from "../interfaces/metadata/ICementableTokenMetadata.sol";
import { UpdatableTokenMetadata } from "./UpdatableTokenMetadata.sol";

abstract contract CementableTokenMetadata is UpdatableTokenMetadata, ICementableTokenMetadata {
    mapping(uint256 => bool) internal _tokenMetadataCemented;

    modifier tokenMetadataEditable(uint256 _tokenId) {
        if (_tokenMetadataCemented[_tokenId]) {
            revert ICementableTokenMetadata.TokenMetadataCemented(_tokenId);
        }
        _;
    }

    function tokenURICemented(uint256 _tokenId) external view virtual returns (bool) {
        return _tokenURICemented(_tokenId);
    }

    function cementTokenMetadata(uint256 _tokenId) external virtual onlyTokenMetadataEditor(_tokenId) {
        _cementTokenMetadata(_tokenId);
    }

    function _tokenURICemented(uint256 _tokenId) internal view virtual returns (bool) {
        return _tokenMetadataCemented[_tokenId];
    }

    function _cementTokenMetadata(uint256 _tokenId) internal virtual {
        _tokenMetadataCemented[_tokenId] = true;
        emit MetadataCemented(_tokenId);
    }

    function _setTokenMetadataForced(
        bytes32 _key,
        string memory _metadata
    ) internal override tokenMetadataEditable(uint256(_key)) {
        super._setTokenMetadataForced(_key, _metadata);
    }
}
