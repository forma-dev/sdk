// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IPaymentSplitter {
    event PayeeAdded(address _account, uint256 _shares);
    event PaymentReleased(address _to, uint256 _amount);
    event PaymentReceived(address _from, uint256 _amount);

    function totalShares() external view returns (uint256);
    function totalReleased() external view returns (uint256);
    function shares(address _account) external view returns (uint256);
    function released(address _account) external view returns (uint256);
    function releasable(address _account) external view returns (uint256);
    function release(address payable _account) external;
}
