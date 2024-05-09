// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface INativeMinter {
    /////////////////////////////////////// READ METHODS //////////////////////////////////////////

    /// @dev Returns the current owner of the contract
    function owner() external view returns (address);

    /// @dev Returns the current minter of the contract
    function minter() external view returns (address);

    ////////////////////////////////////// WRITE METHODS //////////////////////////////////////////

    /// @dev Mints the specified amount of tokens to the specified address
    function mint(address _addr, uint256 _amount) external returns (bool);

    /// @dev Burns the specified amount of tokens from the specified address
    function burn(address _addr, uint256 _amount) external returns (bool);

    /// @dev Sets a new minter for the contract
    function setMinter(address _newMinter) external returns (bool);

    /// @dev Transfers the ownership of the contract to a new owner
    function transferOwnership(address _newOwner) external returns (bool);

    /// @dev Renounces ownership of the contract
    function renounceOwnership() external returns (bool);
}
