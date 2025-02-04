// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { JsonUtil } from "../utils/JsonUtil.sol";
import { Strings } from "../utils/Strings.sol";
import { Attribute, StdTokenMetadata } from "../interfaces/metadata/ITokenMetadata.sol";
import { TokenMetadataUtils } from "./TokenMetadataUtils.sol";

library TokenMetadataEditor {
    function setTokenMetadataByPath(
        string memory _metadata,
        string memory _path,
        string memory _value
    ) internal pure returns (string memory) {
        return JsonUtil.set(_metadata, _path, _value);
    }

    function setTokenAttribute(
        string memory _metadata,
        Attribute memory _attribute
    ) internal pure returns (string memory) {
        string memory path = TokenMetadataUtils._tap(_attribute.traitType);
        bool exists = JsonUtil.exists(_metadata, path);
        if (exists) {
            _metadata = JsonUtil.subReplace(_metadata, path, "value", _attribute.value);
        } else {
            _metadata = JsonUtil.setRaw(
                _metadata,
                "attributes.-1",
                TokenMetadataUtils._tokenAttributeToJson(_attribute)
            );
        }
        return _metadata;
    }

    function setTokenAttribute(
        string memory _metadata,
        string memory _traitType,
        string memory _value
    ) internal pure returns (string memory) {
        string memory path = TokenMetadataUtils._tap(_traitType);
        bool exists = JsonUtil.exists(_metadata, path);
        if (exists) {
            _metadata = JsonUtil.subReplace(_metadata, path, "value", _value);
        } else {
            string memory attribute = "{}";
            string[] memory paths = new string[](2);
            paths[0] = "trait_type";
            paths[1] = "value";
            string[] memory values = new string[](2);
            values[0] = _traitType;
            values[1] = _value;
            attribute = JsonUtil.set(attribute, paths, values);
            _metadata = JsonUtil.setRaw(_metadata, "attributes.-1", attribute);
        }
        return _metadata;
    }

    function setTokenAttribute(
        string memory _metadata,
        string memory _traitType,
        int256 _value
    ) internal pure returns (string memory) {
        string memory path = TokenMetadataUtils._tap(_traitType);
        bool exists = JsonUtil.exists(_metadata, path);
        if (exists) {
            _metadata = JsonUtil.subReplaceInt(_metadata, path, "value", _value);
        } else {
            string memory attribute = JsonUtil.set("{}", "trait_type", _traitType);
            attribute = JsonUtil.setInt(attribute, "value", _value);
            _metadata = JsonUtil.setRaw(_metadata, "attributes.-1", attribute);
        }
        return _metadata;
    }

    function setTokenAttribute(
        string memory _metadata,
        string memory _traitType,
        uint256 _value
    ) internal pure returns (string memory) {
        string memory path = TokenMetadataUtils._tap(_traitType);
        bool exists = JsonUtil.exists(_metadata, path);
        if (exists) {
            _metadata = JsonUtil.subReplaceUint(_metadata, path, "value", _value);
        } else {
            string memory attribute = JsonUtil.set("{}", "trait_type", _traitType);
            attribute = JsonUtil.setUint(attribute, "value", _value);
            _metadata = JsonUtil.setRaw(_metadata, "attributes.-1", attribute);
        }
        return _metadata;
    }

    function setTokenAttribute(
        string memory _metadata,
        string memory _traitType,
        bool _value
    ) internal pure returns (string memory) {
        string memory path = TokenMetadataUtils._tap(_traitType);
        bool exists = JsonUtil.exists(_metadata, path);
        if (exists) {
            _metadata = JsonUtil.subReplaceBool(_metadata, path, "value", _value);
        } else {
            string memory attribute = JsonUtil.set("{}", "trait_type", _traitType);
            attribute = JsonUtil.setBool(attribute, "value", _value);
            _metadata = JsonUtil.setRaw(_metadata, "attributes.-1", attribute);
        }
        return _metadata;
    }
}
