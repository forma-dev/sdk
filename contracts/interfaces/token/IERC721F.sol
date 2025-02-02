// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC721F {
    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address _owner) external view returns (uint256 balance);

    /**
     * @dev Returns the tokenIds owned by ``owner``'s account.
     */
    function ownedTokens(address _owner) external view returns (uint256[] memory tokenIds);

    /**
     * @dev Total supply of all tokens.
     */
    function totalSupply() external view returns (uint256);
}
