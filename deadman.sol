// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmansSwitch {
    address public owner;
    uint256 public deadline;
    bool public switchTriggered;

    event SwitchTriggered(address indexed owner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier notTriggered() {
        require(!switchTriggered, "Switch already triggered");
        _;
    }

    modifier deadlineNotPassed() {
        require(block.timestamp <= deadline, "Deadline has passed");
        _;
    }

    constructor(uint256 _durationInMinutes) {
        owner = msg.sender;
        deadline = block.timestamp + _durationInMinutes * 1 minutes;
        switchTriggered = false;
    }
    function checkIn() external onlyOwner notTriggered deadlineNotPassed {
        deadline = block.timestamp + 1 minutes; // Extend the deadline by 1 minute upon check-in
    }
    function triggerSwitch() external onlyOwner notTriggered deadlineNotPassed {
        switchTriggered = true;
        emit SwitchTriggered(owner);
    }
    function isSwitchTriggered() external view returns (bool) {
        return switchTriggered;
    }
    function getDeadline() external view returns (uint256) {
        return deadline;
    }
}
