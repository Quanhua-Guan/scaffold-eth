// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract YourContract {
    int256 public count;

    uint256 immutable IMMUTABLE_X = 999;

    constructor() {}

    function testNegateUnsignedInteger(uint256 x) public pure {
        int256 i = 0;
        while (i < 1000000) i++;
        i = int256(type(uint256).max - x + 1) + i;
    }

    function testAddX(uint256 x) public {
        count += int256(x);
    }

    function fCalldata(uint256[] memory _x)
        public
        pure
        returns (uint256[] memory)
    {
        //参数为calldata数组，不能被修改
        _x[0] = 0; //这样修改会报错
        return (_x);
    }

    function zeroAddress() public pure returns (address) {
        return address(0);
    }

    function someFunction() public pure {
        uint256[] memory a = new uint256[](2);
        bytes memory arr9 = new bytes(9);
        uint256[3] memory arrLiterals = [uint256(1), 2, 3];

        uint256[] memory t = new uint256[](2);
        t[0] = 0;
        t[1] = 1;
    }

    function a() external {}

    function b() internal {}

    mapping(uint256 => bool) public isUser;

    function insertionSort_Right(uint256[] memory input)
        public
        pure
        returns (uint256[] memory)
    {
        for (uint256 i = 1; i < input.length; i++) {
            uint256 tmp = input[i];
            uint256 j = i - 1;

            bool flag;
            while (tmp < input[j]) {
                input[j + 1] = input[j];

                if (j == 0) {
                    flag = true;
                    break;
                }
                j--; // please keep in mind that uint cant not be negative, or it will cause error and revert.
            }

            if (flag) {
                input[j] = tmp;
            } else {
                input[j + 1] = tmp;
            }
        }
        return input;
    }

    // 插入排序 正确版
    function insertionSort(uint256[] memory a)
        public
        pure
        returns (uint256[] memory)
    {
        // note that uint can not take negative value
        for (uint256 i = 1; i < a.length; i++) {
            uint256 temp = a[i];
            uint256 j = i;
            while ((j >= 1) && (temp < a[j - 1])) {
                a[j] = a[j - 1];
                j--;
            }
            a[j] = temp;
        }
        return (a);
    }

    address public owner;

    modifier onlyOwner() /*()*/
    {
        // 如果没有参数 "()" 可以省略掉
        require(msg.sender == owner);
        _;
    }

    event TestEvent(
        address indexed addr1,
        address indexed addr2,
        uint indexed index2,
        uint256 value
    );

    receive() external payable {}

    fallback() external payable {}
}
