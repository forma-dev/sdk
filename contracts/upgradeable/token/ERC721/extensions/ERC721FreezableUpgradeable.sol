// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ERC721BaseUpgradeable } from "../ERC721BaseUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { IERC721Freezable } from "../../../../interfaces/token/IERC721Freezable.sol";

abstract contract ERC721FreezableUpgradeable is Initializable, ERC721BaseUpgradeable, IERC721Freezable {
    struct FreezeRecord {
        uint256 tokenId;
        uint48 expiresAt;
    }

    /// @custom:storage-location erc7201:forma.storage.ERC721FreezableStorage
    struct ERC721FreezableStorage {
        mapping(address owner => uint256 frozenBalance) _frozenBalances;
        mapping(uint256 tokenId => bool frozen) _frozenTokens;
        uint256 _nextFreezeRecordId;
        mapping(uint256 recordId => FreezeRecord record) _freezeRecords;
    }

    // keccak256(abi.encode(uint256(keccak256("forma.storage.ERC721FreezableStorage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant ERC721FreezableStorageLocation =
        0x6780b90a280555f67bfff1673e15e3e00ee0ec09077c0c0e6a5a7adff91d3600;

    function _getERC721FreezableStorage() private pure returns (ERC721FreezableStorage storage s) {
        assembly {
            s.slot := ERC721FreezableStorageLocation
        }
    }

    // solhint-disable func-name-mixedcase
    function __ERC721Freezable_init() internal onlyInitializing {}

    function __ERC721Freezable_init_unchained() internal onlyInitializing {}
    // solhint-enable func-name-mixedcase

    /**
     * @dev Freezes an amount of tokens for a given duration. Frozen tokens cannot be transferred or burned.
     */
    function freeze(
        address _owner,
        uint256 _tokenId,
        uint48 _freezeDuration
    ) external virtual override returns (uint256) {
        ERC721FreezableStorage storage s = _getERC721FreezableStorage();

        require(
            _isAuthorized(_owner, _msgSender(), _tokenId),
            "ERC721Freezable: caller is not token owner or approved"
        );
        require(!s._frozenTokens[_tokenId], "ERC721Freezable: token is already frozen");

        uint48 expiresAt = uint48(block.timestamp) + _freezeDuration;
        uint256 recordId = ++s._nextFreezeRecordId;
        s._freezeRecords[recordId] = FreezeRecord({ tokenId: _tokenId, expiresAt: expiresAt });

        emit TokenFrozen(_owner, recordId, _tokenId, expiresAt);

        return recordId;
    }

    /**
     * @dev Thaws an amount of tokens.
     */
    function thaw(uint256[] memory _recordIds) external virtual override {
        ERC721FreezableStorage storage s = _getERC721FreezableStorage();

        for (uint256 i = 0; i < _recordIds.length; i++) {
            uint256 recordId = _recordIds[i];
            require(s._freezeRecords[recordId].expiresAt > 0, "ERC721Freezable: record does not exist");
            require(s._freezeRecords[recordId].expiresAt < block.timestamp, "ERC721Freezable: record has not expired");

            FreezeRecord memory record = s._freezeRecords[recordId];
            delete s._frozenTokens[record.tokenId];
            delete s._freezeRecords[recordId];

            emit TokenThawed(_ownerOf(record.tokenId), recordId, record.tokenId);
        }
    }

    /**
     * @dev Returns the number of frozen tokens in ``owner``'s account.
     */
    function frozenBalanceOf(address _owner) external view virtual override returns (uint256) {
        ERC721FreezableStorage storage s = _getERC721FreezableStorage();
        return s._frozenBalances[_owner];
    }

    /**
     * @dev Returns the number of unfrozen tokens in ``owner``'s account.
     */
    function unfrozenBalanceOf(address _owner) external view virtual override returns (uint256) {
        ERC721FreezableStorage storage s = _getERC721FreezableStorage();
        return balanceOf(_owner) - s._frozenBalances[_owner];
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC721Freezable).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {ERC721-_update}.
     */
    function _update(address to, uint256 tokenId, address auth) internal virtual override returns (address) {
        ERC721FreezableStorage storage s = _getERC721FreezableStorage();

        address from = _ownerOf(tokenId);
        if (from != address(0)) {
            require(!s._frozenTokens[tokenId], "ERC721Freezable: token is frozen");
        }
        return super._update(to, tokenId, auth);
    }
}
