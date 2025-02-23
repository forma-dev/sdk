// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {
    ERC1155Upgradeable as ERC1155UpgradeableOZ
} from "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import { ERC2981Upgradeable } from "@openzeppelin/contracts-upgradeable/token/common/ERC2981Upgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract ERC1155BaseUpgradeable is Initializable, ERC2981Upgradeable, ERC1155UpgradeableOZ {
    /// @custom:storage-location erc7201:forma.storage.ERC1155BaseStorage
    struct ERC1155BaseStorage {
        mapping(uint256 id => uint256) _totalSupply;
        uint256 _totalSupplyAll;
        mapping(address owner => uint256 balance) _balances;
        mapping(address owner => uint256[] tokenIds) _ownedTokens;
    }

    // keccak256(abi.encode(uint256(keccak256("forma.storage.ERC1155BaseStorage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant ERC1155BaseStorageLocation =
        0x5e2d329ff12c1400f00ab0302af4a89b75ff67559ab6b5daa0d0a048e123df00;

    function _getERC1155BaseStorage() private pure returns (ERC1155BaseStorage storage s) {
        assembly {
            s.slot := ERC1155BaseStorageLocation
        }
    }

    // solhint-disable func-name-mixedcase
    function __ERC1155Base_init() internal onlyInitializing {}

    function __ERC1155Base_init_unchained() internal onlyInitializing {}
    // solhint-enable func-name-mixedcase

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC1155UpgradeableOZ, ERC2981Upgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address _owner) public view virtual returns (uint256) {
        ERC1155BaseStorage storage s = _getERC1155BaseStorage();
        return s._balances[_owner];
    }

    /**
     * @dev Returns the tokenIds owned by ``owner``'s account.
     */
    function ownedTokens(address _owner) public view virtual returns (uint256[] memory) {
        ERC1155BaseStorage storage s = _getERC1155BaseStorage();
        return s._ownedTokens[_owner];
    }

    /**
     * @dev Total value of tokens in with a given id.
     */
    function totalSupply(uint256 id) public view virtual returns (uint256) {
        ERC1155BaseStorage storage s = _getERC1155BaseStorage();
        return s._totalSupply[id];
    }

    /**
     * @dev Total value of tokens.
     */
    function totalSupply() public view virtual returns (uint256) {
        ERC1155BaseStorage storage s = _getERC1155BaseStorage();
        return s._totalSupplyAll;
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
        ERC1155BaseStorage storage s = _getERC1155BaseStorage();
        super._update(from, to, ids, values);

        if (from == address(0)) {
            uint256 totalMintValue = 0;
            for (uint256 i = 0; i < ids.length; ++i) {
                uint256 value = values[i];
                // Overflow check required: The rest of the code assumes that totalSupply never overflows
                s._totalSupply[ids[i]] += value;
                totalMintValue += value;
            }
            // Overflow check required: The rest of the code assumes that totalSupplyAll never overflows
            s._totalSupplyAll += totalMintValue;
            s._balances[to] += totalMintValue;
        }

        if (to == address(0)) {
            uint256 totalBurnValue = 0;
            for (uint256 i = 0; i < ids.length; ++i) {
                uint256 value = values[i];

                unchecked {
                    // Overflow not possible: values[i] <= balanceOf(from, ids[i]) <= totalSupply(ids[i])
                    s._totalSupply[ids[i]] -= value;
                    // Overflow not possible: sum_i(values[i]) <= sum_i(totalSupply(ids[i])) <= totalSupplyAll
                    totalBurnValue += value;
                }
            }
            unchecked {
                // Overflow not possible: totalBurnValue = sum_i(values[i]) <= sum_i(totalSupply(ids[i])) <= totalSupplyAll
                s._totalSupplyAll -= totalBurnValue;
                s._balances[from] -= totalBurnValue;
            }
        }
    }
}
