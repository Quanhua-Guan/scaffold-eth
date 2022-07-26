// Call
// call is a low level function to interact with other contracts.
// This is the recommended method to use when you're just sending Ether via calling the fallback functions.
// However it is not recommend way to call existing functions.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Receiver {
    event Received(address caller, uint256 amount, string message);

    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }

    function foo(string memory _message, uint256 _x)
        public
        payable
        returns (uint256)
    {
        emit Received(msg.sender, msg.value, _message);

        return _x + 1;
    }
}

contract Caller {
    event Response(bool success, bytes data);

    // Let's imagine that contact B does not have the source code for contract A, but we do know the address of A
    // and the function to call.
    function testCallFoo(address payable _addr) public payable {
        // Your can send ether and specify a custom gas amount
        (bool success, bytes memory data) = _addr.call{
            value: msg.value,
            gas: 5000
        }(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));

        emit Response(success, data);
    }

    // Calling a function that does not exist triggers the fallback function.
    function testCallDoesNotExist(address _addr) public {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("doesNotExist()")
        );

        emit Response(success, data);
    }
}

// Delegatecall
// delegatecall is a low level function similar to call.
// When contract A executes delegatecall to contract B, B's code is executed with
// contract A's storage, msg.sender and msg.value.

// NOTE: Deploy this contract first
contract B_dc {
    // NOTE: storage layout must be the same as contract A
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A_dc {
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(address _contract, uint256 _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}

// Function Selector
// When a function is called, the first 4 bytes of calldata specifies which function to call.
// This 4 bytes is called a function selector.
// Take for example, this code below. It uses call to execute transfer on a contract at the address addr.
//
// addr.call(abi.encodeWithSignature("transfer(address, uint256)", 0xSomeAddress, 123))
//
// The first 4 bytes return from abi.encodeWithSignature(..., ...) is the function selector.
// Perhaps you can save a tiny amount of gas if you precompute and inline the function selector in your code?
// Here is how the function selector is computed.
contract FunctionSelector {
    /**
    "transfer(address,uint256)"
    0xa9059cbb
    "transferFrom(address,address,uint256)"
    0x23b872dd
     */
    function getSelector(string calldata _func) external pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}

// Calling Other Contract
// Contract can call other contracts in 2 ways.
// The easiest way to is to just call it, like A.foo(x, y, x).
// Another way to call other contracts is to use the low-level call.
// This method is not recommended.

contract Callee {
    uint256 public x;
    uint256 public value;

    function setX(uint256 _x) public returns (uint256) {
        x = _x;
        return x;
    }

    function setXandSendEther(uint256 _x)
        public
        payable
        returns (uint256, uint256)
    {
        x = _x;
        value = msg.value;

        return (x, value);
    }
}

contract Caller_ {
    function setX(Callee _callee, uint256 _x) public {
        uint256 x = _callee.setX(_x);
    }

    function setXFromAddress(address _addr, uint256 _x) public {
        Callee callee = Callee(_addr);
        callee.setX(_x);
    }

    function setXandSendEther(Callee _callee, uint256 _x) public payable {
        (uint256 x, uint256 value) = _callee.setXandSendEther{value: msg.value}(
            _x
        );
    }
}
