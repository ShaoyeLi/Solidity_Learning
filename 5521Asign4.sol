// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SecretDepository
 * @author Comp5521
 * @notice Welcome, students! This is the smart contract for your assignment.
 * @dev This contract is a "digital lockbox". You will deposit a secret message
 * along with your student ID. To prove you completed the assignment, you must come back
 * after a short waiting period to "claim" your submission and retrieve your message.
 * As the instructor, I can check your submission status and manage the contract.
 */
contract SecretDepository {
    // --- Contract-Level Variables (State Variables) ---
    // These variables store important data for the entire contract.

    // The address of the instructor who deployed the contract. This is set automatically when the contract is created.
    address public owner;
    // This is the fee required for every submission. We've set it to 0.001 Ether.
    uint256 public constant DEPOSIT_FEE = 0.001 ether;
    // The minimum time you must wait between depositing and claiming.
    // For this assignment, it's set to 2 minutes (120 seconds) for convenience.
    uint256 public constant MIN_LOCK_DURATION = 2 minutes;

    // --- Data Structures (Structs) ---
    // We use a struct to group related information about each submission.

    struct Submission {
        string secretMessage;   // Your secret message for the assignment.
        address depositor;      // The Ethereum address you used to make the deposit.
        uint256 depositTime;    // The exact time (as a Unix timestamp) when you made the deposit.
        string studentId;       // Your official student ID.
        bool claimed;           // This starts as 'false' and becomes 'true' only after you successfully claim your submission.
    }

    // --- Data Lookups (Mappings) ---
    // Mappings are like dictionaries or hash maps. They help us find data quickly.

    // This is our main database. It links the unique hash of your password (the 'keyHash')
    // to all the details of your submission (the 'Submission' struct).
    // Note: It's 'private', so only the contract itself can directly access it.
    mapping(bytes32 => Submission) private submissions;

    // This mapping helps me, the instructor, find your submission using your student ID.
    // It maps your 'studentId' string to your unique 'keyHash'.
    mapping(string => bytes32) public studentIdToKeyHash;

    // This mapping helps YOU find your own submission using your Ethereum address.
    // It maps your address ('msg.sender') to your unique 'keyHash'.
    mapping(address => bytes32) public depositorToKeyHash;

    // --- Important Notifications (Events) ---
    // Events create logs on the blockchain. They are useful for tracking activity.

    // This event is emitted whenever a student successfully makes a deposit.
    event SubmissionDeposited(address indexed depositor, string indexed studentId, bytes32 indexed keyHash);
    // This event is emitted when a student successfully claims their submission.
    event SubmissionClaimed(address indexed retriever, string indexed studentId, bytes32 indexed keyHash);

    // --- Access Control (Modifiers) ---
    // Modifiers are reusable checks that we can add to functions.

    // This modifier ensures that only the contract owner (the instructor) can call a function.
    // If anyone else tries, the transaction will fail with the given error message.
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // --- Contract Functions ---
    // These are the actions that you and I can perform on the contract.

    // The constructor is a special function that runs only ONCE, when the contract is first deployed.
    // It sets the 'owner' to be the address that deployed the contract (that's me!).
    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice This is the function you'll call to submit your assignment.
     * @dev It takes your details, checks that everything is correct, and stores your submission on the blockchain.
     * @param keyHash The keccak256 hash of your secret password. Don't use the password itself!
     * @param secretMessage A secret message of your choice (e.g., your name or a fun fact).
     * @param studentId Your official student ID number.
     */
    function deposit(bytes32 keyHash, string calldata secretMessage, string calldata studentId) public payable {
        // These 'require' statements are like security guards. They check that all conditions are met
        // before allowing the function to proceed.
        require(msg.value == DEPOSIT_FEE, "Incorrect deposit fee sent");
        require(bytes(studentId).length > 0, "Student ID cannot be empty");
        require(submissions[keyHash].depositTime == 0, "This password has already been used");
        require(studentIdToKeyHash[studentId] == 0, "This student ID has already been submitted");
        require(depositorToKeyHash[msg.sender] == 0, "This address has already submitted");

        // All checks passed! Now, let's create a new 'Submission' record and store it in our 'submissions' mapping.
        submissions[keyHash] = Submission({
            secretMessage: secretMessage,
            depositor: msg.sender,
            depositTime: block.timestamp,
            studentId: studentId,
            claimed: false
        });

        // We also update our helper mappings so we can easily find this submission later
        // by either the student ID or the depositor's address.
        studentIdToKeyHash[studentId] = keyHash;
        depositorToKeyHash[msg.sender] = keyHash;

        // Finally, we emit an event to log that a new submission has been successfully deposited.
        emit SubmissionDeposited(msg.sender, studentId, keyHash);
    }

    /**
     * @notice This is Part 2 of the assignment! Call this function after the time lock has passed.
     * @dev This function will verify your password, check that you've waited long enough, mark your submission
     * as "complete", and finally return the secret message you originally deposited.
     * @param password Your original, plain-text password. The function will hash it to find your submission.
     * @return Your original secret message.
     */
    function claimAndRetrieve(string calldata password) public returns (string memory) {
        // First, we hash the password you provided to get the keyHash.
        bytes32 keyHash = keccak256(abi.encodePacked(password));
        // Then, we use that keyHash to find your submission in storage.
        Submission storage mySubmission = submissions[keyHash];

        // We run another set of checks to make sure everything is valid for a claim.
        require(mySubmission.depositTime > 0, "No submission found for this password");
        require(mySubmission.depositor == msg.sender, "You are not the owner of this submission");
        require(block.timestamp >= mySubmission.depositTime + MIN_LOCK_DURATION, "Time lock has not expired");
        require(!mySubmission.claimed, "Submission has already been claimed");

        // Success! Let's mark the submission as claimed.
        mySubmission.claimed = true;

        // We emit an event to log that the submission has been claimed.
        emit SubmissionClaimed(msg.sender, mySubmission.studentId, keyHash);

        // And return the secret message back to you.
        return mySubmission.secretMessage;
    }

    /**
     * @notice Use this helpful function to check the status of your own submission at any time.
     * @dev It uses your wallet address to look up your submission details.
     * @return depositor The wallet address you used to deposit.
     * @return depositTime The time you made the deposit. You can use this to see when the time lock expires.
     * @return studentId The student ID you submitted.
     * @return isClaimed The completion status ('true' if claimed, 'false' otherwise).
     */
    function checkMySubmissionStatus() public view returns (address depositor, uint256 depositTime, string memory studentId, bool isClaimed) {
        bytes32 keyHash = depositorToKeyHash[msg.sender];
        // If we can't find a submission for your address, we'll return empty/zero values.
        if (keyHash == 0) {
            return (address(0), 0, "", false);
        }
        Submission storage mySubmission = submissions[keyHash];
        return (mySubmission.depositor, mySubmission.depositTime, mySubmission.studentId, mySubmission.claimed);
    }

    /**
     * @notice This is an admin function for me to check on your submission.
     * @dev It's marked with 'onlyOwner', so only I can call it. I'll use your student ID to look you up.
     * @param studentId The ID of the student I want to check.
     * @return depositor The student's wallet address.
     * @return depositTime The timestamp of their deposit.
     * @return isClaimed Their completion status.
     */
    function getSubmissionStatus(string calldata studentId) public view onlyOwner returns (address depositor, uint256 depositTime, bool isClaimed) {
        bytes32 keyHash = studentIdToKeyHash[studentId];
        // If no submission is found for that student ID, return empty/zero values.
        if (keyHash == 0) {
            return (address(0), 0, false);
        }
        Submission storage studentSubmission = submissions[keyHash];
        return (studentSubmission.depositor, studentSubmission.depositTime, studentSubmission.claimed);
    }

    /**
     * @notice This is another admin function for the instructor.
     * @dev It allows me to withdraw the accumulated deposit fees from the contract.
     * You don't need to worry about this one!
     */
    function withdrawFees() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Failed to send Ether");
    }
}