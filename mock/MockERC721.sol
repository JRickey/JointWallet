// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "lib/@openzeppelin/contracts/access/Ownable.sol";
import "lib/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "lib/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MockNFT is ERC721, ERC721Enumerable, Ownable {
    constructor(address to) ERC721("MockNFT", "MNFT") {
        _safeMint(to, 1);
        _safeMint(to, 2);
        _safeMint(to, 3);
        _safeMint(to, 4);
        _safeMint(to, 5);
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 id)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return string(abi.encodePacked("it never happened/", id));
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}