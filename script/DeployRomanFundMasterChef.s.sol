//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {RomanFundMasterChef} from "../src/RomanFundMasterChef.sol";
import {RomanCoin} from "../src/RomanCoin.sol";

contract DeployRomanFundMasterchef is Script {}
