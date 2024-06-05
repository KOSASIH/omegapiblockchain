pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

contract OmegaPiMetaToken is ERC20, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    // Mapping of token IDs to their corresponding metadata
    mapping(uint256 => TokenMetadata) public tokenMetadata;

    // Mapping of token IDs to their owners
    mapping(uint256 => address) public tokenOwners;

    // Counter for token IDs
    Counters.Counter public tokenIdCounter;

    // Event emitted when a new token is minted
    event NewTokenMinted(uint256 indexed tokenId, address indexed owner, string metadata);

    // Event emitted when a token is transferred
    event TokenTransferred(uint256 indexed tokenId, address indexed from, address indexed to);

    // Struct to represent token metadata
    struct TokenMetadata {
        string name;
        string description;
        string image;
        uint256 attributes; // Bitmask of attributes (e.g., rarity, type, etc.)
    }

    /**
     * @dev Mints a new token with the given metadata and assigns it to the specified owner.
     * @param _metadata The metadata for the new token.
     * @param _owner The owner of the new token.
     */
    function mintToken(string memory _metadata, address _owner) public onlyOwner {
        uint256 newTokenId = tokenIdCounter.current();
        tokenIdCounter.increment();

        TokenMetadata memory metadata = parseMetadata(_metadata);
        tokenMetadata[newTokenId] = metadata;
        tokenOwners[newTokenId] = _owner;

        _mint(_owner, newTokenId);
        emit NewTokenMinted(newTokenId, _owner, _metadata);
    }

    /**
     * @dev Transfers a token from one address to another.
     * @param _tokenId The ID of the token to transfer.
     * @param _from The current owner of the token.
     * @param _to The new owner of the token.
     */
    function transferToken(uint256 _tokenId, address _from, address _to) public {
        require(tokenOwners[_tokenId] == _from, "Only the owner can transfer the token");
        tokenOwners[_tokenId] = _to;
        emit TokenTransferred(_tokenId, _from, _to);
    }

    /**
     * @dev Parses the metadata string into a TokenMetadata struct.
     * @param _metadata The metadata string to parse.
     * @return The parsed TokenMetadata struct.
     */
    function parseMetadata(string memory _metadata) internal pure returns (TokenMetadata memory) {
        // Implement metadata parsing logic here
        // ...
    }
}
