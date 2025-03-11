// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ERC1155BaseUpgradeable } from "../ERC1155BaseUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { IERC1155Freezable } from "../../../../interfaces/token/IERC1155Freezable.sol";

abstract contract ERC1155FreezableUpgradeable is Initializable, ERC1155BaseUpgradeable, IERC1155Freezable {
    struct FreezeRecord {
        address owner;
        uint256 tokenId;
        uint256 amount;
        uint48 expiresAt;
    }

    /// @custom:storage-location erc7201:forma.storage.ERC1155FreezableStorage
    struct ERC1155FreezableStorage {
        mapping(address owner => uint256 frozenBalance) _frozenBalances;
        mapping(address owner => mapping(uint256 tokenId => uint256 frozenBalance)) _frozenTokenBalances;
        uint256 _nextFreezeRecordId;
        mapping(uint256 recordId => FreezeRecord record) _freezeRecords;
    }

    // keccak256(abi.encode(uint256(keccak256("forma.storage.ERC1155FreezableStorage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant ERC1155FreezableStorageLocation =
        0xc61a1e6417967f153a8f0ef8de6071063f2760405326dedaadaf9e0ae7b04500;

    function _getERC1155FreezableStorage() private pure returns (ERC1155FreezableStorage storage s) {
        assembly {
            s.slot := ERC1155FreezableStorageLocation
        }
    }

    // solhint-disable func-name-mixedcase
    function __ERC1155Freezable_init() internal onlyInitializing {}

    function __ERC1155Freezable_init_unchained() internal onlyInitializing {}
    // solhint-enable func-name-mixedcase

    /**
     * @dev Freezes an amount of tokens for a given duration. Frozen tokens cannot be transferred or burned.
     */
    function freeze(
        address _owner,
        uint256 _tokenId,
        uint256 _amount,
        uint48 _freezeDuration
    ) external virtual override returns (uint256) {
        require(
            _owner == _msgSender() || isApprovedForAll(_owner, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );

        ERC1155FreezableStorage storage s = _getERC1155FreezableStorage();

        uint256 unfrozenBalance = balanceOf(_owner, _tokenId) - s._frozenTokenBalances[_owner][_tokenId];
        require(unfrozenBalance >= _amount, "ERC1155Freezable: insufficient unfrozen balance");

        uint48 expiresAt = uint48(block.timestamp) + _freezeDuration;

        s._frozenBalances[_owner] += _amount;
        s._frozenTokenBalances[_owner][_tokenId] += _amount;

        uint256 recordId = ++s._nextFreezeRecordId;
        s._freezeRecords[recordId] = FreezeRecord({
            owner: _owner,
            tokenId: _tokenId,
            amount: _amount,
            expiresAt: expiresAt
        });

        emit TokensFrozen(_owner, recordId, _tokenId, _amount, expiresAt);

        return recordId;
    }

    /**
     * @dev Thaws an amount of tokens.
     */
    function thaw(uint256[] memory _recordIds) external virtual override {
        ERC1155FreezableStorage storage s = _getERC1155FreezableStorage();

        for (uint256 i = 0; i < _recordIds.length; i++) {
            uint256 recordId = _recordIds[i];
            require(s._freezeRecords[recordId].expiresAt > 0, "ERC1155Freezable: record does not exist");
            require(s._freezeRecords[recordId].expiresAt < block.timestamp, "ERC1155Freezable: record has not expired");

            FreezeRecord memory record = s._freezeRecords[recordId];
            s._frozenBalances[record.owner] -= record.amount;
            s._frozenTokenBalances[record.owner][record.tokenId] -= record.amount;

            emit TokensThawed(record.owner, recordId, record.tokenId, record.amount);
            delete s._freezeRecords[recordId];
        }
    }

    /**
     * @dev Returns the number of frozen tokens in ``owner``'s account for a given tokenId.
     */
    function frozenBalanceOf(address _owner, uint256 _tokenId) external view virtual override returns (uint256) {
        ERC1155FreezableStorage storage s = _getERC1155FreezableStorage();
        return s._frozenTokenBalances[_owner][_tokenId];
    }

    /**
     * @dev Returns the number of unfrozen tokens in ``owner``'s account for a given tokenId.
     */
    function unfrozenBalanceOf(address _owner, uint256 _tokenId) external view virtual override returns (uint256) {
        ERC1155FreezableStorage storage s = _getERC1155FreezableStorage();
        return balanceOf(_owner, _tokenId) - s._frozenTokenBalances[_owner][_tokenId];
    }

    /**
     * @dev Returns the number of frozen tokens in ``owner``'s account.
     */
    function frozenBalanceOf(address _owner) external view virtual override returns (uint256) {
        ERC1155FreezableStorage storage s = _getERC1155FreezableStorage();
        return s._frozenBalances[_owner];
    }

    /**
     * @dev Returns the number of unfrozen tokens in ``owner``'s account.
     */
    function unfrozenBalanceOf(address _owner) external view virtual override returns (uint256) {
        ERC1155FreezableStorage storage s = _getERC1155FreezableStorage();
        return balanceOf(_owner) - s._frozenBalances[_owner];
    }

    /**
     * @dev See {ERC1155-_update}.
     */
    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) internal virtual override {
        ERC1155FreezableStorage storage s = _getERC1155FreezableStorage();

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 tokenId = ids[i];
            uint256 amount = values[i];

            // check if there are enough unfrozen tokens to cover the amount
            if (s._frozenTokenBalances[from][tokenId] > 0) {
                require(
                    balanceOf(from, tokenId) - s._frozenTokenBalances[from][tokenId] >= amount,
                    "ERC1155Freezable: insufficient unfrozen balance"
                );
            }
        }
        super._update(from, to, ids, values);
    }
}
