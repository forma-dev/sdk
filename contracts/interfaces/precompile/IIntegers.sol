// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IIntegers {
    /// @dev Converts a `uint256` to its ASCII `string` representation.
    function toString(uint256 _i) external pure returns (string memory);

    /// @dev Converts a `int256` to its ASCII `string` representation.
    function toString(int256 _i) external pure returns (string memory);

    /// @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
    function toHexString(uint256 _i) external pure returns (string memory);

    /// @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
    function toHexString(uint256 _i, uint256 _length) external pure returns (string memory);

    /// @dev Converts a hexadecimal `string` to its `uint256` representation.
    function fromHexString(string memory _str) external pure returns (uint256);
}
