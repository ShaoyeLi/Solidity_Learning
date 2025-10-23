// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NFT{
    mapping(address => uint256) balance;
    string name;
    string symbol;


    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
        mint(msg.sender, 100);
    }

    function mint(address owner, uint256 amount) private{

    }

    function transfer(address to, uint256 amount) public{

    }
}