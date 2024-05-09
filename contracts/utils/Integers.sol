// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { IIntegers } from "../interfaces/precompile/IIntegers.sol";

/**
 * @dev String operations.
 */
library Integers {
    // solhint-disable private-vars-leading-underscore
    IIntegers internal constant INTEGERS = IIntegers(0x00000000000000000000000000000f043A000006);
    // solhint-enable private-vars-leading-underscore

    /// @dev Converts a `uint256` to its ASCII `string` representation.
    function toString(uint256 _value) internal pure returns (string memory) {
        return INTEGERS.toString(_value);
    }

    /// @dev Converts a `int256` to its ASCII `string` representation.
    function toString(int256 _value) internal pure returns (string memory) {
        return INTEGERS.toString(_value);
    }

    /// @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
    function toHexString(uint256 _value) internal pure returns (string memory) {
        return INTEGERS.toHexString(_value);
    }

    /// @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
    function toHexString(uint256 _value, uint256 _length) internal pure returns (string memory) {
        return INTEGERS.toHexString(_value, _length);
    }

    /// @dev Converts a hexadecimal `string` to its `uint256` representation.
    function fromHexString(string memory _str) internal pure returns (uint256) {
        return INTEGERS.fromHexString(_str);
    }
}
