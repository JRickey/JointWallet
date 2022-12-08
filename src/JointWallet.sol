// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "solmate/auth/Owned.sol";

contract JointWallet is Owned {
    address payable public owner1;
    address payable public owner2;

    constructor(address coOwner) Owned(msg.sender) {
        owner1 = payable(msg.sender);
        owner2 = payable(coOwner);
    }

    receive() external payable {
        require(msg.sender == owner1 || msg.sender == owner2, "Caller is not authorized to deposit");
    }

    fallback() external payable {
        require(msg.sender == owner1 || msg.sender == owner2, "Caller is not authorized to deposit");
    }

    function withdraw(uint _amount) external {
        require(msg.sender == owner1 || msg.sender == owner2, "caller is not authorized to withdraw");
        (bool sent, bytes memory data) = msg.sender.call{value: _amount}("");
        require(sent == true);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function setNewCoOwner(address newCoOwner) external onlyOwner {
        owner2 = payable(newCoOwner);
    }
    
}
