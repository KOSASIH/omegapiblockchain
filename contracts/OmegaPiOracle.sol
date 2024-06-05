pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol";

contract OmegaPiOracle is Ownable, ReentrancyGuard {
    // Mapping of data providers
    mapping (address => bool) public dataProviders;

    // Mapping of data requests
    mapping (bytes32 => DataRequest) public dataRequests;

    // Event for new data requests
    event NewDataRequest(bytes32 requestId, address requester, bytes data);

    // Event for data updates
    event DataUpdate(bytes32 requestId, bytes data);

    // Struct for data requests
    struct DataRequest {
        address requester;
        bytes data;
        uint256 timestamp;
    }

    // Function to register as a data provider
    function registerAsDataProvider() public {
        dataProviders[msg.sender] = true;
    }

    // Function to request data
    function requestData(bytes data) public {
        bytes32 requestId = keccak256(abi.encodePacked(data, block.timestamp));
        dataRequests[requestId] = DataRequest(msg.sender, data, block.timestamp);
        emit NewDataRequest(requestId, msg.sender, data);
    }

    // Function to update data
    function updateData(bytes32 requestId, bytes data) public {
        require(dataProviders[msg.sender], "Only data providers can update data");
        require(dataRequests[requestId].requester!= address(0), "Invalid request ID");
        dataRequests[requestId].data = data;
        emit DataUpdate(requestId, data);
    }
}
