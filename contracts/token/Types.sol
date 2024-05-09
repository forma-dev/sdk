// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

enum TokenType {
    ERC721,
    ERC1155
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
