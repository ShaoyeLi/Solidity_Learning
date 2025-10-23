// Write a Solidity contract named "SimpleStorage" that stores a single unsigned integer value. 
// Include a function to set the value 
//and a function to retrieve it. Use a constructor to initialize the value to 0.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract SimpleStorage{
    uint256 private storedValue;

    constructor(){
        storedValue = 0;
    }

    function setValue(uint256 _value) public {
        
    } 

    function getValue() view public returns(uint256){
        return storedValue;
    }

}