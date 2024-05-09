// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ICompress {
    /// @dev Compresses the input data
    function compress(bytes memory _data) external pure returns (bytes memory);

    /// @dev Decompresses the input data
    function decompress(bytes memory _data) external pure returns (bytes memory);
}
