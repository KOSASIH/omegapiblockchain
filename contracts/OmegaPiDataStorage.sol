pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/math/SafeMath.sol";

contract OmegaPiDataStorage is Ownable {
    using SafeMath for uint256;

    // Mapping of encrypted data
    mapping (address => mapping (bytes32 => bytes)) public encryptedData;

    // Event for storing encrypted data
    event StoreData(address indexed user, bytes32 indexed dataId, bytes encryptedData);

    // Function to store encrypted data
    function storeData(bytes32 dataId, bytes encryptedData) public {
        encryptedData[msg.sender][dataId] = encryptedData;
        emit StoreData(msg.sender, dataId, encryptedData);
    }

    // Function to retrieve encrypted data
    function retrieveData(bytes32 dataId) public view returns (bytes memory) {
        return encryptedData[msg.sender][dataId];
    }
}
