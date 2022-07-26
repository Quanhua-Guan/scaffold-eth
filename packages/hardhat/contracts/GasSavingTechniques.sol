// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Gas Saving Techniques
// Some gas saving techniques.
// - Replace memory with call data
// - Loading state variable to memory
// - Replace for loop i++ with ++i
// - Caching array elements
// - Short circuit

// gas golf
contract /*GasGolf*/YourContract {
    // start - 50908 gas
    // use calldata - 49163 gas
    // load state variables to memory - 48952 gas
    // short circuit - 48634 gas
    // loop increments - 48244 gas
    // cache array length - 48209 gas
    // load array elements to memory - 48047 gas
    // uncheck i overflow/underflow - 47309 gas

    uint public total;

    // start - not gas optimized
    function sumIfEvenAndLessThan99(uint[] memory nums) external {
        for (uint i = 0; i < nums.length; i += 1) {
            bool isEven = nums[i] % 2 == 0;
            bool isLessThan99 = nums[i] < 99;
            if (isEven && isLessThan99) {
                total += nums[i];
            }
        }
    }

    // optimized
    function sumIfEvenAndLessThan99Optimized(uint[] calldata nums) external { // use calldata
        uint len = nums.length; // cache array length in memory

        for (uint i = 0; i < len;) { // use cache array length
            uint num = nums[i]; // load array element to memory
            if (num % 2 == 0 && num < 99) { // short circurt
                total += num; // load state variables to memory
            }
            unchecked { // unchack i overfolow / underflow
                ++i;// use ++i instead i++ or i += 1
            }
        }
    }
}