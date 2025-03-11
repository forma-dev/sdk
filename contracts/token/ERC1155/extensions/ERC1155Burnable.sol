// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ERC1155Base } from "../ERC1155Base.sol";
import { IERC1155Burnable } from "../../../interfaces/token/IERC1155Burnable.sol";

abstract contract ERC1155Burnable is ERC1155Base {
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

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC1155Burnable).interfaceId || super.supportsInterface(interfaceId);
    }
}
