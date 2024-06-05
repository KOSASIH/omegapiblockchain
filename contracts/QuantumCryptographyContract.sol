pragma solidity ^0.8.0;

import "https://github.com/NTRU/NTRU-Crypto/blob/master/contracts/NTRUCrypto.sol";

contract QuantumCryptographyContract {
    using NTRUCrypto for bytes;

    // Mapping of encrypted messages to their respective decryption keys
    mapping (bytes32 => bytes) public encryptedMessages;

    // Event emitted when a new encrypted message is stored
    event NewEncryptedMessage(bytes32 indexed messageId, bytes encryptedMessage);

    // Function to encrypt a message using NTRU cryptography
    function encryptMessage(bytes memory message) public {
        bytes memory encryptedMessage = NTRUCrypto.encrypt(message);
        bytes32 messageId = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        encryptedMessages[messageId] = encryptedMessage;
        emit NewEncryptedMessage(messageId, encryptedMessage);
    }

    // Function to decrypt a message using NTRU cryptography
    function decryptMessage(bytes32 messageId) public view returns (bytes memory) {
        require(encryptedMessages[messageId].length > 0, "Message not found");
        return NTRUCrypto.decrypt(encryptedMessages[messageId]);
    }
}
