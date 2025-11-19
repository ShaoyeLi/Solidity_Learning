// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PiggyBank (Faucet-Style)
 * @dev A simple, personal smart contract to receive Ether deposits
 * via **direct transfer**.
 * The student ID is stored to identify the owner.
 */
contract PiggyBank {

    address public immutable owner;
    string public studentID;

    /**
     * @dev Sets the deployer as the owner and stores their student ID.
     * @param _studentID The student ID of the deployer.
     */
    constructor(string memory _studentID) {
        owner = msg.sender;
        studentID = _studentID;
    }

    /**
     * @dev This is the **receive()** function.
     * It is automatically triggered when Ether is sent directly to this
     * contract's address without any function call data (e.g., a simple transfer
     * from a wallet).
     * It replaces the need for a specific 'deposit' function.
     */
    receive() external payable {
        // We keep the check to ensure no 0-value deposits
        require(msg.value > 0, "Deposit must be greater than zero");
    }

    /**
     * @dev Returns the total balance of Ether held by this contract.
     * The balance is returned in Wei.
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}