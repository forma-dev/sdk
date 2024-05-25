// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { IPaymentSplitter } from "../../interfaces/finance/IPaymentSplitter.sol";
import { ContractMetadataUpgradeable } from "../metadata/ContractMetadataUpgradeable.sol";
import { Ownable2StepUpgradeable } from "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { ReentrancyGuardUpgradeable } from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

contract PaymentSplitterUpgradeable is
    Initializable,
    Ownable2StepUpgradeable,
    ContractMetadataUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable,
    IPaymentSplitter
{
    /// @custom:storage-location erc7201:forma.storage.PaymentSplitterUpgradeableStorage
    struct PaymentSplitterUpgradeableStorage {
        uint256 _totalShares;
        uint256 _totalReleased;
        mapping(address => uint256) _shares;
        mapping(address => uint256) _released;
        address[] _payees;
    }

    // keccak256(abi.encode(uint256(keccak256("forma.storage.PaymentSplitterUpgradeableStorage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant PaymentSplitterUpgradeableStorageLocation =
        0x3b63412555d5df0d6aaaa82075c6c9767633b1dc5c0c985e1854ea6d3a942100;

    function _getPaymentSplitterUpgradeableStorage()
        private
        pure
        returns (PaymentSplitterUpgradeableStorage storage s)
    {
        assembly {
            s.slot := PaymentSplitterUpgradeableStorageLocation
        }
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    // solhint-disable func-name-mixedcase
    function __PaymentSplitter_init(address[] memory _payees, uint256[] memory _shares) internal onlyInitializing {
        __PaymentSplitter_init_unchained(_payees, _shares);
    }

    function __PaymentSplitter_init_unchained(
        address[] memory _payees,
        uint256[] memory _shares
    ) internal onlyInitializing {
        require(_payees.length == _shares.length, "PaymentSplitter: payees and shares length mismatch");
        require(_payees.length > 0, "PaymentSplitter: no payees");

        for (uint256 i = 0; i < _payees.length; i++) {
            _addPayee(_payees[i], _shares[i]);
        }
    }
    // solhint-enable func-name-mixedcase

    function initialize(
        string calldata _name,
        address _initialOwner,
        address[] memory _payees,
        uint256[] memory _shares
    ) public initializer {
        __Ownable_init(_initialOwner);
        __Ownable2Step_init();
        __ContractMetadata_init(_name);
        __UUPSUpgradeable_init();
        __PaymentSplitter_init(_payees, _shares);
    }

    receive() external payable virtual {
        emit IPaymentSplitter.PaymentReceived(_msgSender(), msg.value);
    }

    /**
     * @dev Getter for the total shares held by payees.
     */
    function totalShares() public view returns (uint256) {
        PaymentSplitterUpgradeableStorage storage s = _getPaymentSplitterUpgradeableStorage();
        return s._totalShares;
    }

    /**
     * @dev Getter for the total amount of Ether already released.
     */
    function totalReleased() public view returns (uint256) {
        PaymentSplitterUpgradeableStorage storage s = _getPaymentSplitterUpgradeableStorage();
        return s._totalReleased;
    }

    /**
     * @dev Getter for the amount of shares held by an account.
     */
    function shares(address _account) public view returns (uint256) {
        PaymentSplitterUpgradeableStorage storage s = _getPaymentSplitterUpgradeableStorage();
        return s._shares[_account];
    }

    /**
     * @dev Getter for the amount of Ether already released to a payee.
     */
    function released(address _account) public view returns (uint256) {
        PaymentSplitterUpgradeableStorage storage s = _getPaymentSplitterUpgradeableStorage();
        return s._released[_account];
    }

    /**
     * @dev Getter for the amount of payee's releasable Ether.
     */
    function releasable(address _account) public view returns (uint256) {
        uint256 totalReceived = address(this).balance + totalReleased();
        return _pendingPayment(_account, totalReceived, released(_account));
    }

    /**
     * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
     * total shares and their previous withdrawals.
     */
    function release(address payable _account) public virtual {
        PaymentSplitterUpgradeableStorage storage s = _getPaymentSplitterUpgradeableStorage();
        require(s._shares[_account] > 0, "PaymentSplitter: account has no shares");

        uint256 payment = releasable(_account);
        require(payment != 0, "PaymentSplitter: account is not due payment");

        // _totalReleased is the sum of all values in _released.
        // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
        s._totalReleased += payment;
        unchecked {
            s._released[_account] += payment;
        }

        Address.sendValue(_account, payment);
        emit IPaymentSplitter.PaymentReleased(_account, payment);
    }

    /**
     * @dev Release the owed amount of token to all of the payees.
     */
    function distribute() public virtual nonReentrant {
        PaymentSplitterUpgradeableStorage storage s = _getPaymentSplitterUpgradeableStorage();
        for (uint256 i = 0; i < s._payees.length; i++) {
            release(payable(s._payees[i]));
        }
    }

    /**
     * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
     * already released amounts.
     */
    function _pendingPayment(
        address _account,
        uint256 _totalReceived,
        uint256 _alreadyReleased
    ) private view returns (uint256) {
        PaymentSplitterUpgradeableStorage storage s = _getPaymentSplitterUpgradeableStorage();
        return (_totalReceived * s._shares[_account]) / s._totalShares - _alreadyReleased;
    }

    /**
     * @dev Add a new payee to the contract.
     * @param _account The address of the payee to add.
     * @param _shares The number of shares owned by the payee.
     */
    function _addPayee(address _account, uint256 _shares) private {
        require(_account != address(0), "PaymentSplitter: account is the zero address");
        require(_shares > 0, "PaymentSplitter: shares are 0");

        PaymentSplitterUpgradeableStorage storage s = _getPaymentSplitterUpgradeableStorage();

        require(s._shares[_account] == 0, "PaymentSplitter: account already has shares");

        s._payees.push(_account);
        s._shares[_account] = _shares;
        s._totalShares = s._totalShares + _shares;
        emit IPaymentSplitter.PayeeAdded(_account, _shares);
    }

    function _canSetContractMetadata() internal view override returns (bool) {
        return owner() == _msgSender();
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
