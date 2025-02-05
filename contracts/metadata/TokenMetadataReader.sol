// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { JsonUtil } from "../utils/JsonUtil.sol";
import { ITokenMetadata } from "../interfaces/metadata/ITokenMetadata.sol";
import { TokenMetadataUtils } from "./TokenMetadataUtils.sol";

library TokenMetadataReader {
    function exists(address _tokenAddress, uint256 _tokenId) internal view returns (bool) {
        return ITokenMetadata(_tokenAddress).exists(_tokenId);
    }

    function exists(address _tokenAddress, uint256 _tokenId, string memory _path) internal view returns (bool) {
        string memory metadata = getTokenMetadata(_tokenAddress, _tokenId);
        return JsonUtil.exists(metadata, _path);
    }

    function getTokenMetadata(address _tokenAddress, uint256 _tokenId) internal view returns (string memory) {
        return ITokenMetadata(_tokenAddress).getTokenMetadata(_tokenId);
    }

    function getTokenMetadata(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _path
    ) internal view returns (string memory) {
        string memory metadata = getTokenMetadata(_tokenAddress, _tokenId);
        return JsonUtil.get(metadata, _path);
    }

    function getTokenMetadataInt(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _path
    ) internal view returns (int256) {
        string memory metadata = getTokenMetadata(_tokenAddress, _tokenId);
        return JsonUtil.getInt(metadata, _path);
    }

    function getTokenMetadataUint(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _path
    ) internal view returns (uint256) {
        string memory metadata = getTokenMetadata(_tokenAddress, _tokenId);
        return JsonUtil.getUint(metadata, _path);
    }

    function getTokenMetadataBool(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _path
    ) internal view returns (bool) {
        string memory metadata = getTokenMetadata(_tokenAddress, _tokenId);
        return JsonUtil.getBool(metadata, _path);
    }

    function getTokenAttribute(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _traitType
    ) internal view returns (string memory) {
        return getTokenMetadata(_tokenAddress, _tokenId, TokenMetadataUtils._tavp(_traitType));
    }

    function getTokenAttributeInt(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _traitType
    ) internal view returns (int256) {
        return getTokenMetadataInt(_tokenAddress, _tokenId, TokenMetadataUtils._tavp(_traitType));
    }

    function getTokenAttributeUint(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _traitType
    ) internal view returns (uint256) {
        return getTokenMetadataUint(_tokenAddress, _tokenId, TokenMetadataUtils._tavp(_traitType));
    }

    function getTokenAttributeBool(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _traitType
    ) internal view returns (bool) {
        return getTokenMetadataBool(_tokenAddress, _tokenId, TokenMetadataUtils._tavp(_traitType));
    }

    /// @dev Checks if the token with the given id has a specific attribute trait type.
    function hasTokenAttribute(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _traitType
    ) internal view returns (bool) {
        return exists(_tokenAddress, _tokenId, TokenMetadataUtils._tap(_traitType));
    }
}
