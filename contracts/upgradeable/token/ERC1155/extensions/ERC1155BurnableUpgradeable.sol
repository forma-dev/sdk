// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ERC1155BaseUpgradeable } from "../ERC1155BaseUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract ERC1155BurnableUpgradeable is Initializable, ERC1155BaseUpgradeable {
    // solhint-disable func-name-mixedcase
    function __ERC1155Burnable_init() internal onlyInitializing {}

    function __ERC1155Burnable_init_unchained() internal onlyInitializing {}
    // solhint-enable func-name-mixedcase

    function burn(address account, uint256 id, uint256 value) public virtual {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );

        _burn(account, id, value);
    }

    function burnBatch(address account, uint256[] memory ids, uint256[] memory values) public virtual {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );

        _burnBatch(account, ids, values);
    }
}
