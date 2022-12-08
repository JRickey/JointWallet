// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/JointWallet.sol";
import "../mock/MockERC20.sol";

contract JointWalletTest is Test {
    JointWallet public jointWallet;
    address private coOwner = address(10);

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

    function testERC20() public{
        //deposit
        ERC20 gold = new MockERC20("Gold", "GLD", 12, address(jointWallet), 15);
        assert(gold.balanceOf(address(jointWallet)) == 15);

        //withdrawal
        address incorrect = address(1337);
        vm.prank(incorrect);
        assert(gold.approve(address(jointWallet),15));

    }

    



    
}
