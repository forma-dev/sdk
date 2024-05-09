// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { IBase64 } from "../interfaces/precompile/IBase64.sol";

library Base64 {
    // solhint-disable private-vars-leading-underscore
    IBase64 internal constant BASE64 = IBase64(0x00000000000000000000000000000f043a000004);
    // solhint-enable private-vars-leading-underscore

    /// @dev Encodes the input data into a base64 string
    function encode(bytes memory _data) internal pure returns (string memory) {
        return BASE64.encode(_data);
    }

    /// @dev Encodes the input data into a URL-safe base64 string
    function encodeURL(bytes memory _data) internal pure returns (string memory) {
        return BASE64.encodeURL(_data);
    }

    /// @dev Decodes the input base64 string into bytes
    function decode(string memory _data) internal pure returns (bytes memory) {
        return BASE64.decode(_data);
    }

    /// @dev Decodes the input URL-safe base64 string into bytes
    function decodeURL(string memory _data) internal pure returns (bytes memory) {
        return BASE64.decodeURL(_data);
    }
}
