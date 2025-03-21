// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC1155MintablePayable {
    function mint(address _to, uint256 _tokenId, uint256 _amount) external payable;
}
