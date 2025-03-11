// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC721Freezable {
    event TokenFrozen(address indexed owner, uint256 indexed recordId, uint256 indexed tokenId, uint48 expiresAt);
    event TokenThawed(address indexed owner, uint256 indexed recordId, uint256 indexed tokenId);

    /**
     * @dev Freezes a token for a given duration. Frozen tokens cannot be transferred or burned.
     */
    function freeze(address _owner, uint256 _tokenId, uint48 _freezeDuration) external returns (uint256 recordId);

    /**
     * @dev Thaws tokens that have expired freeze durations.
     */
    function thaw(uint256[] memory _recordIds) external;

    /**
     * @dev Returns the number of frozen tokens in ``owner``'s account.
     */
    function frozenBalanceOf(address _owner) external view returns (uint256 frozenBalance);

    /**
     * @dev Returns the number of unfrozen tokens in ``owner``'s account.
     */
    function unfrozenBalanceOf(address _owner) external view returns (uint256 unfrozenBalance);
}
