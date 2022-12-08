// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/JointWallet.sol";

contract JointWalletTest is Test {
    JointWallet public jointWallet;
    address private coOwner = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    function setUp() public {
        jointWallet = new JointWallet(coOwner);
    }

    function testBalance() public {
        vm.deal(address(this), 10 ether);
        address(jointWallet).call{value: 1 ether}("");
        assert(jointWallet.getBalance() == 1 ether);
    }

    function testDeposit() public {
        address incorrect = address(1337);
        vm.deal(incorrect, 10 ether);
        vm.prank(incorrect);
        address(jointWallet).call{value: 1 ether}("");
        assert(jointWallet.getBalance() == 0 ether);
    }

    function testWithdraw() public {
        address(jointWallet).call{value: 10 ether}("");
        address incorrect = address(1337);
        vm.deal(incorrect, 1 ether);
        vm.prank(incorrect);
        vm.expectRevert("caller is not authorized to withdraw");
        jointWallet.withdraw(10 ether);        
    }

    function testSetNewCoOwner() public {
        vm.prank(coOwner);
        vm.expectRevert("UNAUTHORIZED");
        jointWallet.addAddress(address(1337));

        jointWallet.addAddress(address(420));
        vm.prank(coOwner);
        vm.expectRevert("UNAUTHORIZED");
        jointWallet.removeAddress(address(420));

    }



    
}
