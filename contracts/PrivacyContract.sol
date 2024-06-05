pragma solidity ^0.8.0;

import "https://github.com/iden3/circomlib/blob/master/src/poseidon.sol";
import "https://github.com/iden3/circomlib/blob/master/src/merkle_proof.sol";

contract PrivacyContract {
    using Poseidon for bytes32[2];
    using MerkleProof for bytes32[2][];

    // Merkle tree root
    bytes32 public root;

    // Function to generate a Merkle proof for a given leaf
    function generateMerkleProof(bytes32 leaf, bytes32[2][] memory tree) public pure returns (bytes32[2][] memory proof) {
        return MerkleProof.generateProof(leaf, tree);
    }

    // Function to verify a Merkle proof
    function verifyMerkleProof(bytes32[2][] memory proof, bytes32 leaf, bytes32 root_) public pure returns (bool) {
        return MerkleProof.verifyProof(proof, leaf, root_);
    }

    // Function to compute a Poseidon hash
    function poseidonHash(bytes32[2] memory input) public pure returns (bytes32) {
        return Poseidon.hash(input);
    }
}
