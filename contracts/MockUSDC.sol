// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract MockUSDC is ERC20PresetFixedSupply {
    constructor() ERC20PresetFixedSupply(
        "MockUSDC", "$", 10000, msg.sender
    ) {}
}
