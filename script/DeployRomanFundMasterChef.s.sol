//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {RomanFundMasterChef} from "../src/RomanFundMasterChef.sol";
import {RomanCoin} from "../src/RomanCoin.sol";

contract DeployRomanFundMasterchef is Script {
    function run() external returns (RomanFundMasterChef, RomanCoin, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig(); //Should come with any mocks if any
        (uint256 deployerKey) = helperConfig.activeNetworkConfig();



        vm.startBroadcast(deployerKey);
        RomanCoin romanCoin = new RomanCoin();
        RomanFundMasterChef romanFundMasterChef = new RomanFundMasterChef(romanCoin

    }
}
