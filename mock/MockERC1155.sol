pragma solidity >=0.8.0;

import "lib/@openzeppelin/contracts/access/Ownable.sol";
import "lib/@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract MockERC1155 is Ownable, ERC1155 {
    constructor(address to) ERC1155("0xBenis/"){
        _mint(to, 0, 10, "0x01");
    }

    function uri(uint256 _id) public view virtual override returns (string memory){
        return string(abi.encodePacked(super.uri(_id), _id));
    }
}