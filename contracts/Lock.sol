// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Lock {
    address public owner;
    mapping(string => bool) public stringExists;
    string[] public stringList;
    uint public unlockTime; 

    event StringAdded(string value);
    event StringRemoved(string value);

    constructor(uint _unlockTime, uint _lockedAmount) payable {
        require(
        block.timestamp < _unlockTime,
        "Unlock time should be in the future"
    );
        owner = msg.sender;
        unlockTime = _unlockTime;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Biometric Data");
        _;
    }

    function addString(string memory value) public onlyOwner {
        require(!stringExists[value], "String already exists in the collection");
        stringList.push(value);
        stringExists[value] = true;
        emit StringAdded(value);
    }

    function removeString(string memory value) public onlyOwner {
        require(stringExists[value], "String does not exist in the collection");

        // Find and remove the string from the array
        for (uint i = 0; i < stringList.length; i++) {
            if (keccak256(abi.encodePacked(stringList[i])) == keccak256(abi.encodePacked(value))) {
                stringList[i] = stringList[stringList.length - 1];
                stringList.pop();
                break;
            }
        }

        stringExists[value] = false;
        emit StringRemoved(value);
    }

    function checkString(string memory value) public view returns (bool) {
        return stringExists[value];
    }

    function getStringList() public view returns (string[] memory) {
        return stringList;
    }
}
