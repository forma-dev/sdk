// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {
    IContractMetadata,
    RequiredContractMetadata,
    StdContractMetadata,
    FullContractMetadata
} from "../interfaces/metadata/IContractMetadata.sol";
import { JSON } from "../utils/JSON.sol";
import { JsonStore } from "../utils/JsonStore.sol";

abstract contract ContractMetadata is IContractMetadata {
    bool internal _contractMetadataCemented;

    // keccak256(abi.encode(uint256(keccak256("forma.jsonstore.ContractMetadataSlot")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant ContractMetadataSlot = 0x841f636c3ae717f882adaf710a5db29ca95821d91f8d637d2b614cbcb320c700;

    modifier onlyContractMetadataEditor() virtual {
        if (!_canSetContractMetadata()) {
            revert IContractMetadata.ContractMetadataUnauthorized();
        }
        _;
    }

    modifier contractMetadataEditable() virtual {
        if (_contractMetadataCemented) {
            revert IContractMetadata.ContractMetadataCemented();
        }
        _;
    }

    function name() public view virtual returns (string memory) {
        return JSON.JSON_UTIL.get(JsonStore.get(ContractMetadataSlot), "name");
    }

    function contractURI() public view virtual returns (string memory) {
        return JsonStore.uri(ContractMetadataSlot);
    }

    function contractURICemented() public view virtual returns (bool) {
        return _contractMetadataCemented;
    }

    function _setContractMetadata(
        string memory _metadata
    ) internal onlyContractMetadataEditor contractMetadataEditable {
        JsonStore.set(ContractMetadataSlot, _metadata);
        emit ContractURIUpdated();
    }

    function setContractMetadata(RequiredContractMetadata memory _data) public virtual {
        _setContractMetadata(JSON.JSON_UTIL.set("{}", "name", _data.name));
    }

    function setContractMetadata(StdContractMetadata memory _data) public virtual {
        _setContractMetadata(_metadataToJson(_data));
    }

    function setContractMetadata(FullContractMetadata memory _data) public virtual {
        _setContractMetadata(_metadataToJson(_data));
    }

    function setContractMetadataRaw(string memory _jsonBlob) public virtual {
        _setContractMetadata(_jsonBlob);
    }

    function cementContractMetadata() public virtual onlyContractMetadataEditor {
        _contractMetadataCemented = true;
        emit ContractURICemented();
    }

    function _metadataToJson(StdContractMetadata memory _data) internal pure returns (string memory) {
        string memory metadata = '{"collaborators":[]}';

        string[] memory paths = new string[](4);
        paths[0] = "name";
        paths[1] = "description";
        paths[2] = "image";
        paths[3] = "external_link";
        string[] memory values = new string[](4);
        values[0] = _data.name;
        values[1] = _data.description;
        values[2] = _data.image;
        values[3] = _data.externalLink;
        metadata = JSON.JSON_UTIL.set(metadata, paths, values);

        for (uint8 i = 0; i < _data.collaborators.length; i++) {
            metadata = JSON.JSON_UTIL.set(metadata, "collaborators.-1", _data.collaborators[i]);
        }

        return metadata;
    }

    function _metadataToJson(FullContractMetadata memory _data) internal pure returns (string memory) {
        string memory metadata = _metadataToJson(
            StdContractMetadata({
                name: _data.name,
                description: _data.description,
                image: _data.image,
                externalLink: _data.externalLink,
                collaborators: _data.collaborators
            })
        );

        // add extra fields
        string[] memory paths = new string[](2);
        paths[0] = "banner_image";
        paths[1] = "featured_image";
        string[] memory values = new string[](2);
        values[0] = _data.bannerImage;
        values[1] = _data.featuredImage;
        metadata = JSON.JSON_UTIL.set(metadata, paths, values);

        return metadata;
    }

    /// @dev Returns whether contract metadata can be set in the given execution context.
    function _canSetContractMetadata() internal view virtual returns (bool);
}
