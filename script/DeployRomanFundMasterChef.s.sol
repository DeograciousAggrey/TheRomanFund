//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {RomanFundMasterChef} from "../src/RomanFundMasterChef.sol";
import {RomanCoin} from "../src/RomanCoin.sol";

contract DeployRomanFundMasterchef is Script {
    uint256 public ROMANCOIN_PER_BLOCK = 100e18;
    uint256 public BONUS_MULTIPLIER = 1;

    function run() external returns (RomanFundMasterChef, RomanCoin, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig(); //Should come with any mocks if any
        (uint256 deployerKey) = helperConfig.activeNetworkConfig();

        vm.startBroadcast(deployerKey);
        RomanCoin romanCoin = new RomanCoin();
        RomanFundMasterChef romanFundMasterChef =
            new RomanFundMasterChef(romanCoin, msg.sender, ROMANCOIN_PER_BLOCK,block.number, BONUS_MULTIPLIER);
        romanCoin.transferOwnership(address(romanFundMasterChef));
        vm.stopBroadcast();
        return (romanFundMasterChef, romanCoin, helperConfig);
    }
}
