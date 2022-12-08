// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "solmate/tokens/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        address to,
        uint256 supply

    ) ERC20(name, symbol, decimals) {
        _mint(to, supply);
    }

    
}