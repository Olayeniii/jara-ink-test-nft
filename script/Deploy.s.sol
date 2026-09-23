// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {JaraInkTestNFT} from "../src/JaraInkTestNFT.sol";

contract DeployJaraInkTestNFT is Script {
    function run() external returns (JaraInkTestNFT deployed) {
        uint256 deployerKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerKey);
        deployed = new JaraInkTestNFT();
        vm.stopBroadcast();
    }
}
