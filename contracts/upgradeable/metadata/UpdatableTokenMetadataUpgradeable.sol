// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { UpdatableTokenMetadata } from "../../metadata/UpdatableTokenMetadata.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract UpdatableTokenMetadataUpgradeable is Initializable, UpdatableTokenMetadata {
    // solhint-disable func-name-mixedcase
    function __UpdatableTokenMetadata_init() internal onlyInitializing {}

    function __UpdatableTokenMetadata_init_unchained() internal onlyInitializing {}
    // solhint-enable func-name-mixedcase
}
