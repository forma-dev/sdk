// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ERC721BaseUpgradeable } from "./ERC721BaseUpgradeable.sol";
import { TokenMetadata } from "../../../metadata/TokenMetadata.sol";
import { TokenMetadataUpgradeable } from "../../metadata/TokenMetadataUpgradeable.sol";
import {
    ERC721Upgradeable as ERC721UpgradeableOZ
} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract ERC721Upgradeable is Initializable, TokenMetadataUpgradeable, ERC721BaseUpgradeable {
    function tokenURI(
        uint256 _tokenId
    ) public view virtual override(ERC721UpgradeableOZ, TokenMetadata) returns (string memory) {
        return _uri(_tokenId);
    }
}
