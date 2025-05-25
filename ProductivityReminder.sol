// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProductivityReminder {
    struct Reminder {
        address user;
        string task;
        uint256 deadline;
        uint256 deposit;
        bool completed;
        bool claimed;
    }

    uint256 public reminderCount;
    mapping(uint256 => Reminder) public reminders;

    address public burnAddress = 0x000000000000000000000000000000000000dEaD;

    event ReminderCreated(uint256 id, address indexed user, string task, uint256 deadline, uint256 deposit);
    event ReminderCompleted(uint256 id, address indexed user);
    event RewardClaimed(uint256 id, address indexed user);
    event DepositBurned(uint256 id);

    function createReminder(string calldata _task, uint256 _durationInSeconds) external payable {
        require(msg.value > 0, "Must deposit some ether as a commitment");
        require(_durationInSeconds > 0, "Deadline must be in the future");

        uint256 id = reminderCount++;
        reminders[id] = Reminder({
            user: msg.sender,
            task: _task,
            deadline: block.timestamp + _durationInSeconds,
            deposit: msg.value,
            completed: false,
            claimed: false
        });

        emit ReminderCreated(id, msg.sender, _task, block.timestamp + _durationInSeconds, msg.value);
    }

    function markCompleted(uint256 _id) external {
        Reminder storage r = reminders[_id];
        require(msg.sender == r.user, "Only creator can mark as complete");
        require(!r.completed, "Already completed");
        require(block.timestamp <= r.deadline, "Deadline passed");

        r.completed = true;
        emit ReminderCompleted(_id, msg.sender);
    }

    function claimDeposit(uint256 _id) external {
        Reminder storage r = reminders[_id];
        require(msg.sender == r.user, "Only creator can claim");
        require(r.completed, "Task not completed");
        require(!r.claimed, "Already claimed");

        r.claimed = true;
        payable(msg.sender).transfer(r.deposit);

        emit RewardClaimed(_id, msg.sender);
    }

    function burnUnclaimed(uint256 _id) external {
        Reminder storage r = reminders[_id];
        require(block.timestamp > r.deadline, "Deadline not passed");
        require(!r.completed || r.claimed == false, "No need to burn");
        require(r.deposit > 0, "Already processed");

        uint256 amount = r.deposit;
        r.deposit = 0;
        payable(burnAddress).transfer(amount);

        emit DepositBurned(_id);
    }

    // Helper: Check current timestamp for UI/testing
    function currentTime() external view returns (uint256) {
        return block.timestamp;
    }
}
