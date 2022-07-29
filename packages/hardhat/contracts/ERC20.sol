// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/IERC20.sol
interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approve(address indexed owner, address indexed spender, uint value);
}

// Example of ERC20 token contract.

contract ERC20 is IERC20 {
    uint public _totalSupply; // 代币总量
    mapping(address => uint) public _balanceOf; // 用户余额
    mapping(address => mapping(address => uint)) public _allowance; // 用于批准他人花费自己账户中本代币的限额
    string public name = "Solidity by Example - GuanQuanhua";
    string public symbol = "SOLBYEX";
    uint public decimals = 18;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function totalSupply() public view override returns (uint) {
        return _totalSupply;
    }

    function transfer(address recipient, uint amount) external virtual override returns (bool) {
        _balanceOf[msg.sender] -= amount;
        _balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }


    function balanceOf(address account) external view override returns (uint) {
        return _balanceOf[account];
    }

    function allowance(address owner, address spender) external view override returns (uint) {
        return _allowance[owner][spender];
    }

    function approve(address spender, uint amount) external virtual override returns (bool) {
        _allowance[msg.sender][spender] = amount;
        emit Approve(msg.sender, spender, amount);
        return true;
    }

    function approve_1(address owner, address spender, uint amount) external virtual returns (bool) {
        _allowance[owner][spender] = amount;
        emit Approve(owner, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external virtual override returns (bool) {
        _allowance[sender][msg.sender] -= amount;
        _balanceOf[sender] -= amount;
        _balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _mint(uint amount) internal {
        _balanceOf[msg.sender] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function mint(uint amount) external {
        _mint(amount);
    }

    function mintTo(address recepient, uint amount) external {
        _balanceOf[recepient] += amount;
        _totalSupply += amount;
        emit Transfer(recepient, address(0), amount);
    }

    function burn(uint amount) external {
        _balanceOf[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}

contract YourContract_ERC20 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        // Mint 100 tokens to msg.sender
        // Similar to how
        // 1 dollar = 100 cents
        // 1 token = 1 * (10 ** decimals)
        _mint(100 * 10 ** uint(decimals));
    }
}

// Contract to swap tokens
// Here is an example contract, TokenSwap, to trade one ERC20 token for another.
// This contract will swap tokens by calling 
//
// transferFrom(address sender, address recipient, uin256 amount)
//
// which will transfer amount of token from sender to recipient.
// For transferFrom to succeed, sender must
// - have more than amount tokens in their balance
// - allowed TokenSwap to withdrap amount tokens by calling approve
// prior to TokenSwap calling transferFrom

contract TokenSwap {
    ERC20 public token1;
    address public owner1;
    uint public amount1;

    ERC20 public token2;
    address public owner2;
    uint public amount2;

    constructor(
        // address _token1,
        // address _owner1,
        // uint _amount1,
        // address _token2,
        // address _owner2,
        // uint _amount2
    ) {
        token1 = new YourContract_ERC20("AAA", "A");
        owner1 = 0x6367B680d138569476dB383F288acBd157b8d44f;
        amount1 = 100;
        token1.mintTo(owner1, amount1);
        token2 = new YourContract_ERC20("BBB", "B");
        owner2 = 0x2d037eE181181576f8dE2464ED42448eAD84e34a;
        amount2 = 200;
        token2.mintTo(owner2, amount2);
    }

    function swap() public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        require(token1.allowance(owner1, address(this)) >= amount1, "Token 1 allowance too low");
        require(token2.allowance(owner2, address(this)) >= amount2, "Token 2 allowance too low");

        _safeTransferFrom(token1, owner1, owner2, amount1);
        _safeTransferFrom(token2, owner2, owner1, amount2);
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }

    function getToken11Balance() public view returns (uint) {
        return token1.balanceOf(owner1);
    }

    function getToken22Balance() public view returns (uint) {
        return token2.balanceOf(owner2);
    }

    function getToken12Balance_() public view returns (uint) {
        return token1.balanceOf(owner2);
    }

    function getToken21Balance_() public view returns (uint) {
        return token2.balanceOf(owner1);
    }

    function approveToken1() public {
        bool success = token1.approve_1(owner1, address(this), amount1);
        require(success, "approve failed");
    }

    function approveToken2() public {
        bool success = token2.approve_1(owner2, address(this), amount2);
        require(success, "approve failed");
    }

    function allowance1() public view returns (uint) {
        return token1.allowance(owner1, address(this));
    }

    function allowance2() public view returns (uint) {
        return token2.allowance(owner2, address(this));
    }
}