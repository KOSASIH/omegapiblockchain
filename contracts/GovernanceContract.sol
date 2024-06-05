pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Roles.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

contract GovernanceContract {
    using Roles for address;
    using SafeERC20 for address;

    // Mapping of proposals to their respective votes
    mapping (address => mapping (uint256 => uint256)) public proposalVotes;

    // Event emitted when a new proposal is created
    event NewProposal(address indexed proposer, uint256 proposalId, string description);

    // Event emitted when a proposal is voted on
    event VoteCast(address indexed voter, uint256 proposalId, uint256 vote);

    // Event emitted when a proposal is executed
    event ProposalExecuted(uint256 proposalId, string description);

    // Modifier to restrict access to only authorized addresses
    modifier onlyAuthorized {
        require(msg.sender.hasRole("AUTHORIZED"), "Only authorized addresses can call this function");
        _;
    }

    // Function to create a new proposal
    function createProposal(string memory description) public onlyAuthorized {
        uint256 proposalId = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        proposalVotes[msg.sender][proposalId] = 1;
        emit NewProposal(msg.sender, proposalId, description);
    }

    // Function to vote on a proposal
    function voteOnProposal(uint256 proposalId, uint256 vote) public {
        require(proposalVotes[msg.sender][proposalId] == 0, "You have already voted on this proposal");
        proposalVotes[msg.sender][proposalId] = vote;
        emit VoteCast(msg.sender, proposalId, vote);
    }

    // Function to execute a proposal
    function executeProposal(uint256 proposalId) public onlyAuthorized {
        uint256 totalVotes = 0;
        uint256 yesVotes = 0;
        for (address voter in proposalVotes) {
            totalVotes += proposalVotes[voter][proposalId];
            if (proposalVotes[voter][proposalId] == 1) {
                yesVotes += 1;
            }
        }
        require(yesVotes > totalVotes / 2, "Proposal did not reach majority vote");
        // Execute the proposal logic here
        emit ProposalExecuted(proposalId, "Proposal executed successfully");
    }
}
