// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC721Freezable {
    /**
     * @dev Freezes a token for a given duration. Frozen tokens cannot be transferred or burned.
     */
    function freeze(address _owner, uint256 _tokenId, uint48 _freezeDuration) external;

    /**
     * @dev Thaws a token.
     */
    function thaw(address _owner, uint256 _tokenId) external;

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
