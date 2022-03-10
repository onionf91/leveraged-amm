// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AMM {
    uint public reserveTwd;
    uint public reserveUsd;

    constructor(uint Rt, uint Ru) {
        reserveTwd = Rt;
        reserveUsd = Ru;
    }
}
