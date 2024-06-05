pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol";
import "https://github.com/chainlink/chainlink-brownie-contracts/blob/master/contracts/src/v0.8/ChainlinkClient.sol";
import "https://github.com/neural-network-contracts/neural-network-contracts/blob/master/contracts/NeuralNetwork.sol";

contract OmegaPiNeuralNetwork is Ownable, ReentrancyGuard, ChainlinkClient, NeuralNetwork {
    // Mapping of neural network model IDs to their corresponding models
    mapping(uint256 => NeuralNetworkModel) public neuralNetworkModels;

    // Mapping of data request IDs to their corresponding requests
    mapping(uint256 => DataRequest) public dataRequests;

    // Event emitted when a new neural network model is registered
    event NewNeuralNetworkModel(uint256 indexed modelId, string modelName, string modelDescription);

    // Event emitted when a data request is made
    event DataRequestMade(uint256 indexed requestId, uint256 indexed modelId, string dataDescription);

    // Event emitted when data is received from the neural network model
    event DataReceived(uint256 indexed requestId, uint256 indexed modelId, string data);

    // Struct to represent a neural network model
    struct NeuralNetworkModel {
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
     * @dev Registers a new neural network model with the given name and description.
     * @param _modelName The name of the neural network model.
     * @param _modelDescription The description of the neural network model.
     * @param _modelAddress The address of the neural network model.
     */
    function registerNeuralNetworkModel(string memory _modelName, string memory _modelDescription, address _modelAddress) public onlyOwner {
        uint256 newModelId = neuralNetworkModels.length;
        neuralNetworkModels[newModelId] = NeuralNetworkModel(_modelName, _modelDescription, _modelAddress);
        emit NewNeuralNetworkModel(newModelId, _modelName, _modelDescription);
    }

    /**
     * @dev Makes a data request to a neural network model.
     * @param _modelId The ID of the neural network model to request data from.
     * @param _dataDescription The description of the data to request.
     */
    function requestData(uint256 _modelId, string memory _dataDescription) public {
        require(neuralNetworkModels[_modelId].modelAddress!= address(0), "Neural network model not registered");

        uint256 newRequestId = dataRequests.length;
        dataRequests[newRequestId] = DataRequest(_modelId, _dataDescription, "");
        emit DataRequestMade(newRequestId, _modelId, _dataDescription);

        // Use Chainlink to make an external API call to the neural network model
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
