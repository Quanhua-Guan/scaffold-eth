// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// An example of a basic wallet.
// - Anyone can send ETH.
// - Only the owner can withdraw.

contract EtherWallet {
    address payable public owner;

    constructor(address payable _owner) {
        owner = _owner;
    }

    receive() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function withdraw(uint _amount) external onlyOwner {
        //payable(msg.sender).transfer(_amount);
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Withdraw failed");
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getChainId() public view returns (uint) {
        return block.chainid;
    }
}