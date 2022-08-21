// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library AddLib {
    function add(uint256 value1, uint value2)
        external
        pure
        returns (uint)
    {
        return value1 + value2;
    }
}
