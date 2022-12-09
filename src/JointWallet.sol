// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "solmate/auth/Owned.sol";
import "solmate/tokens/ERC721.sol";
import "solmate/tokens/ERC20.sol";
import "solmate/tokens/ERC1155.sol";

contract JointWallet is Owned, ERC721TokenReceiver, ERC1155TokenReceiver{

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

    function withdrawEther(uint _amount) external {
        require(approved[msg.sender] == true, "caller is not authorized to withdraw ether");
        (bool sent, bytes memory data) = msg.sender.call{value: _amount}("");
        require(sent == true);
    }

    function withdrawERC721(ERC721 _ERC721, uint id) public {
        require(approved[msg.sender] == true, "caller is not authorized to withdraw ERC721");
        _ERC721.approve(address(this), id);
        _ERC721.safeTransferFrom(address(this), msg.sender, id);
    }

    function withdrawERC20(ERC20 _ERC20, uint _amount) public {
        require(approved[msg.sender] == true, "caller is not authorized to withdraw ERC20");
        _ERC20.approve(address(this), _amount);
        _ERC20.transferFrom(address(this), msg.sender, _amount);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function swapOwner(address newCoOwner, address oldCoOwner) external onlyOwner {
        addAddress(newCoOwner);
        removeAddress(oldCoOwner);
    }

    function onERC721Received(address, address, uint256, bytes calldata) override external virtual returns (bytes4) {
        return ERC721TokenReceiver.onERC721Received.selector;
    }
    
    function onERC1155Received(address, address, uint256, uint256, bytes calldata) override external virtual returns (bytes4) {
        return ERC1155TokenReceiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(address, address, uint256[] calldata, uint256[] calldata, bytes calldata) override external virtual returns (bytes4) {
        return ERC1155TokenReceiver.onERC1155BatchReceived.selector;
    }
}
