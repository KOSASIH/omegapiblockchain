pragma solidity ^0.8.0;

import "https://github.com/Quantum-MPC/Quantum-MPC/blob/master/contracts/QuantumMPC.sol";

contract QuantumSecureMultiPartyComputation {
    using QuantumMPC for bytes;

    // Mapping of multi-party computation requests to their respective outputs
    mapping (bytes32 => bytes) public qmpcOutputs;

    // Event emitted when a new multi-party computation request is made
    event NewQMPCRequest(bytes32 indexed requestId, bytes request);

    // Function to make a multi-party computation request
    function makeQMPCRequest(bytes memory request) public {
        bytes32 requestId = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        qmpcOutputs[requestId] = QuantumMPC.compute(request);
        emit NewQMPCRequest(requestId, request);
    }

    // Function to retrieve a QMPC output
    function getQMPCOutput(bytes32 requestId) public view returns (bytes memory) {
        require(qmpcOutputs[requestId].length > 0, "Request not found");
        return qmpcOutputs[requestId];
    }
}
