pragma solidity ^0.8.0;

import "https://github.com/smartcontractkit/chainlink/blob/master/evm-contracts/src/v0.8/ChainlinkClient.sol";

contract OracleContract {
    using ChainlinkClient for Chainlink.Request;

    // Mapping of data requests to their respective responses
    mapping (bytes32 => uint256) public dataResponses;

    // Event emitted when a new data request is made
    event NewDataRequest(bytes32 requestId, string description);

    // Event emitted when a data response is received
    event DataResponseReceived(bytes32 requestId, uint256 response);

    // Function to request real-world data
    function requestData(string memory description) public {
        bytes32 requestId = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        Chainlink.Request memory req = buildChainlinkRequest(stringToBytes32("get", description), this, this.fulfill);
        req.add("get", "https://api.example.com/data");
        sendChainlinkRequestTo(oracleAddress, req, oracleFee);
        emit NewDataRequest(requestId, description);
    }

    // Function to fulfill a data request
    function fulfill(bytes32 requestId, uint256 response) public {
        dataResponses[requestId] = response;
        emit DataResponseReceived(requestId, response);
    }
}
