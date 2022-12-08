// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "solmate/auth/Owned.sol";

contract JointWallet is Owned {

    mapping(address => bool) public approved;

    constructor(address coOwner) Owned(msg.sender) {
        addAddress(msg.sender);
        addAddress(coOwner);
    }
    modifier isApproved() {
        require(approved[msg.sender] == true, "UNAUTHORIZED");

        _;
    }
    
    function addAddress(address _address) public onlyOwner{
        approved[_address] = true;
    }

    function removeAddress(address _address) public onlyOwner{
        delete approved[_address];
    }

    receive() external payable isApproved{

    }

    fallback() external payable isApproved{

    }

    function withdraw(uint _amount) external {
        require(approved[msg.sender] == true, "caller is not authorized to withdraw");
        (bool sent, bytes memory data) = msg.sender.call{value: _amount}("");
        require(sent == true);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function swapOwner(address newCoOwner, address oldCoOwner) external onlyOwner {
        addAddress(newCoOwner);
        removeAddress(oldCoOwner);
    }
    
}
