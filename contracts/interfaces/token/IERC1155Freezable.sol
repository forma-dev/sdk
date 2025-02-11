// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC1155Freezable {
    /**
     * @dev Freezes an amount of tokens for a given duration. Frozen tokens cannot be transferred or burned.
     */
    function freeze(address _owner, uint256 _tokenId, uint256 _amount, uint48 _freezeDuration) external;

    /**
     * @dev Thaws an amount of tokens.
     */
    function thaw(address _owner, uint256 _tokenId, uint256 _amount) external;

    /**
     * @dev Returns the number of frozen tokens in ``owner``'s account for a given tokenId.
     */
    function frozenBalanceOf(address _owner, uint256 _tokenId) external view returns (uint256 frozenBalance);

    /**
     * @dev Returns the number of unfrozen tokens in ``owner``'s account for a given tokenId.
     */
    function unfrozenBalanceOf(address _owner, uint256 _tokenId) external view returns (uint256 unfrozenBalance);

    /**
     * @dev Returns the number of frozen tokens in ``owner``'s account.
     */
    function frozenBalanceOf(address _owner) external view returns (uint256 frozenBalance);

    /**
     * @dev Returns the number of unfrozen tokens in ``owner``'s account.
     */
    function unfrozenBalanceOf(address _owner) external view returns (uint256 unfrozenBalance);

    /**
     * @dev Returns the tokenIds frozen by ``owner``'s account.
     */
    function frozenTokens(address _owner) external view returns (uint256[] memory tokenIds);

    /**
     * @dev Returns the tokenIds unfrozen by ``owner``'s account.
     */
    function unfrozenTokens(address _owner) external view returns (uint256[] memory tokenIds);
}
