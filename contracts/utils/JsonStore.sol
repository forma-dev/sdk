// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { IJsonStore } from "../interfaces/precompile/IJsonStore.sol";

library JsonStore {
    // solhint-disable private-vars-leading-underscore
    IJsonStore internal constant STORE = IJsonStore(0x00000000000000000000000000000F043a000007);
    // solhint-enable private-vars-leading-underscore

    function exists(address _key, bytes32 _slot) internal view returns (bool) {
        return STORE.exists(_key, _slot);
    }

    function uri(address _key, bytes32 _slot) internal view returns (string memory) {
        return STORE.uri(_key, _slot);
    }

    function get(address _key, bytes32 _slot) internal view returns (string memory) {
        return STORE.get(_key, _slot);
    }

    function prepaid(address _key) internal view returns (uint64) {
        return STORE.prepaid(_key);
    }

    function exists(bytes32 _slot) internal view returns (bool) {
        return STORE.exists(_slot);
    }

    function uri(bytes32 _slot) internal view returns (string memory) {
        return STORE.uri(_slot);
    }

    function get(bytes32 _slot) internal view returns (string memory) {
        return STORE.get(_slot);
    }

    function prepaid() internal view returns (uint64) {
        return STORE.prepaid();
    }

    function set(bytes32 _slot, string memory _jsonBlob) internal returns (bool) {
        return STORE.set(_slot, _jsonBlob);
    }

    function clear(bytes32 _slot) internal returns (bool) {
        return STORE.clear(_slot);
    }

    function prepay(uint64 _numSlots) internal returns (bool) {
        return STORE.prepay(_numSlots);
    }
}
