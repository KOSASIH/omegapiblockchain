pragma solidity ^0.8.0;

import "https://github.com/HomomorphicEncryption/HElib/blob/master/contracts/HElib.sol";

contract HomomorphicEncryptionContract {
    using HElib for bytes;

    // Mapping of encrypted data to their respective decryption keys
    mapping (bytes32 => bytes) public encryptedData;

    // Event emitted when a new encrypted data is stored
    event NewEncryptedData(bytes32 indexed dataId, bytes encryptedData);

    // Function to encrypt data using homomorphic encryption
    function encryptData(bytes memory data) public {
        bytes memory encryptedData = HElib.encrypt(data);
        bytes32 dataId = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        encryptedData[dataId] = encryptedData;
        emit NewEncryptedData(dataId, encryptedData);
    }

    // Function to perform secure computation on encrypted data
    function computeOnEncryptedData(bytes32 dataId, bytes memory computation) public view returns (bytes memory) {
        require(encryptedData[dataId].length > 0, "Data not found");
        return HElib.computeOnEncryptedData(encryptedData[dataId], computation);
    }

    // Function to decrypt data using homomorphic encryption
    function decryptData(bytes32 dataId) public view returns (bytes memory) {
        require(encryptedData[dataId].length > 0, "Data not found");
        return HElib.decrypt(encryptedData[dataId]);
    }
}
