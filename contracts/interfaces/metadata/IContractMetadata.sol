// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24;

struct RequiredContractMetadata {
    string name;
}

struct StdContractMetadata {
    string name;
    string description;
    string image;
    string externalLink;
    string[] collaborators;
}

struct FullContractMetadata {
    string name;
    string description;
    string image;
    string bannerImage;
    string featuredImage;
    string externalLink;
    string[] collaborators;
}

interface IContractMetadata {
    /// @dev Returns the metadata URI of the contract.
    function contractURI() external view returns (string memory);

    function contractURICemented() external view returns (bool);

    function setContractMetadata(RequiredContractMetadata memory _data) external;

    function setContractMetadata(StdContractMetadata memory _data) external;

    function setContractMetadata(FullContractMetadata memory _data) external;

    function setContractMetadataRaw(string memory _jsonBlob) external;

    function cementContractMetadata() external;

    /// @dev Emitted when the contract metadata is updated.
    event ContractURIUpdated();

    event ContractURICemented();

    /// @dev The sender is not authorized to perform the action
    error ContractMetadataUnauthorized();

    error ContractMetadataCemented();
}
