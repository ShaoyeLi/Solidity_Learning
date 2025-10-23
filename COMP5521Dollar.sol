// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract COMP5521Dollar is ERC20, Ownable{

    constructor(string memory name_, string memory symbol_) 
    ERC20(name_, symbol_)
    Ownable(msg.sender)//构造函数冲突，ownable和erc20的构造函数传参不同，给各自传参就可以了
    {
        _mint(msg.sender, 10000 * 10**18);
        
    }

}
