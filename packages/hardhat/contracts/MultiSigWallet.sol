// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Multi-Sig Wallet (多签钱包)
// Let's create an multi-sig wallet. Here are the specifications.
// The wallet owners can:
// - submit a transaction.
// - approve and revoke approval of pending transactions.
// - anyone can execute a transacation after enough owners has approved it.

contract TextContract {
    uint256 public i;

    function callMe(uint256 j) public {
        i += j;
    }

    function getData() public pure returns (bytes memory) {
        return abi.encodeWithSignature("callMe(uint256)", 123);
    }
}

// Multi-Sig Wallet
contract MultiSigWallet {
    event Deposit(address indexed sender, uint256 amount, uint256 balance);
    event SubmitTransaction(
        address indexed owner,
        uint256 indexed txIndex,
        address indexed to,
        uint256 value,
        bytes data
    );
    event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint256 indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);

    address[] public owners; // 多个合约所有者
    mapping(address => bool) public isOwner; // 用于判断是否是合约所有者, 避免每次都取遍历 owners 数组.
    uint256 public numConfirmationsRequired; // 至少需要多少个合约所有者同意才能执行交易.

    // 交易对象
    struct Transaction {
        address to; // 发送ether给to地址
        uint256 value; // 发送的 wei 数量
        bytes data; // 额外数据
        bool executed; // 标志交易是否已经执行
        uint256 numConfirmations; // 记录已经被多少个合约所有者所同意.
    }

    // mapping from tx index => owner => bool
    // 判断某个交易是否被某个合约所有者所同意
    mapping(uint256 => mapping(address => bool)) public isConfirmed;

    // 记录所有的交易
    Transaction[] public transactions;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "tx does not exist");
        _;
    }

    modifier notExecuted(uint256 _txIndex) {
        require(!transactions[_txIndex].executed, "tx already executed");
        _;
    }

    modifier notComfirmed(uint256 _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "tx already confirmed");
        _;
    }

    constructor(address[] memory _owners, uint256 _numComfirmationsRequired) {
        require(_owners.length > 0, "Owners required");
        require(
            _numComfirmationsRequired > 0 &&
                _numComfirmationsRequired <= _owners.length,
            "invalid number of required confirmation"
        );

        uint256 length = _owners.length;
        for (uint256 i = 0; i < length; ) {
            address owner = _owners[i];

            require(owner != address(0), "invalid address");
            require(!isOwner[owner], "owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
            unchecked {
                ++i;
            }
        }
        numConfirmationsRequired = _numComfirmationsRequired;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function submitTransaction(
        address _to,
        uint256 _value,
        bytes memory _data
    ) public onlyOwner {
        uint256 txIndex = transactions.length;

        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
                numConfirmations: 0
            })
        );

        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    function confirmTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
        notComfirmed(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    function executeTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        require(
            transaction.numConfirmations >= numConfirmationsRequired,
            "cannot execute tx, not enough comfirmations"
        );

        transaction.executed = true;

        (bool success, ) = payable(transaction.to).call{
            value: transaction.value
        }(transaction.data);
        require(success, "tx failed");

        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    function revokeConfirmation(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        require(isConfirmed[_txIndex][msg.sender], "tx not confirmed by you");

        transaction.numConfirmations -= 1;
        isConfirmed[_txIndex][msg.sender] = false;

        emit RevokeConfirmation(msg.sender, _txIndex);
    }

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }

    function getTransaction(uint _txIndex) public view txExists(_txIndex) returns (
        address to,
        uint value,
        bytes memory data,
        bool executed,
        uint numConfirmations
    ) {
        Transaction storage transaction = transactions[_txIndex];
        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }

    function getData() public pure returns (bytes memory) {
        return abi.encodeWithSignature("callMe(uint256)", 123);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
