// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ERC721BaseUpgradeable } from "./ERC721BaseUpgradeable.sol";
import { TokenMetadata } from "../../../metadata/TokenMetadata.sol";
import { CementableTokenMetadataUpgradeable } from "../../metadata/CementableTokenMetadataUpgradeable.sol";
import {
    ERC721Upgradeable as ERC721UpgradeableOZ
} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract ERC721CementableUpgradeable is
    Initializable,
    ERC721BaseUpgradeable,
    CementableTokenMetadataUpgradeable
{
    // solhint-disable func-name-mixedcase
    function __ERC721Cementable_init() internal onlyInitializing {}

    function __ERC721Cementable_init_unchained() internal onlyInitializing {}
    // solhint-enable func-name-mixedcase

    function tokenURI(
        uint256 _tokenId
    ) public view virtual override(ERC721UpgradeableOZ, TokenMetadata) returns (string memory) {
        return _uri(_tokenId);
    }
}
