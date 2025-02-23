// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC721MintablePayable {
    function mint(address _to, uint256 _amount) external payable;
}
