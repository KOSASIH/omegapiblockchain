pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

contract OmegaPiToken {
    using SafeERC20 for address;

    // Mapping of user balances
    mapping (address => uint256) public balances;

    // Mapping of user allowances
    mapping (address => mapping (address => uint256)) public allowances;

    // Total supply of Omega Pi tokens
    uint256 public totalSupply;

    // Event emitted when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Event emitted when an approval is made
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Constructor function
    constructor() public {
        totalSupply = 1000000000 * (10 ** 18); // 1 billion Omega Pi tokens
        balances[msg.sender] = totalSupply;
    }

    // Function to transfer tokens
    function transfer(address to, uint256 value) public returns (bool) {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    // Function to approve token spending
    function approve(address spender, uint256 value) public returns (bool) {
        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    // Function to transfer tokens from one address to another
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(allowances[from][msg.sender] >= value, "Insufficient allowance");
        require(balances[from] >= value, "Insufficient balance");
        balances[from] -= value;
        balances[to] += value;
        allowances[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
}
