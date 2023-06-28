// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StormragerToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Stormrager Token", "STRG") {
        _mint(msg.sender, initialSupply);
    }
}
