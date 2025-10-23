// Create a contract "Owned" with an owner address set in the constructor. 
// Add a modifier "onlyOwner" that restricts a function to be called only by the owner. 
// Include a function "changeOwner" that uses this modifier to update the owner


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Owner{
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier OnlyOwner(){
        require(msg.sender == owner, "you are not owner");
        _;
    }


    function changeOwner(address _newOwner)public OnlyOwner{
        owner = _newOwner;
    }


}
