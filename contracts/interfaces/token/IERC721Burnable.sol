// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC721Burnable {
    function burn(address _from, uint256 _tokenId) external;
}
