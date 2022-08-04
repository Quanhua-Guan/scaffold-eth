// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract YourContract_Enum_Uint {
    enum Operation { Sell, Buy, Hold }

    /// enum 和 uint 互转时需要注意 取值范围必须一一对应, 超出范围运行时会报错revert.
    // Operation.Sell -> 0
    // Operation.Buy -> 1
    // Operation.Hold -> 2
    // Operation(3) -> Runtime Error
    // Operation(-1) -> Runtime Error
    function testEnumToUint(Operation operation) public pure returns (uint) {
        return uint(operation);
    }

    // -1 -> Runtime Error
    // 0 -> Operation.Sell
    // 1 -> Operation.Buy
    // 2 -> Operation.Hold
    // 3 -> Runtime Error
    function testUintToEnum(uint operationUint) public pure returns (Operation) {
        return Operation(operationUint);
    }
}