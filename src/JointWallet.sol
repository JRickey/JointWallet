// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "solmate/auth/Owned.sol";
import "lib/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "lib/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "solmate/tokens/ERC20.sol";
import "lib/@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "lib/@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "lib/@openzeppelin/contracts/utils/introspection/ERC165.sol";


contract JointWallet is Owned, IERC721Receiver, IERC1155Receiver{

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

    function withdrawERC721(IERC721 _ERC721, uint id) public {
        require(approved[msg.sender] == true, "caller is not authorized to withdraw ERC721");
        _ERC721.transferFrom(address(this), msg.sender, id);
    }

    function withdrawERC20(ERC20 _ERC20, uint _amount) public {
        require(approved[msg.sender] == true, "caller is not authorized to withdraw ERC20");
        _ERC20.transfer(msg.sender, _amount);
    }

    function withdrawERC1155(IERC1155 _ERC1155, uint256 _tokenID, uint256 _amount) public {
        require(approved[msg.sender] == true, "caller is not authorized to withdraw ERC1155");
        _ERC1155.safeTransferFrom(address(this), msg.sender, _tokenID, _amount, "0x01");
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function swapOwner(address newCoOwner, address oldCoOwner) external onlyOwner {
        addAddress(newCoOwner);
        removeAddress(oldCoOwner);
    }

    function onERC721Received(address, address, uint256, bytes calldata) override external virtual returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
    
    function onERC1155Received(address, address, uint256, uint256, bytes calldata) override external virtual returns (bytes4) {
        return IERC1155Receiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(address, address, uint256[] calldata, uint256[] calldata, bytes calldata) override external virtual returns (bytes4) {
        return IERC1155Receiver.onERC1155BatchReceived.selector;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return false;
    }
}
