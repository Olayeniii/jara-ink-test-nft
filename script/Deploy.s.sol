// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {JaraInkTestNFT} from "../src/JaraInkTestNFT.sol";

contract DeployJaraInkTestNFT is Script {
    function run() external returns (JaraInkTestNFT deployed) {
        address[3] memory approvedWallets = [
            vm.envAddress("JARA_EXECUTION_WALLET_1"),
            vm.envAddress("JARA_EXECUTION_WALLET_2"),
            vm.envAddress("JARA_EXECUTION_WALLET_3")
        ];

        vm.startBroadcast();
        deployed = new JaraInkTestNFT(approvedWallets);
        vm.stopBroadcast();
    }
}
