pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/math/SafeMath.sol";

contract OmegaPiDeFiLending is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for address;

    // Mapping of user deposits
    mapping (address => uint256) public deposits;

    // Mapping of loan requests
    mapping (address => LoanRequest) public loanRequests;

    // Event for depositing funds
    event Deposit(address indexed user, uint256 amount);

    // Event for requesting a loan
    event RequestLoan(address indexed user, uint256 amount);

    // Event for lending funds
    event Lend(address indexed lender, address indexed borrower, uint256 amount);

    // Struct for loan requests
    struct LoanRequest {
        uint256 amount;
        uint256 interestRate;
        uint256 repaymentPeriod;
    }

    // Function to deposit funds
    function deposit(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        deposits[msg.sender] = deposits[msg.sender].add(amount);
        emit Deposit(msg.sender, amount);
    }

    // Function to request a loan
    function requestLoan(uint256 amount, uint256 interestRate, uint256 repaymentPeriod) public {
        require(amount > 0, "Amount must be greater than 0");
        loanRequests[msg.sender] = LoanRequest(amount, interestRate, repaymentPeriod);
        emit RequestLoan(msg.sender, amount);
    }

    // Function to lend funds
    function lend(address borrower, uint256 amount) public {
        require(deposits[msg.sender] >= amount, "Insufficient funds");
        deposits[msg.sender] = deposits[msg.sender].sub(amount);
        loanRequests[borrower].amount = loanRequests[borrower].amount.sub(amount);
        emit Lend(msg.sender, borrower, amount);
    }
}
