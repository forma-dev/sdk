// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ERC721Base } from "../ERC721Base.sol";
import { IERC721Freezable } from "../../../interfaces/token/IERC721Freezable.sol";

abstract contract ERC721Freezable is ERC721Base, IERC721Freezable {
    mapping(address owner => uint256 frozenBalance) private _frozenBalances;
    mapping(uint256 tokenId => bool frozen) private _frozenTokens;

    struct FreezeRecord {
        uint256 tokenId;
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
        uint48 _freezeDuration
    ) external virtual override returns (uint256) {
        require(
            _isAuthorized(_owner, _msgSender(), _tokenId),
            "ERC721Freezable: caller is not token owner or approved"
        );
        require(!_frozenTokens[_tokenId], "ERC721Freezable: token is already frozen");

        uint48 expiresAt = uint48(block.timestamp) + _freezeDuration;
        uint256 recordId = ++_nextFreezeRecordId;
        _freezeRecords[recordId] = FreezeRecord({ tokenId: _tokenId, expiresAt: expiresAt });

        emit TokenFrozen(_owner, recordId, _tokenId, expiresAt);

        return recordId;
    }

    /**
     * @dev Thaws an amount of tokens.
     */
    function thaw(uint256[] memory _recordIds) external virtual override {
        for (uint256 i = 0; i < _recordIds.length; i++) {
            uint256 recordId = _recordIds[i];
            require(_freezeRecords[recordId].expiresAt > 0, "ERC721Freezable: record does not exist");
            require(_freezeRecords[recordId].expiresAt < block.timestamp, "ERC721Freezable: record has not expired");

            FreezeRecord memory record = _freezeRecords[recordId];
            delete _frozenTokens[record.tokenId];
            delete _freezeRecords[recordId];

            emit TokenThawed(_ownerOf(record.tokenId), recordId, record.tokenId);
        }
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
        return interfaceId == type(IERC721Freezable).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {ERC721-_update}.
     */
    function _update(address to, uint256 tokenId, address auth) internal virtual override returns (address) {
        address from = _ownerOf(tokenId);
        if (from != address(0)) {
            require(!_frozenTokens[tokenId], "ERC721Freezable: token is frozen");
        }
        return super._update(to, tokenId, auth);
    }
}
