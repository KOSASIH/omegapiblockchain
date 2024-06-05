pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/math/SafeMath.sol";

contract OmegaPiStaking is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for address;

    // Address of the Omega Pi Token contract
    address public omegaPiToken;

    // Mapping of staked token amounts
    mapping (address => uint256) public stakedAmounts;

    // Mapping of last update times
    mapping (address => uint256) public lastUpdateTimes;

    // Mapping of rewards per token
    mapping (address => uint256) public rewardsPerToken;

    // Total supply of staked tokens
    uint256 public totalStaked;

    // Reward rate per second
    uint256 public rewardRate;

    // Event for staking tokens
    event Stake(address indexed staker, uint256 amount);

    // Event for unstaking tokens
    event Unstake(address indexed staker, uint256 amount);

    // Event for claiming rewards
    event ClaimReward(address indexed staker, uint256 reward);

    // Constructor
    constructor(address _omegaPiToken, uint256 _rewardRate) public {
        omegaPiToken = _omegaPiToken;
        rewardRate = _rewardRate;
    }

    // Function to stake tokens
    function stake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(IERC20(omegaPiToken).transferFrom(msg.sender, address(this), amount), "Transfer failed");
        stakedAmounts[msg.sender] = stakedAmounts[msg.sender].add(amount);
        totalStaked = totalStaked.add(amount);
        lastUpdateTimes[msg.sender] = block.timestamp;
        emit Stake(msg.sender, amount);
    }

    // Function to unstake tokens
    function unstake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(stakedAmounts[msg.sender] >= amount, "Insufficient staked tokens");
        stakedAmounts[msg.sender] = stakedAmounts[msg.sender].sub(amount);
        totalStaked = totalStaked.sub(amount);
        IERC20(omegaPiToken).transfer(msg.sender, amount);
        emit Unstake(msg.sender, amount);
    }

    // Function to claim rewards
    function claimReward() public {
        uint256 reward = calculateReward(msg.sender);
        if (reward > 0) {
            IERC20(omegaPiToken).transfer(msg.sender, reward);
            rewardsPerToken[msg.sender] = 0;
            lastUpdateTimes[msg.sender] = block.timestamp;
            emit ClaimReward(msg.sender, reward);
        }
    }

    // Function to calculate rewards
    function calculateReward(address staker) public view returns (uint256) {
        if (stakedAmounts[staker] == 0) {
            return 0;
        }
        uint256 timeSinceLastUpdate = block.timestamp.sub(lastUpdateTimes[staker]);
        uint256 stakerRewardPerToken = rewardsPerToken[staker].add(timeSinceLastUpdate.mul(rewardRate).div(totalStaked));
        return stakerRewardPerToken.mul(stakedAmounts[staker]).div(1e18);
    }
}
