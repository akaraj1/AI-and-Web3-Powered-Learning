// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EducationPlatform {

    // Token information
    string public name = "EduToken";
    string public symbol = "EDU";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 * 10 ** uint256(decimals);

    // Balances mapping
    mapping(address => uint256) public balances;
    
    // Student structure
    struct Student {
        string name;
        string[] credentials;
        uint256 rewardBalance;
    }
    
    // Mapping from student address to their profile
    mapping(address => Student) public students;

    // Event to emit when a new student is registered
    event StudentRegistered(address studentAddress, string name);

    // Event to emit when a new credential is issued
    event CredentialIssued(address studentAddress, string credential);

    // Event to emit when tokens are rewarded
    event TokensRewarded(address studentAddress, uint256 amount);

    // Constructor to set initial balances
    constructor() {
        balances[msg.sender] = totalSupply;
    }

    // Modifier to check if a student exists
    modifier studentExists(address studentAddress) {
        require(bytes(students[studentAddress].name).length != 0, "Student does not exist.");
        _;
    }

    // Function to register a new student
    function registerStudent(address studentAddress, string memory studentName) public {
        require(bytes(students[studentAddress].name).length == 0, "Student already registered.");
        students[studentAddress] = Student(studentName, new string[](0), 0);
        emit StudentRegistered(studentAddress, studentName);
    }

    // Function to issue a credential to a student
    function issueCredential(address studentAddress, string memory credential) public studentExists(studentAddress) {
        students[studentAddress].credentials.push(credential);
        emit CredentialIssued(studentAddress, credential);
    }

    // Function to reward tokens to a student
    function rewardTokens(address studentAddress, uint256 amount) public studentExists(studentAddress) {
        require(balances[msg.sender] >= amount, "Insufficient token balance to reward.");
        balances[msg.sender] -= amount;
        students[studentAddress].rewardBalance += amount;
        balances[studentAddress] += amount;
        emit TokensRewarded(studentAddress, amount);
    }

    // Function to check a student's credentials
    function getStudentCredentials(address studentAddress) public view returns (string[] memory) {
        return students[studentAddress].credentials;
    }

    // Function to check a student's reward balance
    function getRewardBalance(address studentAddress) public view returns (uint256) {
        return students[studentAddress].rewardBalance;
    }
}