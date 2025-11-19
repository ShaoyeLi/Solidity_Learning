// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Faucet{
    receive()external payable{}

    address immutable OWNER;
    constructor(){
        OWNER = msg.sender;
    }

    modifier onlyOwner(){
        require (msg.sender==OWNER, "you are not owner");
        _;
    }

    function Withdraw(uint256 withdraw_amount) public onlyOwner payable{
        require(withdraw_amount <=100000000000000000000);

        payable(msg.sender).transfer(withdraw_amount);
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
}



