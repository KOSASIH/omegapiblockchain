pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Raffle {
    // Mapping of user balances
    mapping(address => uint256) public balances;

    // Event emitted when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Event emitted when tokens are minted
    event Mint(address indexed to, uint256 value);

    // Event emitted when tokens are burned
    event Burn(address indexed to, uint256 value);

    /**
     * @dev Initializes the token with the given name and symbol.
     * @param _name The name of the token.
     * @param _symbol The symbol of the token.
     */
    constructor(string memory _name, string memory _symbol) public {
        name = _name;
        symbol = _symbol;
    }

    /**
     * @dev Transfers tokens from one address to another.
     * @param _from The address to transfer from.
     * @param _to The address to transfer to.
     * @param _value The amount of tokens to transfer.
     */
    function transfer(address _from, address _to, uint256 _value) public {
        require(_from!= address(0), "Cannot transfer from zero address");
        require(_to!= address(0), "Cannot transfer to zero address");

        balances[_from] -= _value;
        balances[_to] += _value;

        emit Transfer(_from, _to, _value);
    }

    /**
     * @dev Mints new tokens and transfers them to the given address.
     * @param _to The address to mint tokens to.
     * @param _value The amount of tokens to mint.
     */
    function mint(address _to, uint256 _value) public onlyOwner {
        balances[_to] += _value;

        emit Mint(_to, _value);
    }

    /**
     * @dev Burns tokens from the given address.
     * @param _from The address to burn tokens from.
     * @param _value The amount of tokens to burn.
     */
    function burn(address _from, uint256 _value) public onlyOwner {
        require(_from!= address(0), "Cannot burn from zero address");

        balances[_from] -= _value;

        emit Burn(_from, _value);
    }
}
