// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// ABI Decode
// abi.encode encodes data into bytes.
// abi.decode decodes bytes back into data.

contract AbiDecode {
    struct MyStruct {
        string name;
        uint256[2] nums;
    }

    // The mapping and arrays (with the exception of byte arrays) in the struct are omitted because
    // there is no good way to select individual struct members or provide a key for the mapping:
    MyStruct public s; 

    string public theName;


    function getname() public view returns (string memory) {
        return s.name;
    }

    function getnums() public view returns (uint256[2] memory) {
        return s.nums;
    }

    function encode(
        uint256 x,
        address addr,
        uint256[] calldata arr,
        MyStruct calldata myStruct
    ) external pure returns (bytes memory) {
        return abi.encode(x, addr, arr, myStruct);
    }

    function decode(bytes calldata data)
        public
        //view
        returns (
            uint256 x,
            address addr,
            uint256[] memory arr,
            MyStruct memory myStruct
        )
    {
        // (uint x, address addr, uint[] memory arr, MyStruct myStruct) = ...
        (x, addr, arr, myStruct) = abi.decode(
            data,
            (uint256, address, uint256[], MyStruct)
        );
        s.name = myStruct.name;
        theName = myStruct.name;
        s.nums = myStruct.nums;
    }
}
