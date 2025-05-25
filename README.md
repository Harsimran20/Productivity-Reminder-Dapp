📅 ProductivityReminder Smart Contract ⏰
ProductivityReminder is a Solidity-based Ethereum smart contract designed to help users stay productive by creating task reminders backed by an Ether deposit. Users are incentivized to complete tasks on time — if completed, they reclaim their deposit; if not, the deposit is burned. 🔥

🚀 Features
📝 Create reminders with task description, deadline, and Ether deposit

✅ Mark tasks as completed before the deadline

💰 Claim your deposit back upon task completion

🔥 Burn deposits if tasks remain incomplete after deadline

⏲️ Check current blockchain time for UI/testing

⚙️ Contract Overview
Solidity version: ^0.8.20

Reminder struct stores user, task, deadline, deposit, status

Events emitted for tracking: creation, completion, claim, burn

Burn address for unclaimed deposits: 0x000...dEaD

🔧 Functions
createReminder(string calldata _task, uint256 _durationInSeconds) payable — create a new reminder with deposit

markCompleted(uint256 _id) — mark a task as done before deadline

claimDeposit(uint256 _id) — claim your Ether after completing the task

burnUnclaimed(uint256 _id) — burn deposit if deadline passed and task incomplete

currentTime() — get current blockchain timestamp

📢 Events
ReminderCreated

ReminderCompleted

RewardClaimed

DepositBurned

⚠️ Notes
Only the task creator can complete or claim

Deposits locked until completion or deadline

Burning is irreversible — Ether is sent to a dead address

📄 License
MIT License
