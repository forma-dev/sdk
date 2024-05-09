// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { IStrings } from "../interfaces/precompile/IStrings.sol";

/**
 * @dev String operations.
 */
library Strings {
    // solhint-disable private-vars-leading-underscore
    IStrings internal constant STRINGS = IStrings(0x00000000000000000000000000000F043A000005);
    // solhint-enable private-vars-leading-underscore

    /**
     * @dev Returns true if the two strings are equal.
     */
    function equal(string memory _a, string memory _b) internal pure returns (bool) {
        return STRINGS.equal(_a, _b);
    }

    /**
     * @dev Returns true if the two strings are equal, ignoring case.
     */
    function equalCaseFold(string memory _a, string memory _b) internal pure returns (bool) {
        return STRINGS.equalCaseFold(_a, _b);
    }

    /**
     * @dev Checks if a string contains a given substring.
     * @param _str The string to search within.
     * @param _substr The substring to search for.
     * @return A boolean indicating whether the substring is found within the string.
     */
    function contains(string memory _str, string memory _substr) internal pure returns (bool) {
        return STRINGS.contains(_str, _substr);
    }

    /**
     * @dev Checks if a string starts with a given substring.
     * @param _str The string to check.
     * @param _substr The substring to check for.
     * @return A boolean indicating whether the string starts with the substring.
     */
    function startsWith(string memory _str, string memory _substr) internal pure returns (bool) {
        return STRINGS.startsWith(_str, _substr);
    }

    /**
     * @dev Checks if a string ends with a given substring.
     * @param _str The string to check.
     * @param _substr The substring to check for.
     * @return A boolean indicating whether the string ends with the substring.
     */
    function endsWith(string memory _str, string memory _substr) internal pure returns (bool) {
        return STRINGS.endsWith(_str, _substr);
    }

    /**
     * @dev Returns the index of the first occurrence of a substring within a string.
     */
    function indexOf(string memory _str, string memory _substr) internal pure returns (uint256) {
        return STRINGS.indexOf(_str, _substr);
    }

    /**
     * @dev Converts all the characters of a string to uppercase.
     */
    function toUpperCase(string memory _str) internal pure returns (string memory) {
        return STRINGS.toUpperCase(_str);
    }

    /**
     * @dev Converts all the characters of a string to lowercase.
     */
    function toLowerCase(string memory _str) internal pure returns (string memory) {
        return STRINGS.toLowerCase(_str);
    }

    /**
     * @dev Pads the start of a string with a given pad string up to a specified length.
     */
    function padStart(string memory _str, uint16 _len, string memory _pad) internal pure returns (string memory) {
        return STRINGS.padStart(_str, _len, _pad);
    }

    /**
     * @dev Pads the end of a string with a given pad string up to a specified length.
     */
    function padEnd(string memory _str, uint16 _len, string memory _pad) internal pure returns (string memory) {
        return STRINGS.padEnd(_str, _len, _pad);
    }

    /**
     * @dev Repeats a string a specified number of times.
     */
    function repeat(string memory _str, uint16 _count) internal pure returns (string memory) {
        return STRINGS.repeat(_str, _count);
    }

    /**
     * @dev Replaces a specified number of occurrences of a substring within a string with a new substring.
     * @param _str The original string.
     * @param _old The substring to be replaced.
     * @param _new The new substring to replace the old substring.
     * @param _n The number of occurrences to replace.
     * @return A new string with the specified number of occurrences of the old substring replaced by the new substring.
     */
    function replace(
        string memory _str,
        string memory _old,
        string memory _new,
        uint16 _n
    ) internal pure returns (string memory) {
        return STRINGS.replace(_str, _old, _new, _n);
    }

    /**
     * @dev Replaces all occurrences of a substring within a string with a new substring.
     */
    function replaceAll(
        string memory _str,
        string memory _old,
        string memory _new
    ) internal pure returns (string memory) {
        return STRINGS.replaceAll(_str, _old, _new);
    }

    /**
     * @dev Splits a string into an array of substrings using a specified delimiter.
     */
    function split(string memory _str, string memory _delim) internal pure returns (string[] memory) {
        return STRINGS.split(_str, _delim);
    }

    /**
     * @dev Trims whitespace from the start and end of a string.
     */
    function trim(string memory _str) internal pure returns (string memory) {
        return STRINGS.trim(_str);
    }
}
