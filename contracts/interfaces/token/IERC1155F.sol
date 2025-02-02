// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC1155F {
    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address _owner) external view returns (uint256 balance);

    /**
     * @dev Returns the tokenIds owned by ``owner``'s account.
     */
    function ownedTokens(address _owner) external view returns (uint256[] memory tokenIds);

    /**
     * @dev Total supply of tokens with a given id.
     */
    function totalSupply(uint256 _tokenId) external view returns (uint256);

    /**
     * @dev Total supply of all tokens.
     */
    function totalSupply() external view returns (uint256);
}
