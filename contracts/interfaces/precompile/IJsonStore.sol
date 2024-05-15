// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IJsonStore {
    function exists(address _key, bytes32 _slot) external view returns (bool);

    function uri(address _key, bytes32 _slot) external view returns (string memory);

    function get(address _key, bytes32 _slot) external view returns (string memory);

    function prepaid(address _key) external view returns (uint64);

    function exists(bytes32 _slot) external view returns (bool);

    function uri(bytes32 _slot) external view returns (string memory);

    function get(bytes32 _slot) external view returns (string memory);

    function prepaid() external view returns (uint64);

    function set(bytes32 _slot, string memory _jsonBlob) external returns (bool);

    function clear(bytes32 _slot) external returns (bool);

    function prepay(uint64 _numSlots) external returns (bool);
}
