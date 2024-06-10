// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ERC1155BaseUpgradeable } from "./ERC1155BaseUpgradeable.sol";
import { TokenMetadata } from "../../../metadata/TokenMetadata.sol";
import { TokenMetadataUpgradeable } from "../../metadata/TokenMetadataUpgradeable.sol";
import {
    ERC1155Upgradeable as ERC1155UpgradeableOZ
} from "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract ERC1155Upgradeable is Initializable, TokenMetadataUpgradeable, ERC1155BaseUpgradeable {
    // solhint-disable func-name-mixedcase
    function __ERC1155_init() internal onlyInitializing {}

    function __ERC1155_init_unchained() internal onlyInitializing {}
    // solhint-enable func-name-mixedcase

    function uri(
        uint256 _tokenId
    ) public view virtual override(ERC1155UpgradeableOZ, TokenMetadata) returns (string memory) {
        return _uri(_tokenId);
    }
}
