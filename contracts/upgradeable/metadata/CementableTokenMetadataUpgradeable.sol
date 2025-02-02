// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ICementableTokenMetadata } from "../../interfaces/metadata/ICementableTokenMetadata.sol";
import { UpdatableTokenMetadataUpgradeable } from "./UpdatableTokenMetadataUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract CementableTokenMetadataUpgradeable is
    Initializable,
    UpdatableTokenMetadataUpgradeable,
    ICementableTokenMetadata
{
    /// @custom:storage-location erc7201:forma.storage.CementableTokenMetadataStorage
    struct CementableTokenMetadataStorage {
        mapping(uint256 => bool) _cemented;
    }

    // keccak256(abi.encode(uint256(keccak256("forma.storage.CementableTokenMetadataStorage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant CementableTokenMetadataStorageLocation =
        0x935e9bcbc0809e5814f39d3828d0a7f7b9174743a7e081e81a47c083b0f4a400;

    function _getCementableTokenMetadataStorage() private pure returns (CementableTokenMetadataStorage storage s) {
        assembly {
            s.slot := CementableTokenMetadataStorageLocation
        }
    }

    // solhint-disable func-name-mixedcase
    function __CementableTokenMetadata_init() internal onlyInitializing {}

    function __CementableTokenMetadata_init_unchained() internal onlyInitializing {}
    // solhint-enable func-name-mixedcase

    modifier tokenMetadataEditable(uint256 _tokenId) {
        if (_tokenURICemented(_tokenId)) {
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
        CementableTokenMetadataStorage storage s = _getCementableTokenMetadataStorage();
        return s._cemented[_tokenId];
    }

    function _cementTokenMetadata(uint256 _tokenId) internal virtual {
        CementableTokenMetadataStorage storage s = _getCementableTokenMetadataStorage();
        s._cemented[_tokenId] = true;
        emit MetadataCemented(_tokenId);
    }

    function _setTokenMetadataForced(
        bytes32 _key,
        string memory _metadata
    ) internal override tokenMetadataEditable(uint256(_key)) {
        super._setTokenMetadataForced(_key, _metadata);
    }
}
