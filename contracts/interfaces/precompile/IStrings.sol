// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IStrings {
    /// @dev Checks if two strings are equal
    function equal(string memory _a, string memory _b) external pure returns (bool);

    /// @dev Checks if two strings are equal, ignoring case
    function equalCaseFold(string memory _a, string memory _b) external pure returns (bool);

    /// @dev Checks if a string contains a substring
    function contains(string memory _str, string memory _substr) external pure returns (bool);

    /// @dev Checks if a string starts with a substring
    function startsWith(string memory _str, string memory _substr) external pure returns (bool);

    /// @dev Checks if a string ends with a substring
    function endsWith(string memory _str, string memory _substr) external pure returns (bool);

    /// @dev Returns the index of a substring in a string
    function indexOf(string memory _str, string memory _substr) external pure returns (uint256);

    /// @dev Converts a string to upper case
    function toUpperCase(string memory _str) external pure returns (string memory);

    /// @dev Converts a string to lower case
    function toLowerCase(string memory _str) external pure returns (string memory);

    /// @dev Pads a string from the start
    function padStart(string memory _str, uint16 _len, string memory _pad) external pure returns (string memory);

    /// @dev Pads a string from the end
    function padEnd(string memory _str, uint16 _len, string memory _pad) external pure returns (string memory);

    /// @dev Repeats a string a number of times
    function repeat(string memory _str, uint16 _count) external pure returns (string memory);

    /// @dev Replaces a substring in a string a number of times
    function replace(
        string memory _str,
        string memory _old,
        string memory _new,
        uint16 _n
    ) external pure returns (string memory);

    /// @dev Replaces all occurrences of a substring in a string
    function replaceAll(
        string memory _str,
        string memory _old,
        string memory _new
    ) external pure returns (string memory);

    /// @dev Splits a string by a delimiter
    function split(string memory _str, string memory _delim) external pure returns (string[] memory);

    /// @dev Trims whitespace from a string
    function trim(string memory _str) external pure returns (string memory);
}
