// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Attribute } from "../interfaces/metadata/ITokenMetadata.sol";
import { JsonUtil } from "../utils/JsonUtil.sol";
import { Strings } from "../utils/Strings.sol";

library TokenMetadataUtils {
    function _tokenAttributeToJson(Attribute memory _attribute) internal pure returns (string memory) {
        string memory attribute = "{}";
        string[] memory paths = new string[](2);
        paths[0] = "trait_type";
        paths[1] = "value";
        string[] memory values = new string[](2);
        values[0] = _attribute.traitType;
        values[1] = _attribute.value;
        attribute = JsonUtil.set(attribute, paths, values);
        if (bytes(_attribute.displayType).length > 0) {
            attribute = JsonUtil.set(attribute, "display_type", _attribute.displayType);
        }
        return attribute;
    }

    function _tap(string memory _traitType) internal pure returns (string memory) {
        return Strings.replace('attributes.#(trait_type==":trait_type:")', ":trait_type:", _traitType, 1);
    }

    function _tavp(string memory _traitType) internal pure returns (string memory) {
        return Strings.replace('attributes.#(trait_type==":trait_type:").value', ":trait_type:", _traitType, 1);
    }
}
