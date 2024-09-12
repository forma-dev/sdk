// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { JsonUtil } from "../utils/JsonUtil.sol";
import { Strings } from "../utils/Strings.sol";
import { ITokenMetadata } from "../interfaces/metadata/ITokenMetadata.sol";

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
        return getTokenMetadata(_tokenAddress, _tokenId, _tavp(_traitType));
    }

    function getTokenAttributeInt(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _traitType
    ) internal view returns (int256) {
        return getTokenMetadataInt(_tokenAddress, _tokenId, _tavp(_traitType));
    }

    function getTokenAttributeUint(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _traitType
    ) internal view returns (uint256) {
        return getTokenMetadataUint(_tokenAddress, _tokenId, _tavp(_traitType));
    }

    function getTokenAttributeBool(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _traitType
    ) internal view returns (bool) {
        return getTokenMetadataBool(_tokenAddress, _tokenId, _tavp(_traitType));
    }

    /// @dev Checks if the token with the given id has a specific attribute trait type.
    function hasTokenAttribute(
        address _tokenAddress,
        uint256 _tokenId,
        string memory _traitType
    ) internal view returns (bool) {
        return exists(_tokenAddress, _tokenId, _tap(_traitType));
    }

    function _tap(string memory _traitType) internal pure returns (string memory) {
        return Strings.replace('attributes.#(trait_type==":trait_type:")', ":trait_type:", _traitType, 1);
    }

    function _tavp(string memory _traitType) internal pure returns (string memory) {
        return Strings.replace('attributes.#(trait_type==":trait_type:").value', ":trait_type:", _traitType, 1);
    }
}
