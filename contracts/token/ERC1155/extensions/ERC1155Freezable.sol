// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ERC1155Base } from "../ERC1155Base.sol";
import { IERC1155Freezable } from "../../../interfaces/token/IERC1155Freezable.sol";

abstract contract ERC1155Freezable is ERC1155Base, IERC1155Freezable {
    mapping(address owner => uint256 frozenBalance) private _frozenBalances;
    mapping(address owner => mapping(uint256 tokenId => uint256 frozenBalance)) private _frozenTokenBalances;

    struct FreezeRecord {
        address owner;
        uint256 tokenId;
        uint256 amount;
        uint48 expiresAt;
    }

    uint256 private _nextFreezeRecordId;
    mapping(uint256 recordId => FreezeRecord record) private _freezeRecords;

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

        uint256 unfrozenBalance = balanceOf(_owner, _tokenId) - _frozenTokenBalances[_owner][_tokenId];
        require(unfrozenBalance >= _amount, "ERC1155Freezable: insufficient unfrozen balance");

        uint48 expiresAt = uint48(block.timestamp) + _freezeDuration;

        _frozenBalances[_owner] += _amount;
        _frozenTokenBalances[_owner][_tokenId] += _amount;

        uint256 recordId = ++_nextFreezeRecordId;
        _freezeRecords[recordId] = FreezeRecord({
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
        for (uint256 i = 0; i < _recordIds.length; i++) {
            uint256 recordId = _recordIds[i];
            require(_freezeRecords[recordId].expiresAt > 0, "ERC1155Freezable: record does not exist");
            require(_freezeRecords[recordId].expiresAt < block.timestamp, "ERC1155Freezable: record has not expired");

            FreezeRecord memory record = _freezeRecords[recordId];
            _frozenBalances[record.owner] -= record.amount;
            _frozenTokenBalances[record.owner][record.tokenId] -= record.amount;

            delete _freezeRecords[recordId];

            emit TokensThawed(record.owner, recordId, record.tokenId, record.amount);
        }
    }

    /**
     * @dev Returns the number of frozen tokens in ``owner``'s account for a given tokenId.
     */
    function frozenBalanceOf(address _owner, uint256 _tokenId) external view virtual override returns (uint256) {
        return _frozenTokenBalances[_owner][_tokenId];
    }

    /**
     * @dev Returns the number of unfrozen tokens in ``owner``'s account for a given tokenId.
     */
    function unfrozenBalanceOf(address _owner, uint256 _tokenId) external view virtual override returns (uint256) {
        return balanceOf(_owner, _tokenId) - _frozenTokenBalances[_owner][_tokenId];
    }

    /**
     * @dev Returns the number of frozen tokens in ``owner``'s account.
     */
    function frozenBalanceOf(address _owner) external view virtual override returns (uint256) {
        return _frozenBalances[_owner];
    }

    /**
     * @dev Returns the number of unfrozen tokens in ``owner``'s account.
     */
    function unfrozenBalanceOf(address _owner) external view virtual override returns (uint256) {
        return balanceOf(_owner) - _frozenBalances[_owner];
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC1155Freezable).interfaceId || super.supportsInterface(interfaceId);
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
        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 tokenId = ids[i];
            uint256 amount = values[i];

            // check if there are enough unfrozen tokens to cover the amount
            if (_frozenTokenBalances[from][tokenId] > 0) {
                require(
                    balanceOf(from, tokenId) - _frozenTokenBalances[from][tokenId] >= amount,
                    "ERC1155Freezable: insufficient unfrozen balance"
                );
            }
        }
        super._update(from, to, ids, values);
    }
}
