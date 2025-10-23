// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Todo{
    struct task{
        string name;
        bool isCompleted;
    }

    task[] public tasks;

    function createTask(string memory _name) public {
        tasks.push(task(_name, false));
    }

    function modiName(uint256 _index, string memory newname) public {
        tasks[_index].name = newname;
    }

    function modiState(uint256 _index)public {
        tasks[_index].isCompleted = !tasks[_index].isCompleted;
    }

    function get(uint256 _index)view public returns(string memory, bool isComplete){
        return(tasks[_index].name, tasks[_index].isCompleted);
    }


}