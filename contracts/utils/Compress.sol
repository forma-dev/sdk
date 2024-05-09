// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ICompress } from "../interfaces/precompile/ICompress.sol";

library Compress {
    // solhint-disable private-vars-leading-underscore
    ICompress internal constant COMPRESS = ICompress(0x00000000000000000000000000000f043A000002);
    // solhint-enable private-vars-leading-underscore

    /// @dev Compresses the input data
    function compress(bytes memory _data) internal pure returns (bytes memory) {
        return COMPRESS.compress(_data);
    }

    /// @dev Decompresses the input data
    function decompress(bytes memory _data) internal pure returns (bytes memory) {
        return COMPRESS.decompress(_data);
    }
}
