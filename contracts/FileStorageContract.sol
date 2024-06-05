pragma solidity ^0.8.0;

import "https://github.com/ethereum/solidity-utils/blob/master/lib/FileStorage.sol";

contract DecentralizedFileStorage {
    using FileStorage for bytes;

    // Mapping of file hashes to their respective owners
    mapping (bytes32 => address) public fileOwners;

    // Event emitted when a new fileis uploaded
    event NewFile(address indexed owner, bytes32 fileHash);

    // Function to upload a new file
    function uploadFile(bytes memory file) public {
        bytes32 fileHash = keccak256(file);
        require(fileOwners[fileHash] == address(0), "File already uploaded");
        fileOwners[fileHash] = msg.sender;
        emit NewFile(msg.sender, fileHash);
    }

    // Function to retrieve a file
    function retrieveFile(bytes32 fileHash) public view returns (bytes memory) {
        require(fileOwners[fileHash]!= address(0), "File not found");
        return FileStorage.getFile(fileHash);
    }
}
