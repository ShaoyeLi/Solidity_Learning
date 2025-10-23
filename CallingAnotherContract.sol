// Create two contracts: "Caller" and "Callee". Callee has a function "getNumber" returning 42. 
// In Caller, include a function "callGetNumber" that calls Callee's function using its address and returns the result.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Callee{
    function getNumber() public pure returns(uint256){
        return 42;
    }
}

contract Caller{
    function callGetNumber(address _calleeAddress) public pure returns(uint256){
        Callee callee = Callee(_calleeAddress);
        return callee.getNumber();
    }
}