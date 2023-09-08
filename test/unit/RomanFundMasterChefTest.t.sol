//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {RomanFundMasterChef} from "../../src/RomanFundMasterChef.sol";
import {RomanCoin} from "../../src/RomanCoin.sol";
import {DeployRomanCoin} from "../../script/DeployRomanCoin.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract RomanFundMasterChefTest is StdCheats, Test {
    HelperConfig helperConfig;
    RomanFundMasterChef romanFundMasterChef;
    RomanCoin romanCoin;
    uint256 public deployerKey;
    address public DEV;
    address public USER;

    uint256 public constant STARTING_USER_BALANCE = 1000e18;
    uint256 public constant ROMANCOIN_PER_BLOCK = 100e18;
    uint256 public constant BONUS_MULTIPLIER = 1;

    function setUp() external {
        DeployRomanCoin deployer = new DeployRomanCoin();
        (romanFundMasterChef, romanCoin, helperConfig) = deployer.run();
        (deployerKey) = helperConfig.activeNetworkConfig();

        DEV = makeAddr("dev");
        vm.deal(DEV, STARTING_USER_BALANCE);
        USER = makeAddr("user");
        vm.deal(USER, STARTING_USER_BALANCE);
    }

    ///////////////////////////////
    // ConstructorTest          //
    /////////////////////////////

    function testPoolLength() public {
        assertEq(romanFundMasterChef.poolLength(), 1);
    }

    function testReturnsPoolInformation() public {
        (address lpToken, uint256 allocPoint, uint256 lastRewardBlock, uint256 accRomanCoinPerShare) =
            romanFundMasterChef.getPoolInformation(0);
        console.log("allocPoint: %s", allocPoint);
        console.log("lastRewardBlock: %s", lastRewardBlock);
        console.log("accRomanCoinPerShare: %s", accRomanCoinPerShare);
        assertEq(lpToken, address(romanCoin));
        assertEq(allocPoint, 10000);
        assertEq(lastRewardBlock, 1);
        assertEq(accRomanCoinPerShare, 0);
    }
}
