// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { IJsonUtil } from "../interfaces/precompile/IJsonUtil.sol";

library JsonUtil {
    // solhint-disable private-vars-leading-underscore
    IJsonUtil internal constant JSON_UTIL = IJsonUtil(0x00000000000000000000000000000F043a000003);
    // solhint-enable private-vars-leading-underscore

    function get(string memory _jsonBlob, string memory _path) internal pure returns (string memory) {
        return JSON_UTIL.get(_jsonBlob, _path);
    }

    function getRaw(string memory _jsonBlob, string memory _path) internal pure returns (string memory) {
        return JSON_UTIL.getRaw(_jsonBlob, _path);
    }

    function getInt(string memory _jsonBlob, string memory _path) internal pure returns (int256) {
        return JSON_UTIL.getInt(_jsonBlob, _path);
    }

    function getUint(string memory _jsonBlob, string memory _path) internal pure returns (uint256) {
        return JSON_UTIL.getUint(_jsonBlob, _path);
    }

    function getBool(string memory _jsonBlob, string memory _path) internal pure returns (bool) {
        return JSON_UTIL.getBool(_jsonBlob, _path);
    }

    function dataURI(string memory _jsonBlob) internal pure returns (string memory) {
        return JSON_UTIL.dataURI(_jsonBlob);
    }

    function exists(string memory _jsonBlob, string memory _path) internal pure returns (bool) {
        return JSON_UTIL.exists(_jsonBlob, _path);
    }

    function validate(string memory _jsonBlob) internal pure returns (bool) {
        return JSON_UTIL.validate(_jsonBlob);
    }

    function compact(string memory _jsonBlob) internal pure returns (string memory) {
        return JSON_UTIL.compact(_jsonBlob);
    }

    function set(
        string memory _jsonBlob,
        string memory _path,
        string memory _value
    ) internal pure returns (string memory) {
        return JSON_UTIL.set(_jsonBlob, _path, _value);
    }

    function set(
        string memory _jsonBlob,
        string[] memory _paths,
        string[] memory _values
    ) internal pure returns (string memory) {
        return JSON_UTIL.set(_jsonBlob, _paths, _values);
    }

    function setRaw(
        string memory _jsonBlob,
        string memory _path,
        string memory _rawBlob
    ) internal pure returns (string memory) {
        return JSON_UTIL.setRaw(_jsonBlob, _path, _rawBlob);
    }

    function setRaw(
        string memory _jsonBlob,
        string[] memory _paths,
        string[] memory _rawBlobs
    ) internal pure returns (string memory) {
        return JSON_UTIL.setRaw(_jsonBlob, _paths, _rawBlobs);
    }

    function setInt(string memory _jsonBlob, string memory _path, int256 _value) internal pure returns (string memory) {
        return JSON_UTIL.setInt(_jsonBlob, _path, _value);
    }

    function setInt(
        string memory _jsonBlob,
        string[] memory _paths,
        int256[] memory _values
    ) internal pure returns (string memory) {
        return JSON_UTIL.setInt(_jsonBlob, _paths, _values);
    }

    function setUint(
        string memory _jsonBlob,
        string memory _path,
        uint256 _value
    ) internal pure returns (string memory) {
        return JSON_UTIL.setUint(_jsonBlob, _path, _value);
    }

    function setUint(
        string memory _jsonBlob,
        string[] memory _paths,
        uint256[] memory _values
    ) internal pure returns (string memory) {
        return JSON_UTIL.setUint(_jsonBlob, _paths, _values);
    }

    function setBool(string memory _jsonBlob, string memory _path, bool _value) internal pure returns (string memory) {
        return JSON_UTIL.setBool(_jsonBlob, _path, _value);
    }

    function setBool(
        string memory _jsonBlob,
        string[] memory _paths,
        bool[] memory _values
    ) internal pure returns (string memory) {
        return JSON_UTIL.setBool(_jsonBlob, _paths, _values);
    }

    function subReplace(
        string memory _jsonBlob,
        string memory _searchPath,
        string memory _replacePath,
        string memory _value
    ) internal pure returns (string memory) {
        return JSON_UTIL.subReplace(_jsonBlob, _searchPath, _replacePath, _value);
    }

    function subReplace(
        string memory _jsonBlob,
        string memory _searchPath,
        string[] memory _replacePaths,
        string[] memory _values
    ) internal pure returns (string memory) {
        return JSON_UTIL.subReplace(_jsonBlob, _searchPath, _replacePaths, _values);
    }

    function subReplaceInt(
        string memory _jsonBlob,
        string memory _searchPath,
        string memory _replacePath,
        int256 _value
    ) internal pure returns (string memory) {
        return JSON_UTIL.subReplaceInt(_jsonBlob, _searchPath, _replacePath, _value);
    }

    function subReplaceInt(
        string memory _jsonBlob,
        string memory _searchPath,
        string[] memory _replacePaths,
        int256[] memory _values
    ) internal pure returns (string memory) {
        return JSON_UTIL.subReplaceInt(_jsonBlob, _searchPath, _replacePaths, _values);
    }

    function subReplaceUint(
        string memory _jsonBlob,
        string memory _searchPath,
        string memory _replacePath,
        uint256 _value
    ) internal pure returns (string memory) {
        return JSON_UTIL.subReplaceUint(_jsonBlob, _searchPath, _replacePath, _value);
    }

    function subReplaceUint(
        string memory _jsonBlob,
        string memory _searchPath,
        string[] memory _replacePaths,
        uint256[] memory _values
    ) internal pure returns (string memory) {
        return JSON_UTIL.subReplaceUint(_jsonBlob, _searchPath, _replacePaths, _values);
    }

    function subReplaceBool(
        string memory _jsonBlob,
        string memory _searchPath,
        string memory _replacePath,
        bool _value
    ) internal pure returns (string memory) {
        return JSON_UTIL.subReplaceBool(_jsonBlob, _searchPath, _replacePath, _value);
    }

    function subReplaceBool(
        string memory _jsonBlob,
        string memory _searchPath,
        string[] memory _replacePaths,
        bool[] memory _values
    ) internal pure returns (string memory) {
        return JSON_UTIL.subReplaceBool(_jsonBlob, _searchPath, _replacePaths, _values);
    }

    function remove(string memory _jsonBlob, string memory _path) internal pure returns (string memory) {
        return JSON_UTIL.remove(_jsonBlob, _path);
    }


}
