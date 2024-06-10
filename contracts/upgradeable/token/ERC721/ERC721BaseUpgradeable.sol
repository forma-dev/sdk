// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {
    ERC721Upgradeable as ERC721UpgradeableOZ
} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import { ERC2981Upgradeable } from "@openzeppelin/contracts-upgradeable/token/common/ERC2981Upgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract ERC721BaseUpgradeable is Initializable, ERC2981Upgradeable, ERC721UpgradeableOZ {
    // solhint-disable func-name-mixedcase
    function __ERC721Base_init() internal onlyInitializing {}

    function __ERC7215Base_init_unchained() internal onlyInitializing {}
    // solhint-enable func-name-mixedcase

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721UpgradeableOZ, ERC2981Upgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
