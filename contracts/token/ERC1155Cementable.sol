// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ERC1155Base } from "./ERC1155Base.sol";
import { TokenMetadata } from "../metadata/TokenMetadata.sol";
import { CementableTokenMetadata } from "../metadata/CementableTokenMetadata.sol";
import { ERC1155 as ERC1155OpenZeppelin } from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

abstract contract ERC1155Cementable is ERC1155Base, CementableTokenMetadata {
    function uri(
        uint256 _tokenId
    ) public view virtual override(ERC1155OpenZeppelin, TokenMetadata) returns (string memory) {
        return _getDataURI(_tokenId);
    }
}
