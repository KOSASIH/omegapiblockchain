pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/math/SafeMath.sol";

contract OmegaPiIdentityVerification is Ownable {
    using SafeMath for uint256;

    // Mapping of user identities
    mapping (address => Identity) public identities;

    // Event for creating a new identity
    event NewIdentity(address indexed user, string identity);

    // Event for verifying an identity
    event VerifyIdentity(address indexed user, bool isValid);

    // Struct for user identities
    struct Identity {
        string identity;
        bool isValid;
    }

    // Function to create a new identity
    function createIdentity(string memory identity) public {
        identities[msg.sender] = Identity(identity, false);
        emit NewIdentity(msg.sender, identity);
    }

    // Function to verify an identity
    function verifyIdentity(address user, bool isValid) public {
        require(identities[user].isValid == false, "Identity has already been verified");
        identities[user].isValid = isValid;
        emit VerifyIdentity(user, isValid);
    }
}
