pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol";
import "https://github.com/chainlink/chainlink-brownie-contracts/blob/master/contracts/src/v0.8/ChainlinkClient.sol";

contract OmegaPiAIOracle is Ownable, ReentrancyGuard, ChainlinkClient {
    // Mapping of AI model IDs to their corresponding models
    mapping(uint256 => AIModel) public aiModels;

    // Mapping of data request IDs to their corresponding requests
    mapping(uint256 => DataRequest) public dataRequests;

    // Event emitted when a new AI model is registered
    event NewAIModel(uint256 indexed modelId, string modelName, string modelDescription);

    // Event emitted when a data request is made
    event DataRequestMade(uint256 indexed requestId, uint256 indexed modelId, string dataDescription);

    // Event emitted when data is received from the AI model
    event DataReceived(uint256 indexed requestId, uint256 indexed modelId, string data);

    // Struct to represent an AI model
    struct AIModel {
        string modelName;
        string modelDescription;
        address modelAddress;
    }

    // Struct to represent a data request
    struct DataRequest {
        uint256 modelId;
        string dataDescription;
        bytes data;
    }

    /**
     * @dev Registers a new AI model with the given name and description.
     * @param _modelName The name of the AI model.
     * @param _modelDescription The description of the AI model.
     * @param _modelAddress The address of the AI model.
     */
    function registerAIModel(string memory _modelName, string memory _modelDescription, address _modelAddress) public onlyOwner {
        uint256 newModelId = aiModels.length;
        aiModels[newModelId] = AIModel(_modelName, _modelDescription, _modelAddress);
        emit NewAIModel(newModelId, _modelName, _modelDescription);
    }

    /**
     * @dev Makes a data request to an AI model.
     * @param _modelId The ID of the AI model to request data from.
     * @param _dataDescription The description of the data to request.
     */
    function requestData(uint256 _modelId, string memory _dataDescription) public {
        require(aiModels[_modelId].modelAddress!= address(0), "AI model not registered");

        uint256 newRequestId = dataRequests.length;
        dataRequests[newRequestId] = DataRequest(_modelId, _dataDescription, "");
        emit DataRequestMade(newRequestId, _modelId, _dataDescription);

        // Use Chainlink to make an external API call to the AI model
        Chainlink.Request memory req = buildChainlinkRequest(stringToBytes32("get_data"), address(this), this.fulfillDataRequest.selector);
        req.addUint256("modelId", _modelId);
        req.addString("dataDescription", _dataDescription);
        sendChainlinkRequestTo(oracle, req, fee);
    }

    /**
     * @dev Fulfills a data request with the received data.
     * @param _requestId The ID of the data request.
     * @param _data The received data.
     */
    function fulfillDataRequest(bytes32 _requestId, bytes memory _data) public recordChainlinkFulfillment(_requestId) {
        uint256 requestId = uint256(_requestId);
        require(dataRequests[requestId].data.length == 0, "Data request already fulfilled");

        dataRequests[requestId].data = _data;
        emit DataReceived(requestId, dataRequests[requestId].modelId, string(_data));
    }
}
