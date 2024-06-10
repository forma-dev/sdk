// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ERC721Base } from "./ERC721Base.sol";
import { TokenMetadata } from "../../metadata/TokenMetadata.sol";
import { UpdatableTokenMetadata } from "../../metadata/CementableTokenMetadata.sol";
import { ERC721 as ERC721OpenZeppelin } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract ERC721Updatable is ERC721Base, UpdatableTokenMetadata {
    function tokenURI(
        uint256 _tokenId
    ) public view virtual override(ERC721OpenZeppelin, TokenMetadata) returns (string memory) {
        return _uri(_tokenId);
    }
}
