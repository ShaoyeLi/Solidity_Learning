// Define a base contract "Animal" with a virtual function "makeSound" that returns a string "Sound". 
// Then, create a derived contract "Dog" that inherits from "Animal" and overrides "makeSound" to return "Woof".

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Animal{
    function makeSound() public virtual returns(string memory){
        return "Sound";
    }
}


contract Dog is Animal{
    function makeSound() public pure override returns(string memory){
        return "woof";
    }
}