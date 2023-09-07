//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {RomanFundMasterChef} from "../src/RomanFundMasterChef.sol";
import {RomanCoin} from "../src/RomanCoin.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    struct NetworkConfig {
        uint256 deployerKey;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        }
        if (block.chainid == 80001) {
            activeNetworkConfig = getPolygonMumbaiConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public view returns (NetworkConfig memory sepoliaNetworkConfig) {}

    function getPolygonMumbaiConfig() public view returns (NetworkConfig memory polygonMumbaiNetworkConfig) {}

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory anvilNetworkConfig) {
        //Check to see if theres an active network config
    }
}
