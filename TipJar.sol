//别人存小费,把钱从自己钱包存到我的合约地址下
//我取小费，我把钱从合约地址下取到自己钱包里，需要知道取得数额
//我查询余额 


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Tipjar{
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require (msg.sender == owner, "you are not owner!");
        _;
        
    }

    function tip() public payable {
        require (msg.value > 0, "you have no money!");
    }

    function withdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;//this​​：相当于“我自己”（整个人的实体）。
// ​​//address(this)​:相当于“我的银行账号”（用于存钱、查余额）。
// ​//​错误操作​​：
// //问一个人“你的余额是多少？”（this.balance）→ 他无法回答，因为余额是银行账号的属性，不是人的属性。
// //​​正确操作​​：
// //先问“你的银行账号是什么？”（address(this)），再用账号查余额（.balance）。
        require (contractBalance > 0, "empty contract!");
        payable(owner).transfer(contractBalance);
    }

    function check() public view onlyOwner  returns(uint256){
        return (address(this).balance); 
    }
}