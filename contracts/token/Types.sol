// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { IERC1155 } from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import { IERC721Burnable } from "../interfaces/token/IERC721Burnable.sol";
import { IERC1155Burnable } from "../interfaces/token/IERC1155Burnable.sol";
import { IERC721Mintable } from "../interfaces/token/IERC721Mintable.sol";
import { IERC1155Mintable } from "../interfaces/token/IERC1155Mintable.sol";

enum TokenType {
    ERC721,
    ERC1155,
    ERC20,
    UNKNOWN
}

struct SimpleToken {
    address tokenAddress;
    uint256 tokenId;
}

struct Token {
    address tokenAddress;
    uint256 tokenId;
    TokenType tokenType;
}

library TokenTypes {
    error ErrInvalidTokenType(address _tokenAddress);

    function getTokenType(address _tokenAddress) internal view returns (TokenType) {
        if (IERC165(_tokenAddress).supportsInterface(type(IERC1155).interfaceId)) {
            return TokenType.ERC1155;
        } else if (IERC165(_tokenAddress).supportsInterface(type(IERC721).interfaceId)) {
            return TokenType.ERC721;
        } else if (IERC165(_tokenAddress).supportsInterface(type(IERC20).interfaceId)) {
            return TokenType.ERC20;
        } else {
            return TokenType.UNKNOWN;
        }
    }

    function getTokenTypeOrRevert(address _tokenAddress) internal view returns (TokenType) {
        TokenType tokenType = getTokenType(_tokenAddress);
        if (tokenType == TokenType.UNKNOWN) {
            revert ErrInvalidTokenType(_tokenAddress);
        }
        return tokenType;
    }

    function isMintable(address _tokenAddress) internal view returns (bool) {
        if (getTokenType(_tokenAddress) == TokenType.ERC721) {
            return IERC721(_tokenAddress).supportsInterface(type(IERC721Mintable).interfaceId);
        } else if (getTokenType(_tokenAddress) == TokenType.ERC1155) {
            return IERC1155(_tokenAddress).supportsInterface(type(IERC1155Mintable).interfaceId);
        }
        return false;
    }

    function isBurnable(address _tokenAddress) internal view returns (bool) {
        if (getTokenType(_tokenAddress) == TokenType.ERC721) {
            return IERC721(_tokenAddress).supportsInterface(type(IERC721Burnable).interfaceId);
        } else if (getTokenType(_tokenAddress) == TokenType.ERC1155) {
            return IERC1155(_tokenAddress).supportsInterface(type(IERC1155Burnable).interfaceId);
        }
        return false;
    }
}
