pragma solidity ^0.8.0;

import "https://github.com/SwarmIntelligence/SwarmIntelligence/blob/master/contracts/SwarmIntelligence.sol";

contract SwarmIntelligenceContract {
    using SwarmIntelligence for bytes;

    // Mapping of distributed consensus requests to their respective outcomes
    mapping (bytes32 => bytes) public consensusOutcomes;

    // Event emitted when a new distributed consensus request is made
    event NewConsensusRequest(bytes32 indexed requestId, bytes request);

    // Function to make a distributed consensus request
    function makeConsensusRequest(bytes memory request) public {
        bytes32 requestId = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        bytes memory consensusOutcome = SwarmIntelligence.consensus(request);
        consensusOutcomes[requestId] = consensusOutcome;
        emit NewConsensusRequest(requestId, request);
    }

    // Function to retrieve a consensus outcome
    function getConsensusOutcome(bytes32 requestId) public view returns (bytes memory) {
        require(consensusOutcomes[requestId].length > 0, "Request not found");
        return consensusOutcomes[requestId];
    }
}
