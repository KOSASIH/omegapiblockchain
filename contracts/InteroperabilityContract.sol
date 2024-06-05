pragma solidity ^0.8.0;

import "https://github.com/ChainSafe/cross-chain-bridge/blob/master/contracts/interfaces/IERC20Handler.sol";
import "https://github.com/ChainSafe/cross-chain-bridge/blob/master/contracts/interfaces/IERC20Bridge.sol";

contract InteroperabilityContract {
    // Mapping of token addresses to their respective bridge contracts
    mapping (address => address) public tokenBridges;

    // Event emitted when a new token bridge is registered
    event NewTokenBridge(address indexed token, address bridge);

    // Function to register a new token bridge
    function registerTokenBridge(address token, address bridge) public {
        require(tokenBridges[token] == address(0), "Token bridge already registered");
        tokenBridges[token] = bridge;
        emit NewTokenBridge(token, bridge);
    }

    // Function to transfer tokens across chains
    function transferTokens(address token, uint256 amount, bytes memory data) public {
        IERC20Bridge(tokenBridges[token]).transfer(token, amount, data);
    }

    // Function to handle incoming token transfers
    function handleIncomingTransfer(address token, uint256 amount, bytes memory data) public {
        IERC20Handler(msg.sender).handleIncomingTransfer(token, amount, data);
    }
}
