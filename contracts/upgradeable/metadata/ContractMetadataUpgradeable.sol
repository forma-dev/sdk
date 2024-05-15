// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { IContractMetadata } from "../../interfaces/metadata/IContractMetadata.sol";
import { ContractMetadata } from "../../metadata/ContractMetadata.sol";
import { JSON } from "../../utils/JSON.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract ContractMetadataUpgradeable is Initializable, ContractMetadata {
    /// @custom:storage-location erc7201:forma.storage.ContractMetadataStorage
    struct ContractMetadataStorage {
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

    modifier contractMetadataEditable() virtual override {
        ContractMetadataStorage storage s = _getContractMetadataStorage();
        if (s._cemented) {
            revert IContractMetadata.ContractMetadataCemented();
        }
        _;
    }

    function contractURICemented() public view virtual override returns (bool) {
        ContractMetadataStorage storage s = _getContractMetadataStorage();
        return s._cemented;
    }

    function cementContractMetadata() public virtual override onlyContractMetadataEditor {
        ContractMetadataStorage storage s = _getContractMetadataStorage();
        s._cemented = true;
        emit ContractURICemented();
    }
}
