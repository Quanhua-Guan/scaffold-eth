// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Calling Parent Contracts
// Parent contracts can be called directly, or by using the keyword super.
// by using the keyword super, all of the imediate parent contracts will be called.
/* Inheritance tree
   A
  / \
 B   C
  \ /
   D
*/

contract A_ {
    // This is called an event. Your canemit events from your function
    // and they are logged into the transaction log.
    // In our case, this will beuseful for tracing function calls.
    event Log(string message);

    function foo() public virtual {
        emit Log("A_.foo called");
    }

    function bar() public virtual {
        emit Log("A_.bar called");
    }
}

contract B_ is A_ {
    function foo() public virtual override {
        emit Log("B.foo called");
        A_.foo();
    }

    function bar() public virtual override {
        emit Log("B.bar called");
        super.bar();
    }
}

contract C_ is A_ {
    function foo() public virtual override {
        emit Log("C.foo called");
        A_.foo();
    }

    function bar() public virtual override {
        emit Log("C.bar called");
        super.bar();
    }
}

contract D_ is B_, C_ {
    // Try:
    // - Call D.foo and check the transaction logs.
    //   Although D inherits A, B and C, it only called C and then A.
    // - Call D.bar and check the transaction logs.
    //   D called C, then B, and finnally A.
    //   Although super was called twice (by B and C) it only called A once.

    function foo() public override(B_, C_) {
        super.foo();
    }

    function bar() public override(B_, C_) {
        super.bar();
    }
}