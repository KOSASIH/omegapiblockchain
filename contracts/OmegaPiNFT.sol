pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/SafeERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/Counters.sol";

contract OmegaPiNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    using SafeERC721 for address;

    // Mapping of NFTs
    mapping (uint256 => NFT) public nfts;

    // Mapping of auctions
    mapping (uint256 => Auction) public auctions;

    // Event for new NFT creation
    event NewNFT(uint256 tokenId, address creator, string uri);

    // Event for auction creation
    event NewAuction(uint256 tokenId, address seller, uint256 startingPrice);

    // Event for auction bid
    event AuctionBid(uint256 tokenId, address bidder, uint256 bidAmount);

    // Event for auction end
    event AuctionEnd(uint256 tokenId, address winner, uint256 winningBid);

    // Struct for NFTs
    struct NFT {
        address creator;
        string uri;
        uint256 tokenId;
    }

    // Struct for auctions
    struct Auction {
        address seller;
        uint256 startingPrice;
        uint256 highestBid;
        address highestBidder;
        uint256 auctionEndTime;
    }

    // Function to create a new NFT
    function createNFT(string memory uri) public {
        uint256 tokenId = Counters.current(tokenIdCounter);
        nfts[tokenId] = NFT(msg.sender, uri, tokenId);
        emit NewNFT(tokenId, msg.sender, uri);
    }

    // Function to create a new auction
    function createAuction(uint256 tokenId, uint256 startingPrice) public {
        require(nfts[tokenId].creator == msg.sender, "Only the NFT creator can create an auction");
        auctions[tokenId] = Auction(msg.sender, startingPrice, 0, address(0), block.timestamp + 30 minutes);
        emit NewAuction(tokenId, msg.sender, startingPrice);
    }

    // Function to bid on an auction
    function bidOnAuction(uint256 tokenId, uint256 bidAmount) public {
        require(auctions[tokenId].auctionEndTime > block.timestamp, "Auction has already ended");
        require(bidAmount > auctions[tokenId].highestBid, "Bid amount is too low");
        auctions[tokenId].highestBid = bidAmount;
        auctions[tokenId].highestBidder = msg.sender;
        emit AuctionBid(tokenId, msg.sender, bidAmount);
    }

    // Function to end an auction
    function endAuction(uint256 tokenId) public {
        require(auctions[tokenId].auctionEndTime <= block.timestamp, "Auction has not ended yet");
        address winner = auctions[tokenId].highestBidder;
        uint256 winningBid = auctions[tokenId].highestBid;
        emit AuctionEnd(tokenId, winner, winningBid);
    }
}
