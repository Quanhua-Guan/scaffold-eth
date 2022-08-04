// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {MathLib} from "./Library.sol";

contract YourContract_1 {
    using MathLib for uint256;

    address public owner = address(this);

    function doSome() public {
        assert(1 wei == 1);
        assert(1 gwei == 1e9);
        assert(1 ether == 1e18);
        assert(1 == 1 seconds);
        assert(1 minutes == 60 seconds);
        assert(1 hours == 60 minutes);
        assert(1 days == 24 hours);
        assert(1 weeks == 7 days);
    }

    function f(uint256 start, uint256 daysAfter) public payable {
        if (block.timestamp >= start + daysAfter * 1 days) {
            //
        }

        // Block and Trancsaction Properties

        // current block's base fee(EIP-3198 and EIP-1559)
        //uint basefee = block.basefee(block.number);

        // blockhash(uint blockNumber) returns (bytes32): hash of the given block when blocknumber is one
        // of the 256 most recent blocks; otherwise returns zero.
        bytes32 hash = blockhash(block.number);

        //uint chainid = block.chainid(block.number);
    }

    function multiplyExample(uint256 _a, uint256 _b)
        public
        view
        returns (uint256, address)
    {
        return (_a * _b, address(this));
    }

    // Function Selector
    /*
    "transfer(address,uint256)"
    0xa9059cbb
    "transferFrom(address,address,uint256)"
    0x23b872dd
    */
    function getSelector(string calldata _func) external pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}

struct Todo_ {
    string title;
    bool completed;
    uint256 value;
}

contract TheReceiver {
    uint public fallbackCount;

    event Log(uint gas);

    receive() external payable {}

    fallback() external payable {
        emit Log(gasleft());
        fallbackCount++;
    }

    uint public x;
    function setX(uint _x) public returns (uint) {
        x = _x;
        return this.x();
    }

    function setXandSendEther(uint _x) public payable returns (uint, uint) {
        x = _x;
        return (x, msg.value);
    }
}

contract YourContract_202207261514 {
    mapping(address => bool) public isPaying;
    mapping(address => Todo_) public payBalance;

    TheReceiver receiver;
    constructor() {
        receiver = new TheReceiver();
    }

    event PayLog(address sender, uint256 value);

    modifier onlyPayOneTime() {
        require(!isPaying[msg.sender], "No reentrancy");
        isPaying[msg.sender] = true;
        _;
        isPaying[msg.sender] = false;
    }

    modifier validAddress(address _addr) {
        require(
            _addr != 0x2d037eE181181576f8dE2464ED42448eAD84e34a,
            "Address in blacklist"
        );
        require(_addr != address(0), "Not valid address");
        _;
    }

    function paySome(string memory _title)
        public
        payable
        onlyPayOneTime
        validAddress(msg.sender)
    {
        Todo_ storage todo = payBalance[msg.sender];
        todo.title = _title;
        todo.value = msg.value;

        if (todo.value > 0) {
            //paySome(_title);
        }

        emit PayLog(msg.sender, msg.value);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getAll(address payable addr) public validAddress(addr) {
        uint256 amount = address(this).balance;
        (bool success, ) = addr.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    function abc() public payable {}

    function sendToTheReceiver() public payable {
        (bool success, bytes memory data) = payable(address(receiver)).call{value: msg.value}("");
        require(success, "Send to the receiver failed");
    }

    function getTheReceiverBalance() public view returns (uint) {
        return address(receiver).balance;
    }

    function getTheReceiverFallbackCount() public view returns (uint) {
        return receiver.fallbackCount();
    }

    function setTheReceiverX(uint _x) public returns (uint) {
        return receiver.setX(_x);
    }

    function getTheReceiverAddr() public returns (address) {
        return address(receiver);
    }

    function setTheReceiverXandSendEther(uint _x) public payable returns (uint, uint) {
        (bool success, bytes memory datas) = payable(getTheReceiverAddr()).call{value: msg.value}(abi.encodeWithSelector(
            TheReceiver.setXandSendEther.selector, _x)
        );
        require(success, "Send failed");
    }

    function getTheReceiverX() public view returns (uint) {
        return receiver.x();
    }
}
