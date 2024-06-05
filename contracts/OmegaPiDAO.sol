pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/math/SafeMath.sol";

contract OmegaPiDAO is Ownable {
    using SafeMath for uint256;

    // Mapping of user votes
    mapping (address => uint256) public votes;

    // Mapping of proposal votes
    mapping (uint256 => mapping (address => uint256)) public proposalVotes;

    // Event for creating a new proposal
    event NewProposal(uint256 indexed proposalId, string description);

    // Event for casting a vote
    event CastVote(address indexed user, uint256 indexed proposalId, uint256 voteAmount);

    // Function to create a new proposal
    function createProposal(string memory description) public {
        uint256 proposalId = uint256(keccak256(abi.encodePacked(description, block.timestamp)));
        emit NewProposal(proposalId, description);
    }

    // Function to cast a vote
    function castVote(uint256 proposalId, uint256 voteAmount) public {
        require(votes[msg.sender] >= voteAmount, "Insufficient votes");
        votes[msg.sender] = votes[msg.sender].sub(voteAmount);
        proposalVotes[proposalId][msg.sender] = proposalVotes[proposalId][msg.sender].add(voteAmount);
        emit CastVote(msg.sender, proposalId, voteAmount);
    }
}
