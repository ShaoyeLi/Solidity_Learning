// Write a contract "EventEmitter" with a function "emitValue" that takes a uint256, 
// stores it in an array, and emits an event "ValueEmitted" with the value and sender address.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventEmitter {
    uint256[] public values;

    event ValueEmitted(address indexed sender, uint256 value);

    function emitValue(uint256 _value) public {
        values.push(_value);
        emit ValueEmitted(msg.sender, _value);
    }
}