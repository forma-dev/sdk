// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {
    IContractMetadata,
    RequiredContractMetadata,
    StdContractMetadata,
    FullContractMetadata
} from "../../interfaces/metadata/IContractMetadata.sol";
import { CompressedJSON } from "../../utils/CompressedJSON.sol";
import { JSON } from "../../utils/JSON.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract ContractMetadataUpgradeable is Initializable, IContractMetadata {
    /// @custom:storage-location erc7201:forma.storage.ContractMetadataStorage
    struct ContractMetadataStorage {
        bytes _metadata;
        bool _cemented;
    }

    // keccak256(abi.encode(uint256(keccak256("forma.storage.ContractMetadataStorage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant ContractMetadataStorageLocation =
        0x985371f50cecfcb1a6dfdccb4c871d7a5d94b17a9d368860b42eaca20a68bf00;

    function _getContractMetadataStorage() private pure returns (ContractMetadataStorage storage s) {
        assembly {
            s.slot := ContractMetadataStorageLocation
        }
    }

    // solhint-disable func-name-mixedcase
    function __ContractMetadata_init(string memory _name) internal onlyInitializing {
        __ContractMetadata_init_unchained(_name);
    }

    function __ContractMetadata_init_unchained(string memory _name) internal onlyInitializing {
        _setContractMetadata(JSON.JSON_UTIL.set("{}", "name", _name));
    }
    // solhint-enable func-name-mixedcase

    modifier onlyContractMetadataEditor() {
        if (!_canSetContractMetadata()) {
            revert IContractMetadata.ContractMetadataUnauthorized();
        }
        _;
    }

    modifier contractMetadataEditable() {
        ContractMetadataStorage storage s = _getContractMetadataStorage();
        if (s._cemented) {
            revert IContractMetadata.ContractMetadataCemented();
        }
        _;
    }

    function name() public view virtual returns (string memory) {
        return JSON.JSON_UTIL.get(_getContractMetadata(), "name");
    }

    function contractURI() public view virtual returns (string memory) {
        return JSON.JSON_UTIL.dataURI(_getContractMetadata());
    }

    function contractURICemented() public view virtual returns (bool) {
        ContractMetadataStorage storage s = _getContractMetadataStorage();
        return s._cemented;
    }

    function _getContractMetadata() internal view virtual returns (string memory) {
        ContractMetadataStorage storage s = _getContractMetadataStorage();
        return CompressedJSON.unwrap(s._metadata);
    }

    function _setContractMetadata(string memory _metadata) internal contractMetadataEditable {
        ContractMetadataStorage storage s = _getContractMetadataStorage();
        s._metadata = CompressedJSON.wrap(_metadata);
        emit ContractURIUpdated();
    }

    function setContractMetadata(RequiredContractMetadata memory _data) external virtual onlyContractMetadataEditor {
        _setContractMetadata(JSON.JSON_UTIL.set("{}", "name", _data.name));
    }

    function setContractMetadata(StdContractMetadata memory _data) external virtual onlyContractMetadataEditor {
        _setContractMetadata(_metadataToJson(_data));
    }

    function setContractMetadata(FullContractMetadata memory _data) external virtual onlyContractMetadataEditor {
        _setContractMetadata(_metadataToJson(_data));
    }

    function setContractMetadataRaw(string memory _jsonBlob) external virtual onlyContractMetadataEditor {
        _setContractMetadata(_jsonBlob);
    }

    function cementContractMetadata() public virtual onlyContractMetadataEditor {
        ContractMetadataStorage storage s = _getContractMetadataStorage();
        s._cemented = true;
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
