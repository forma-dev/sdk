// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { IERC1155F } from "../../interfaces/token/IERC1155F.sol";
import { ERC1155 as ERC1155OpenZeppelin } from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import { ERC2981 } from "@openzeppelin/contracts/token/common/ERC2981.sol";

abstract contract ERC1155Base is IERC1155F, ERC1155OpenZeppelin, ERC2981 {
    mapping(uint256 id => uint256) private _totalSupply;
    uint256 private _totalSupplyAll;
    mapping(address owner => uint256 balance) private _balances;
    mapping(address owner => uint256[] tokenIds) private _ownedTokens;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC1155OpenZeppelin, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address _owner) public view virtual returns (uint256) {
        return _balances[_owner];
    }

    /**
     * @dev Returns the tokenIds owned by ``owner``'s account.
     */
    function ownedTokens(address _owner) public view virtual returns (uint256[] memory) {
        return _ownedTokens[_owner];
    }

    /**
     * @dev Total value of tokens in with a given id.
     */
    function totalSupply(uint256 id) public view virtual returns (uint256) {
        return _totalSupply[id];
    }

    /**
     * @dev Total value of tokens.
     */
    function totalSupply() public view virtual returns (uint256) {
        return _totalSupplyAll;
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
        super._update(from, to, ids, values);

        if (from == address(0)) {
            uint256 totalMintValue = 0;
            for (uint256 i = 0; i < ids.length; ++i) {
                uint256 value = values[i];
                // Overflow check required: The rest of the code assumes that totalSupply never overflows
                _totalSupply[ids[i]] += value;
                totalMintValue += value;
            }
            // Overflow check required: The rest of the code assumes that totalSupplyAll never overflows
            _totalSupplyAll += totalMintValue;
            _balances[to] += totalMintValue;
        }

        if (to == address(0)) {
            uint256 totalBurnValue = 0;
            for (uint256 i = 0; i < ids.length; ++i) {
                uint256 value = values[i];

                unchecked {
                    // Overflow not possible: values[i] <= balanceOf(from, ids[i]) <= totalSupply(ids[i])
                    _totalSupply[ids[i]] -= value;
                    // Overflow not possible: sum_i(values[i]) <= sum_i(totalSupply(ids[i])) <= totalSupplyAll
                    totalBurnValue += value;
                }
            }
            unchecked {
                // Overflow not possible: totalBurnValue = sum_i(values[i]) <= sum_i(totalSupply(ids[i])) <= totalSupplyAll
                _totalSupplyAll -= totalBurnValue;
                _balances[from] -= totalBurnValue;
            }
        }
    }
}
