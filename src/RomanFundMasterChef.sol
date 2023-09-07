//SPDX-License-Identifier: MIT

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

pragma solidity ^0.8.19;

//////////////////////////////
// Imports                  //
/////////////////////////////

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import {RomanCoin} from "./RomanCoin.sol";

contract RomanFundMasterChef is Ownable, ReentrancyGuard {
    //////////////////////////////
    // Type Declarations       //
    ////////////////////////////

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    //////////////////////////////
    // State Variables         //
    ////////////////////////////

    /**
     * @dev Info of each user.
     * rewardDebt: The amount of RomanCoin entitled to the user.
     *            It is used to handle compound reward.
     */
    struct UserInformation {
        uint256 amount; // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation above.
    }

    /**
     * @dev Info of each pool.
     *
     */
    struct PoolInformation {
        IERC20 lpToken; // Address of LP token contract.
        uint256 allocPoint; // How many allocation points assigned to this pool. RomanCoins to distribute per block.
        uint256 lastRewardBlock; // Last block number that RomanCoins distribution occurs.
        uint256 accRomanCoinPerShare; // Accumulated RomanCoins per share, times 1e12. See below.
    }

    mapping(uint256 poolNumber => mapping(address user => UserInformation)) private s_poolNumberToUserInformation;

    PoolInformation[] private s_poolInformation;

    RomanCoin private romanCoin;
    address private s_devAddress;
    uint256 private s_romanCoinPerBlock;
    uint256 private s_startBlock;
    uint256 private s_totalAllocation = 0;
    uint256 private BONUS_MULTIPLIER;

    // Layout of Functions:

    //////////////////////////////
    // Constructor             //
    ////////////////////////////

    constructor(
        RomanCoin _romanCoin,
        address _devAddress,
        uint256 _romanCoinPerBlock,
        uint256 _startBlock,
        uint256 _bonusMultiplier
    ) {
        romanCoin = _romanCoin;
        s_devAddress = _devAddress;
        s_romanCoinPerBlock = _romanCoinPerBlock;
        s_startBlock = _startBlock;
        BONUS_MULTIPLIER = _bonusMultiplier;

        // staking pool
        s_poolInformation.push(
            PoolInformation({
                lpToken: _romanCoin,
                allocPoint: 10000,
                lastRewardBlock: s_startBlock,
                accRomanCoinPerShare: 0
            })
        );
        s_totalAllocation = 10000;
    }
}
