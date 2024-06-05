pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/math/SafeMath.sol";

contract OmegaPiDEX is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for address;

    // Mapping of user orders
    mapping (address => mapping (uint256 => Order)) public orders;

    // Event for creating a new order
    event NewOrder(address indexed user, uint256 indexed orderId, uint256 tokenAmount, uint256 etherAmount);

    // Event for filling an order
    event FillOrder(address indexed user, uint256 indexed orderId, uint256 tokenAmount, uint256 etherAmount);

    // Struct for orders
    struct Order {
        uint256 tokenAmount;
        uint256 etherAmount;
        bool isFilled;
    }

    // Function to create a new order
    function createOrder(uint256 tokenAmount, uint256 etherAmount) public {
        uint256 orderId = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));
        orders[msg.sender][orderId] = Order(tokenAmount, etherAmount, false);
        emit NewOrder(msg.sender, orderId, tokenAmount, etherAmount);
}

    // Function to fill an order
    function fillOrder(uint256 orderId, uint256 tokenAmount, uint256 etherAmount) public {
        require(orders[msg.sender][orderId].isFilled == false, "Order already filled");
        require(orders[msg.sender][orderId].tokenAmount == tokenAmount, "Invalid token amount");
        require(orders[msg.sender][orderId].etherAmount == etherAmount, "Invalid ether amount");
        orders[msg.sender][orderId].isFilled = true;
        emit FillOrder(msg.sender, orderId, tokenAmount, etherAmount);
    }
}
