pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/math/SafeMath.sol";

contract OmegaPiPredictionMarket is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for address;

    // Address of the Omega Pi Token contract
    address public omegaPiToken;

    // Mapping of market outcomes
    mapping (bytes32 => Outcome) public outcomes;

    // Mapping of user bets
    mapping (address => mapping (bytes32 => uint256)) public userBets;

    // Event for creating a new market
    event NewMarket(bytes32 indexed marketId, string description);

    // Event for placing a bet
    event PlaceBet(address indexed user, bytes32 indexed marketId, uint256 amount);

    // Event for resolving a market
    event ResolveMarket(bytes32 indexed marketId, uint256 winningOutcome);

    // Struct for market outcomes
    struct Outcome {
        uint256 amount;
        bool isWinning;
    }

    // Constructor
    constructor(address _omegaPiToken) public {
        omegaPiToken = _omegaPiToken;
    }

    // Function to create a new market
    function createMarket(string memory description) public {
        bytes32 marketId = keccak256(abi.encodePacked(description, block.timestamp));
        outcomes[marketId] = Outcome(0, false);
        emit NewMarket(marketId, description);
    }

    // Function to place a bet
    function placeBet(bytes32 marketId, uint256 amount) public {
        require(outcomes[marketId].amount.add(amount) <= IERC20(omegaPiToken).balanceOf(msg.sender), "Insufficient balance");
        userBets[msg.sender][marketId] = userBets[msg.sender][marketId].add(amount);
        outcomes[marketId].amount = outcomes[marketId].amount.add(amount);
        emit PlaceBet(msg.sender, marketId, amount);
    }

    // Function to resolve a market
    function resolveMarket(bytes32 marketId, uint256 winningOutcome) public {
        require(outcomes[marketId].isWinning == false, "Market has already been resolved");
        outcomes[marketId].isWinning = true;
        outcomes[marketId].amount = winningOutcome;
        emit ResolveMarket(marketId, winningOutcome);
    }
}
