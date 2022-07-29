// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC721
// EIP-721: Non-fungible Token Standard

interface ITest {

}

// interface ITest1 {
//     function change(uint i) external returns (uint); // function in interface must be declared a external
// }

interface ITest2 {
    function change(uint ii) external returns (int);
}

contract YourContract_TestInterface is ITest, ITest2 {
    bytes4 public constant IID_ITEST = type(ITest).interfaceId; // "0x00000000", Return zero with empty interface 
    bytes4 public constant IID_ITest2 = type(ITest2).interfaceId; // Remember interfaceId = xor of all selectors (methods) name and param type, don't care to return type

    // function change(uint i) public override returns (uint) {
    //     return i + 1;
    // }

    function change(uint i) public pure override returns (int) {
        return int(1);
    }

}


