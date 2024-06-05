pragma solidity ^0.8.0;

import "https://github.com/AGI-Labs/AGI-SDK/blob/master/contracts/AGI.sol";

contract ArtificialGeneralIntelligenceContract {
    using AGI for bytes;

    // Mapping of decision-making requests to their respective AGI outputs
    mapping (bytes32 => bytes) public agiOutputs;

    // Event emitted when a new decision-making request is made
    event NewDecisionRequest(bytes32 indexed requestId, bytes request);

    // Function to make a decision-making request
    function makeDecisionRequest(bytes memory request) public {
        bytes32 requestId = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        agiOutputs[requestId] = AGI.processRequest(request);
        emit NewDecisionRequest(requestId, request);
    }

    // Function to retrieve an AGI output
    function getAGIOutput(bytes32 requestId) public view returns (bytes memory) {
        require(agiOutputs[requestId].length > 0, "Request not found");
        return agiOutputs[requestId];
    }
}
