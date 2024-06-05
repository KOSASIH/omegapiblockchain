pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/governance/Governor.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/governance/extensions/GovernorTimelockControl.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/governance/extensions/GovernorVotes.sol";

contract OmegaPiGovernance is Ownable, Governor, GovernorTimelockControl, GovernorVotes {
    // Mapping of proposal IDs to their corresponding proposals
    mapping(uint256 => Proposal) public proposals;

    // Mapping of proposal IDs to their corresponding votes
    mapping(uint256 => mapping(address => uint256)) public votes;

    // Event emitted when a new proposal is created
    event NewProposal(uint256 indexed proposalId, address indexed proposer, string description);

    // Event emitted when a proposal is voted on
    event VoteCast(uint256 indexed proposalId, address indexed voter, uint256 vote);

    // Event emitted when a proposal is executed
    event ProposalExecuted(uint256 indexed proposalId);

    // Struct to represent a proposal
    struct Proposal {
        string description;
        uint256 startTime;
        uint256 endTime;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    /**
     * @dev Creates a new proposal with the given description.
     * @param _description The description of the proposal.
     */
    function createProposal(string memory _description) public onlyOwner {
        uint256 newProposalId = proposals.length;
        proposals[newProposalId] = Proposal(_description, block.timestamp, block.timestamp + 30 days, 0, 0, false);
        emit NewProposal(newProposalId, msg.sender, _description);
    }

    /**
     * @dev Votes on a proposal.
     * @param _proposalId The ID of the proposal to vote on.
     * @param _vote The vote (0 = against, 1 = for).
     */
    function vote(uint256 _proposalId, uint256 _vote) public {
        require(proposals[_proposalId].startTime <= block.timestamp && block.timestamp <= proposals[_proposalId].endTime, "Voting period has not started or has ended");
        require(votes[_proposalId][msg.sender] == 0, "You have already voted on this proposal");

        if (_vote == 0) {
            proposals[_proposalId].votesAgainst++;
        } else {
            proposals[_proposalId].votesFor++;
        }

        votes[_proposalId][msg.sender] = _vote;
        emit VoteCast(_proposalId, msg.sender, _vote);
    }

    /**
     * @dev Executes a proposal if it has been approved.
     * @param _proposalId The ID of the proposal to execute.
     */
    function executeProposal(uint256 _proposalId) public onlyOwner {
        require(proposals[_proposalId].endTime <= block.timestamp, "Voting period has not ended");
        require(proposals[_proposalId].votesFor > proposals[_proposalId].votesAgainst, "Proposal has not been approved");

        proposals[_proposalId].executed = true;
        emit ProposalExecuted(_proposalId);
    }
}
