pragma solidity ^0.8.0;

import "https://github.com/Zokrates/Zokrates/blob/master/contracts/Zokrates.sol";

contract ZeroKnowledgeProofContract {
    using Zokrates for bytes;

    // Mapping of private data to their respective zero-knowledge proofs
    mapping (bytes32 => bytes) public zkProofs;

    // Event emitted when a new zero-knowledge proof is generated
    event NewZKProof(bytes32 indexed dataId, bytes zkProof);

    // Function to generate a zero-knowledge proof for private data
    function generateZKProof(bytes memory data) public {
        bytes32 dataId = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        bytes memory zkProof = Zokrates.generateProof(data);
        zkProofs[dataId] = zkProof;
        emit NewZKProof(dataId, zkProof);
    }

    // Function to verify a zero-knowledge proof
    function verifyZKProof(bytes32 dataId, bytes memory zkProof) public view returns (bool) {
        require(zkProofs[dataId].length > 0, "Proof not found");
        return Zokrates.verifyProof(zkProofs[dataId], zkProof);
    }
}
