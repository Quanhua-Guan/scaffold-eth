pragma solidity ^0.8.0; //pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./CallingParentContracts.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract Counter_Old {
    // The Counter
    uint256 public count;

    bool public boo = true;

    uint256 public u8 = 1;
    uint256 public u256 = 456;
    uint256 public u = 123;

    int8 public i8 = -1;
    int256 public i256 = 456;
    int256 public i = -123;

    int256 public minInt = type(int256).min;
    int256 public maxInt = type(int256).max;

    address public addr = 0xd865687Fe141FC25ff7808E18A2D2368092d7DdD;

    bytes1 a = 0xb5; // [10110101]
    bytes1 b = 0x56; // [01010110]

    // Unassigned variables have a default value.
    bool public defaultBoo; // false
    uint256 public defaultUint; // 0
    int256 public defaultInt; // 0
    address public defaultAddr; // 0x0000000000000000000000000000000000000000

    // Function to get the current count
    function get() public view returns (uint256) {
        return count;
    }

    // Function to increment count by 1
    function inc() public {
        count += 1;
    }

    // Function to decrement count by 1
    function dec() public {
        // This function will fail if count = 0
        count -= 1;
    }
}

struct TheCount {
    string name;
    uint256 count;
}

contract YourContract_ is D_ {
    event SetPurpose(address sender, string purpose);
    event SetGreet(address sender, string greet);

    string public purpose = "Building Unstoppable Apps!!! ILoveU.cm";
    string public greet = "Hello QG";

    TheCount[] public myData;

    uint256 public count;

    constructor() payable {
        // what should we do on deploy?
    }

    function addMyData(string calldata _name, uint256 _count) public {
        myData.push(TheCount(_name, _count));
    }

    function decMyDataCount(uint256 _index) public {
        TheCount storage tc = myData[_index];
        assert(tc.count > 1);
        tc.count--;
    }

    function incMyDataCount(uint256 _index) public {
        TheCount storage tc = myData[_index];
        tc.count++;
    }

    error BadPurpose(string purpose);

    function setPurpose(string memory newPurpose) public {
        if (
            keccak256(abi.encodePacked((newPurpose))) ==
            keccak256(abi.encodePacked(("bad")))
        ) {
            revert BadPurpose({purpose: newPurpose});
        }

        purpose = newPurpose;
        console.log(msg.sender, "set purpose to ", purpose);
        emit SetPurpose(msg.sender, purpose);
    }

    function setGreet(string memory newGreet) public {
        greet = newGreet;
        console.log(msg.sender, "set greet to ", greet);
        emit SetGreet(msg.sender, greet);
    }

    // Run a loop until all of the gas are spent
    // and the transaction fails
    function forever() public {
        while (true) {
            count += 1;
        }
        console.log(block.gaslimit);
    }

    function inc() public {
        count += 1;
    }

    function getLastDigit(uint256 _x) public pure returns (uint256) {
        return _x % 10;
    }

    function callOtherContract_foo() public {
        D_.foo();
    }

    function callOtherContract_bar() public {
        D_.bar();
    }

    // to support receiving ETH by default
    receive() external payable {}

    fallback() external payable {}
}

/**
There are 3 types of variables in Solidity

- local
  declared inside a function
  not stored on the blockchain
- state
  declared outside a function
  stored on the blockchain
- global (provides information about the blockchain)
 */
contract Variables {
    // State variables are stored on the blockchain
    string public text = "Hello";
    uint256 public num = 123;

    function doSomething() public {
        // Local variables are not saved to the blockchain
        uint256 i = 456;
        i = 0;

        // Here some global variables
        uint256 timestamp = block.timestamp; // current blockchain timestamp
        timestamp = 0;
        address sender = msg.sender; // address of the caller
        sender = 0x0000000000000000000000000000000000000000;

        num += 1;
    }
}

// Constants are variables that cannot be modified.
// Their value is hard coded and using constants can save gas cost.
contract Constants {
    // coding convention to uppercase constant variables
    address public constant MY_ADDRESS =
        0xd865687Fe141FC25ff7808E18A2D2368092d7DdD;
    uint256 public constant MY_UINT = 123;
}

// Immutable
// Immutable variables are like constants. Values of immutable variables can be set inside the constructor but cannot be modified afterwards.
contract Immutable {
    // coding convention to uppercase constant variables
    address public immutable MY_ADDRESS;
    uint256 public immutable MY_UINT;

    constructor(uint256 _myUint) {
        MY_ADDRESS = msg.sender;
        MY_UINT = _myUint;
    }
}

// Reading and Writing to a State Variable
// To write or update a state variable you need to send a transaction.
// On the other hand, you can read state variables, for free, without any transaction fee.

contract SimpleStorage {
    // State variable to store a number
    uint256 public num;

    // You need to send a transaction to write to a state variable.
    function set(uint256 _num) public {
        num = _num;
    }

    // You can read from a state variable without sending a trasaction.
    function get() public view returns (uint256) {
        return num;
    }
}

// Ether and Wei
// Transactions are paid with ether.
// Similar to how one dollar is equal to 100 cent, one ether is equal to 10^18 wei.

contract EtherUnits {
    uint256 public oneWei = 1 wei;
    // 1 wei is equal to 1 (the default unit is wei)
    bool public isOneWei = 1 wei == 1;

    uint256 public oneEther = 1 ether;
    // 1 ether is equal to 10^18 wei
    bool public isOneEther = 1 ether == 1e18;
}

// Gas
// How much ether do you need to pay for a transaction?
// You pay [gas spent] * [gas price] amount of ether, where
// - [gas] is a unit of computation
// - [gas spent] is the total amount of gas used in s transaction
// - [gas price] is how much ether you are willing to pay per gas
//
// Transactions with higher gas price have higher priority to be included in a block.
// Unspent gas will be refunded.
//
// Gas Limit
// There are 2 upper bounds to the amount of gas you can spend
// - [gas limit] (max amount of gas you're willing to use for your transaction, set by you)
// - [block gas limit] (max amount of gas allowed in a block, set by the network)

contract Gas {
    uint256 public i = 0;

    // Using up all of the gas that you send causes your transaction to fail.
    // State changes are undone.
    // Gas spent are not refunded.
    function forever() public {
        // Here we run a loop until all of the gas are spent
        // and the transaction fails
        while (true) {
            i += 1;
        }
    }
}

// If / Else
// Solidity supports conditional statements if, else if and else.
contract IfElse {
    function foo(uint256 x) public pure returns (uint256) {
        if (x < 10) {
            return 0;
        } else if (x < 20) {
            return 1;
        } else {
            return 2;
        }
    }

    function ternary(uint256 _x) public pure returns (uint256) {
        // if (_x < 10) return 1;
        // return 2;

        // shorthand way to write if / else statement
        // the "?" operator is called the ternary operator
        return _x < 10 ? 1 : 2;
    }
}

// For and While Loop
// Solidity supports for, while and do while loops.
// Don't write loops that are unbounded as this can hit the gas limit, causeing your transaction to fail.
// For the reson above, while and do while loops are rarely used.
contract Loop {
    function loop() public pure {
        for (uint256 i = 0; i < 10; i++) {
            if (i == 3) {
                continue; // Skip to next iteration with continue
            }
            if (i == 5) {
                break; // Exit loop with break
            }
        }

        // while loop
        uint256 j;
        while (j < 10) {
            j++;
        }
    }
}

// Mapping
// Maps are created with the syntas mapping(keyType => valueType)
// The keyType can be any built-in type, bytes, string, or any contract.
// valueType can be any type including another mapping or an array.
// Mapping are not iterable.
contract Mapping {
    // Mapping from address to uint
    mapping(address => uint256) public myMap;

    function get(address _addr) public view returns (uint256) {
        // Mapping always returns a value.
        // If the value was never set, it will return the default value.
        return myMap[_addr];
    }

    function set(address _addr, uint256 _i) public {
        // Update the value at this address
        myMap[_addr] = _i;
    }

    function remove(address _addr) public {
        delete myMap[_addr];
    }
}

contract NestedMapping {
    // Nested mapping (mapping from address to another mapping)
    mapping(address => mapping(uint256 => bool)) public nested;

    function get(address _addr, uint256 _i) public view returns (bool) {
        // You can get valus from a nested mapping
        // even when it is not initialized
        return nested[_addr][_i];
    }

    function set(
        address _addr1,
        uint256 _i,
        bool _boo
    ) public {
        nested[_addr1][_i] = _boo;
    }

    function remove(address _addr1, uint256 _i) public {
        delete nested[_addr1][_i];
    }

    /*
  function remove1(address _addr1) public {
    // DONT DO THIS
    // delete nested[_addr1]; // ERROR: Unary operator delete cannot be applied to type mapping(uint256 => bool)
  }
  */
}

// Array
// Array can have a compile-time fixed size or a dynamic size.
contract Array {
    // Several ways to initialize an array
    uint256[] public arr;
    uint256[] public arr2 = [1, 2, 3];
    // Fixed size array, all elements initialize to 0
    uint256[10] public myFixedSizeArr;

    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }

    // Solidity can return the entire array
    // But this function should be avoid for
    // arrays that can grow indefinitely in length
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    function push(uint256 i) public {
        // Append to array
        // This will increase the array length by 1
        arr.push(i);
    }

    function pop() public {
        // Remove last element from array
        // This will decrease the array length by 1
        arr.pop();
    }

    function getLength() public view returns (uint256) {
        return arr.length;
    }

    function remove(uint256 index) public {
        // Delete does not change the array length
        // It reset the value at index to it's default value,
        // in this case 0
        delete arr[index];
    }

    function examples() external view {
        // create array in memory, only fixed size can be created
        uint256[] memory a = new uint256[](5);
        console.log(a[0]);
    }
}

// Examples of removing array element
// remove array element by shifting elements from right to left
contract ArrayRemoveByShifting {
    // [1, 2, 3] -- remove(1) --> [1, 3, 3] --> [1, 3]
    // [1, 2, 3, 4, 5, 6] -- remove(2) --> [1, 2, 4, 5, 6, 6] --> [1, 2, 4, 5, 6]
    // [1, 2, 3, 4, 5, 6] -- remove(0) --> [2, 3, 4, 5, 6, 6] --> [2, 3, 4, 5, 6]
    // [1] -- remove(0) --> [1] --> []

    uint256[] public arr;

    function remove(uint256 _index) public {
        require(_index < arr.length, "index out of bound");

        for (uint256 i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        arr.pop();
    }

    function test() external {
        arr = [1, 2, 3, 4, 5];
        remove(2);
        // [1, 2, 4, 5]
        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 3);
        assert(arr[3] == 4);
        assert(arr.length == 4);

        arr = [1];
        remove(0);
        // []
        assert(arr.length == 0);
    }
}

contract ArrayReplaceFromEnd {
    uint256[] public arr;

    // Deleting an element creates a gap in the array.
    // One trick to keep the array compact is to move
    // the last element into the place to delete.
    function remove(uint256 index) public {
        // Move the last element into the place to delete
        arr[index] = arr[arr.length - 1];
        // Remove the last element
        arr.pop();
    }

    function test() public {
        arr = [1, 2, 3, 4];

        remove(1);
        // [1, 4, 3]
        assert(arr.length == 3);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr[2] == 3);

        remove(2);
        // [1, 4]
        assert(arr.length == 2);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
    }
}

// Enum
// Solidity supports enumerables and they are useful to model choice an keep track of state.
// Enums can be declared outside of a contract.
contract Enum {
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }

    // Default value is the first element listed in
    // definition of the type, in this case "Pending"
    Status public status;

    // Returns uint
    // Pending - 0
    // Shipped - 1
    // Accepted - 2
    // Rejected - 3
    // Canceled - 4
    function get() public view returns (Status) {
        return status;
    }

    // Update status by passing uint into input
    function set(Status _status) public {
        status = _status;
    }

    // You can update to a specific enum like this
    function cancel() public {
        status = Status.Canceled;
    }

    // delete resets the enum to its first value, 0
    function reset() public {
        delete status;
    }
}

// Declaring and import Enum
// File that the enum is declared in
// This is saved 'EnumDeclaration.sol'
enum Status {
    Pending,
    Shipped,
    Accepted,
    Rejected,
    Canceled
}

// File that imports the enum abouve
// import "./EnumDeclaration.sol"
contract Enum1 {
    Status public status;
}

// Stucts
// You can define your own type by creating a struct.
// They are useful for grouping together related data.
// Structs can be declared outside of a contract and imported in another contract.
contract Todos {
    struct Todo {
        string text;
        bool completed;
    }

    // An array of 'Todo' structs
    Todo[] public todos;

    function create(string calldata _text) public {
        // 3 ways to initialize a struct
        // - calling it like a function
        todos.push(Todo(_text, false));

        // - key value mapping
        todos.push(Todo({text: _text, completed: false}));

        // - initialize an empty struct and then update it
        Todo memory todo;
        todo.text = _text;
        // todo.completed initialized to false
        todos.push(todo);
    }

    // Solidity automatically created a getter for 'todos' so
    // you don't actually need this function.
    function get(uint256 _index)
        public
        view
        returns (string memory text, bool completed)
    {
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }

    // update text
    function updateText(uint256 _index, string calldata _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    // update completed
    function updateCompleted(uint256 _index) public {
        Todo storage todo = todos[_index];
        todo.completed = !todo.completed;
    }
}

// Declaring and importing Struct
/*
pragma solidity ^0.8.13;
// This is saved 'StructDeclaration.sol'

struct Todo {
    string text;
    bool completed;
}

pragma solidity ^0.8.13;

import "./StructDeclaration.sol";

contract Todos {
    // An array of 'Todo' structs
    Todo[] public todos;
}
*/

// Data Locations - Storage, Memory and Calldata
// Variables are declared as either storage, memory or calldata to explicityly specify the location of the data.
// - storage - variable is a state variable (store on blockchain)
// - memory - variable is in memory and it exists while a function is being called
// - calldata - special data location that contains function arguments.
contract DataLocations {
    uint256[] public arr;
    mapping(uint256 => address) map;
    struct MyStruct {
        uint256 foo;
    }
    mapping(uint256 => MyStruct) myStructs;

    function f() public {
        // call _f with state variables
        _f(arr, map, myStructs[1]);

        // get a struct from a mapping
        MyStruct storage myStruct = myStructs[1];
        // create a struct in memory
        MyStruct memory myMemStruct = myStructs[0];
    }

    function _f(
        uint256[] storage _arr,
        mapping(uint256 => address) storage _map,
        MyStruct storage _myStruct
    ) internal {
        // do something with storage variables
    }

    // You can return memory variables
    function g(uint256[] memory _arr) public returns (uint256[] memory) {
        // do something with memory array
        return _arr;
    }

    function h(uint256[] calldata _arr) external {
        // do something with calldata array
    }
}

// Function
// There are several ways to return outputs from a function.
// Public functions cannot accept certain data types as inputs or outputs.
contract Function {
    // Functions can return multiple values.
    function returnMany()
        public
        pure
        returns (
            uint256,
            bool,
            uint256
        )
    {
        return (1, true, 2);
    }

    // Return values can be named.
    function named()
        public
        pure
        returns (
            uint256 x,
            bool b,
            uint256 y
        )
    {
        return (1, true, 2);
    }

    // Return values can be assigned to their name.
    // In this case the return statement can be ommited.
    function assigned()
        public
        pure
        returns (
            uint256 x,
            bool b,
            uint256 y
        )
    {
        x = 1;
        b = true;
        x = 2;
    }

    // Use destructuring assignment when calling another
    // function that returns multiple values.
    function destructuringAssignments()
        public
        pure
        returns (
            uint256,
            bool,
            uint256,
            uint256,
            uint256
        )
    {
        (uint256 i, bool b, uint256 j) = returnMany();

        // Values can be left out.
        (uint256 x, , uint256 y) = (4, 5, 6);

        return (i, b, j, x, y);
    }

    // Cannot use map for either input or output

    // Can use array for input
    function arrayInput(uint256[] memory _arr) public {}

    // Canuse array for output
    uint256[] public arr;

    function arrayOutput() public view returns (uint256[] memory) {
        return arr;
    }
}

// View and Pure Functions
// Getter functions can be declared view or pure.
// View function declares that no state will be changed.
// Pure function declares that no state variable will be changed or read.
contract ViewAndPure {
    uint256 public x = 1;

    // Promise not to modify the state.
    function addToX(uint256 y) public view returns (uint256) {
        return x + y;
    }

    // Promise not to modify or read from the state.
    function add(uint256 i, uint256 j) public pure returns (uint256) {
        return i + j;
    }
}

// Error
// An error will undo all changes made to the state during a trasaction.
// You can throw an error by calling require, revert or assert.
// - require is used to validate inputs and conditions before execution.
// - revert is similar to require. See the code below for details.
// - assert is used to check for code that should never be false. Falling assertion probably means that there is a bug.
// Use custom error to save gas.
contract Error {
    function testRequire(uint256 _i) public pure {
        // Require should be used to validate conditions such as:
        // - inputs
        // - conditions before execution
        // - return values from calls to other functions
        require(_i > 10, "Input must be greater than 10");
    }

    function testRevert(uint256 _i) public pure {
        // Revert is useful when the condition to check is complex.
        // This code does the exact same thing as the example above
        if (_i <= 10) {
            revert("Input must be greater than 10");
        }
    }

    uint256 public num;

    function testAssert() public view {
        // Assert should only be used to test for internal errors,
        // and to check invariants.

        // Here we assert that num is always equal to 0
        // since it is impossible to update the value of num.
        assert(num == 0);
    }

    // custom error
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function testCustomError(uint256 _withdrawAmount) public view {
        uint256 bal = address(this).balance;
        if (bal < _withdrawAmount) {
            revert InsufficientBalance({
                balance: bal,
                withdrawAmount: _withdrawAmount
            });
        }
    }
}

contract Account {
    uint256 public balance;
    uint256 public constant MAX_UINT = 2**256 - 1;

    function deposit(uint256 _amount) public {
        uint256 oldBalance = balance;
        uint256 newBalance = balance + _amount;

        // balance + _amount does not overflow if balance + _amount >= balance
        require(newBalance >= oldBalance, "Overflow");

        balance = newBalance;
        assert(balance >= oldBalance);
    }

    function withdraw(uint256 _amount) public {
        uint256 oldBalance = balance;

        // balance - _amount does not underflow if balance >= amount
        require(balance >= _amount, "Underflow");

        if (balance < _amount) {
            revert("Underflow");
        }

        balance -= _amount;
        assert(balance <= oldBalance);
    }
}

// Function Modifier
// Modifiers are code that can be run before and / or after a function call.
// Modifiers can be used to:
// - Restrict access
// - Validate inputs
// - Guard against reentrancy hack
contract FunctionModifier {
    // We will use these variables to demostrate how to use modifiers.
    address public owner;
    uint256 public x = 10;
    bool public locked; // for noreentrancy modifier

    constructor() {
        // Set the transaction sender as the owner of the contract.
        owner = msg.sender;
    }

    // Modifier to check that the caller is the owner of the contract.
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        // Underscore is a special character only used inside a function modifier
        // and it tells Solidity to execute the rest of the code.
        _;
    }

    // Modifiers can take inputs. This modifier checks that the address passed in is
    // not the zero address
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }

    function changeOwner(address _newOwner)
        public
        onlyOwner
        validAddress(_newOwner)
    {
        owner = _newOwner;
    }

    // Modifiers can be called before and / or after a function.
    // This modifier prevents a function from being called while
    // it is still executing.
    modifier noReentrancy() {
        require(!locked, "No reentrancy");

        locked = true;
        _;
        locked = false;
    }

    function decrement(uint256 i) public noReentrancy {
        x -= i;
        if (i > 1) {
            decrement(i - 1);
        }
    }
}

// Event
// Event allow logging to the Ethereum blockchain. Some use cases for events are:
// - Listening for events and updating user interface
// - A cheap form of storage
contract Event {
    // Event declaration
    // Up to 3 parameters can be indexed.
    // Indexed parameters helps you filter the logs by the indexed parameter
    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hello World!");
        emit Log(msg.sender, "Hello EVM!!");
        emit AnotherLog();
    }
}

// Constructor
// A constructor is an optional function that is executed upon contract creation.
// Here  are examples of ho to pass arguments to constructors.

// Base contract X
contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

// Base contract Y
contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// There are 2 ways to initialize parent contract with parameters.

// Pass the parameters here in the inheritance list.
contract BBB is X("Input to X"), Y("Input to Y") {

}

contract CCC is X, Y {
    // Pass the parameters there in the constructor,
    // similar to function modifiers.
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}

// Parent constructors are always called in the order of inheritance
// regardless of the order of parent contracts listed in the
// constructor of the child contract.

// Order of constructors called:
// 1. X
// 2. Y
// 3. DDD
contract DDD is X, Y {
    constructor() X("X was called") Y("Y was called") {}
}

// Order of constructors called:
// 1. X
// 2. Y
// 3. EEE
contract EEE is X, Y {
    constructor() Y("Y was called") X("X was called") {}
}

// Inheritance
// Solidity supports multiple inheritance. Contracts can inherit other contract by using the is keyword.
// Function that is going to be overridden by a child contract must be declared as virtual.
// Function that is going to override ap rent function must use the keyword override.
// Order of inheritance is important.
// Your have to list the parent contracts in the order from "most base-like" to "most derived".

/**
      A
     / \
    B   C
   / \  /
  F   D,E
 */

contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

contract B is A {
    // Override A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
}

contract C is A {
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

// Contract can inherit from multiple parent contracts.
// When a function is called that is defined multiple times in different contracts,
// parent contracts are searched from right to left, and in depth-first manner.
contract D is B, C {
    // D.foo() returns "C"
    // since C is the right most parent contract with function foo()
    function foo() public pure override(B, C) returns (string memory) {
        return super.foo();
    }
}

contract E is C, B {
    // E.foo() returns "B"
    // since B is the right most parent contract with function foo()
    function foo() public pure override(C, B) returns (string memory) {
        return super.foo();
    }
}

// inheritance must be ordered from "most base-like" to "most derived".
// Swapping the order of A and B will throw a compilation error.
contract F is A, B {
    function foo() public pure override(A, B) returns (string memory) {
        return super.foo();
    }
}

// Shadowing Inherited State Variables
// Unlike functions, state variables cannot be overridden by re-declaring it in the child contract.
// Let's learn how to correctly override inherited state variables.
contract AA {
    string public name = "Contract AA";

    function getName() public view returns (string memory) {
        return name;
    }
}

// Shadowing is disallowed in Solidity o.6
// This will not compile
// contract B is A {
//  string public name = "Contract B";
// }

contract CC is AA {
    // This is the correct wal to override inherited state variables.
    constructor() {
        name = "Contract C";
    }

    // C.getName returns "Contract C"
}

// Payable
// Functions and addresses declared payable can receive ether inter the contract.

contract Payable {
    // Payable address can receive Ether
    address payable public owner;

    // Payable constructor can receive Ether
    constructor() payable {
        owner = payable(msg.sender);
    }

    // Function to deposit Ether into this contract.
    // Call this function along with some Ether.
    // The balance of this contract will be automatically updated.
    function deposit() public payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Call this function along with some ether.
    // The function will throw an error since this function is not payable.
    function notPayable() public {}

    // Function to withdraw all Ether from this contract
    function withdraw() public {
        // get the amount of Ether stored in this contract
        uint256 amount = address(this).balance;

        // send all Ether to owner
        // Owner can receive Ether since the address of owner is payable
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    // Function to transfer Ether from this contract to address from input
    function transfer(address payable _to, uint256 _amount) public {
        // Note that "to" is declared as payable
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
}

// Sending Ether (transfer, send, call)
// How to send Ether?
// You can send Ether to other contracts by
// - transfer(2300 gas, throws error)
// - send(2300 gas, returns bool)
// - call(forward all gas or set gas, returns bool)
//
// How to receive Ether?
// A contract receiving Ether must have at least one of the functions below:
// - receive() external payable
// - fallback() external payable
// receive() is called if msg.data is empty, otherwise fallback() is called.
//
// Which method should you use?
// call in combination with re-entrancy gard is the recommended method to use after December 2019.
// Guard against re-entrancy by
// - making all state changes before calling other contracts
// - using re-entrancy guard modifier.
contract ReceiveEther {
    /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract SenderEther {
    function sendViaTransfer(address payable _to) public payable {
        // This function is no longer recommended for sending Ether.
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) public payable {
        // Send returns a boolean value indicating success or failure.
        // This function is not recommended for sending Ether.
        bool sent = _to.send(msg.value);
    }

    function sendViaCall(address payable _to) public payable noReentrancy {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }

    bool private locked;
    modifier noReentrancy() {
        require(!locked, "No Reentrancy");

        locked = true;
        _;
        locked = false;
    }
}

// Fallback
// fallback is a function that does not take any arguments and does not return anying.
// It is executed either when
// - a function that does not exist is called or
// - Ether is sent directly to a contract but receive() does not exist or msg.data is not empty.
// fallback has a 2300 gas limit when called by transfer or send.
contract Fallback {
    event Log(uint256 gas);

    // Fallback function must be declared as external.
    fallback() external payable {
        // send / transfer (forwards 2300 gas to this fallback function)
        // call (forward all the gas)
        emit Log(gasleft());
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract SendToFallback {
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function callFallback(address payable _to) public payable {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}
