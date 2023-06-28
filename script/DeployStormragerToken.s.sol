// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {StormragerToken} from "../src/StormragerToken.sol";

contract DeployStormragerToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (StormragerToken) {
        vm.startBroadcast();
        StormragerToken strg = new StormragerToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return strg;
    }
}
