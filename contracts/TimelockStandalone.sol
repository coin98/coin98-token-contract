// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, with an overflow flag.
   *
   * _Available since v3.4._
   */
  function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    uint256 c = a + b;
    if (c < a) return (false, 0);
    return (true, c);
  }

  /**
   * @dev Returns the substraction of two unsigned integers, with an overflow flag.
   *
   * _Available since v3.4._
   */
  function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    if (b > a) return (false, 0);
    return (true, a - b);
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
   *
   * _Available since v3.4._
   */
  function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) return (true, 0);
    uint256 c = a * b;
    if (c / a != b) return (false, 0);
    return (true, c);
  }

  /**
   * @dev Returns the division of two unsigned integers, with a division by zero flag.
   *
   * _Available since v3.4._
   */
  function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    if (b == 0) return (false, 0);
    return (true, a / b);
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
   *
   * _Available since v3.4._
   */
  function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    if (b == 0) return (false, 0);
    return (true, a % b);
  }

  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   *
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");
    return c;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   *
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a, "SafeMath: subtraction overflow");
    return a - b;
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `*` operator.
   *
   * Requirements:
   *
   * - Multiplication cannot overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) return 0;
    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");
    return c;
  }

  /**
   * @dev Returns the integer division of two unsigned integers, reverting on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   *
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0, "SafeMath: division by zero");
    return a / b;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * reverting when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   *
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0, "SafeMath: modulo by zero");
    return a % b;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * CAUTION: This function is deprecated because it requires allocating memory for the error
   * message unnecessarily. For custom revert reasons use {trySub}.
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   *
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    return a - b;
  }

  /**
   * @dev Returns the integer division of two unsigned integers, reverting with custom message on
   * division by zero. The result is rounded towards zero.
   *
   * CAUTION: This function is deprecated because it requires allocating memory for the error
   * message unnecessarily. For custom revert reasons use {tryDiv}.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   *
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    return a / b;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * reverting with custom message when dividing by zero.
   *
   * CAUTION: This function is deprecated because it requires allocating memory for the error
   * message unnecessarily. For custom revert reasons use {tryMod}.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   *
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    return a % b;
  }
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
  function _msgSender() internal view returns (address payable) {
    return msg.sender;
  }

  function _msgData() internal view returns (bytes memory) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
  address private _owner;
  address private _newOwner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor () {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  /**
   * @dev Returns the address of the current owner.
   */
  function owner() public view returns (address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(owner() == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  /**
   * @dev Accept the ownership transfer. This is to make sure that the contract is
   * transferred to a working address
   *
   * Can only be called by the newly transfered owner.
   */
  function acceptOwnership() public {
    require(_msgSender() == _newOwner, "Ownable: only new owner can accept ownership");
    address oldOwner = _owner;
    _owner = _newOwner;
    _newOwner = address(0);
    emit OwnershipTransferred(oldOwner, _owner);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   *
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    _newOwner = newOwner;
  }
}

/// @title Timelock
/// @notice Provide mechanism for Time Locking, Owner of contract can unlock this contract.
contract TimelockStandalone is Ownable {
  using SafeMath for uint256;

  uint256 private _lockTime;
  uint256 private _gracePeriod;

  mapping(bytes32 => bool) _isUnlock;
  mapping(bytes32 => uint256) _unlockAts;

  /**
   * @notice Create a new instance of TimeLock
   * @param lockTime Minimum time in seconds before a proposal can be executed
   * @param gracePeriod Execution windows in seconds that a proposal can be executed
   */
  constructor(uint256 lockTime, uint256 gracePeriod) public {
    _lockTime = lockTime;
    _gracePeriod = gracePeriod;
  }

  event Executed(bytes32 indexed dataHash, address indexed target, uint256 value, string funcSig, bytes funcData, uint256 unlockTimestamp);
  event Locked(bytes32 indexed dataHash, address indexed target, uint256 value, string funcSig, bytes funcData, uint256 unlockTimestamp);
  event LockTimeUpdated(uint256 lockTime, uint256 gracePeriod);
  event Unlocked(bytes32 indexed dataHash, address indexed target, uint256 value, string funcSig, bytes funcData, uint256 unlockTimestamp);

  /**
   * @notice Returns current configuration of TimeLock
   * @return lockTime Minimum time in seconds before a proposal can be executed
   * @return gracePeriod Execution windows in seconds that a proposal can be executed
   */
  function lockTime() external view returns (uint256, uint256) {
    return (_lockTime, _gracePeriod);
  }

  /**
   * @notice Returns a specified proposal is ready for execution
   */
  function isUnlock(bytes32 dataHash) public view returns(bool) {
    return _isUnlock[dataHash] && _unlockAts[dataHash] >= block.timestamp && _unlockAts[dataHash].add(_gracePeriod) <= block.timestamp;
  }

  /**
   * @notice Calculate hash for a proposal
   */
  function calcDataHash(address target, uint256 value, string memory funcSig, bytes memory funcData, uint256 unlockTimestamp) public pure returns (bytes32) {
    return keccak256(abi.encode(target, value, funcSig, funcData, unlockTimestamp));
  }

  /**
   * @notice Create a new proposal
   * @param target Contract that will be executed
   * @param value Amount of native token to send to calling method
   * @param funcSig Solidity function signature
   * @param funcData Data encoded from abi.encode without signature
   * @param unlockTimestamp Timestamp that proposal can be executed
   *
   * Only TimeLock owner can call this function
   */
  function propose(address target, uint256 value, string memory funcSig, bytes memory funcData, uint256 unlockTimestamp) external onlyOwner returns (bytes32) {
    require(unlockTimestamp >= block.timestamp.add(_lockTime), "TimeLock: Unlock too soon");

    bytes32 dataHash = calcDataHash(target, value, funcSig, funcData, unlockTimestamp);
    _isUnlock[dataHash] = true;
    _unlockAts[dataHash] = unlockTimestamp;

    emit Unlocked(dataHash, target, value, funcSig, funcData, unlockTimestamp);
    return dataHash;
  }

  /**
   * @notice Execute a proposal
   * @param target Contract that will be executed
   * @param value Amount of native token to send to calling method
   * @param funcSig Solidity function signature
   * @param funcData Data encoded from abi.encode without signature
   * @param unlockTimestamp Timestamp that proposal can be executed
   *
   * Only TimeLock owner can call this function
   */
  function execute(address target, uint256 value, string memory funcSig, bytes memory funcData, uint256 unlockTimestamp) external payable onlyOwner returns (bytes memory) {
    bytes32 dataHash = calcDataHash(target, value, funcSig, funcData, unlockTimestamp);
    require(_isUnlock[dataHash], "Timelock: Invalid proposal");
    require(_unlockAts[dataHash] >= block.timestamp, "Timelock: Proposal locked");
    require(_unlockAts[dataHash].add(_gracePeriod) <= block.timestamp, "Timelock: Proposal expired");

    _isUnlock[dataHash] = false;

    bytes memory callData;
    if (bytes(funcSig).length == 0) {
      callData = funcData;
    } else {
      callData = abi.encodePacked(bytes4(keccak256(bytes(funcSig))), funcSig);
    }
    (bool success, bytes memory returnData) = target.call{value: value}(callData);
    require(success, "Timelock: Transaction failed");

    emit Executed(dataHash, target, value, funcSig, funcData, unlockTimestamp);
    return returnData;
  }

  /**
   * @notice Cancal a proposal
   * @param target Contract that will be executed
   * @param value Amount of native token to send to calling method
   * @param funcSig Solidity function signature
   * @param funcData Data encoded from abi.encode without signature
   * @param unlockTimestamp Timestamp that proposal can be executed
   *
   * Only TimeLock owner can call this function
   */
  function cancel(address target, uint256 value, string memory funcSig, bytes memory funcData, uint256 unlockTimestamp) external onlyOwner {
    bytes32 dataHash = calcDataHash(target, value, funcSig, funcData, unlockTimestamp);
    _isUnlock[dataHash] = false;

    emit Locked(dataHash, target, value, funcSig, funcData, unlockTimestamp);
  }

  /**
   * Update configuration for TimeLock
   * @param lockTime Minimum time in seconds before a proposal can be executed
   * @param gracePeriod Execution windows in seconds that a proposal can be executed
   */
  function setLockTime(uint256 lockTime, uint256 gracePeriod) external {
    require(msg.sender == address(this), "Timelock: Unauthorized");
    _lockTime = lockTime;
    _gracePeriod = gracePeriod;

    emit LockTimeUpdated(lockTime, gracePeriod);
  }
}
