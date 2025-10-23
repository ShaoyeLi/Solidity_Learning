// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Faucet{
    receive()external payable{}

    function Withdraw(uint256 withdraw_amount) public payable{
        require(withdraw_amount <=100000000000000000000);

        payable(msg.sender).transfer(withdraw_amount);
    }
}



