pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TestErrorNFT is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public maxMintPerUser = 3;
    uint256 public maxSupply = 10000;
    uint256 public totalSupply;
    mapping(address => uint256) private userMintedCount;

    constructor() ERC721("ErrorNFT", "ENFT") {}

    

    function mint(address to) public {
        _safeMint(to, _tokenIdCounter.current());
        _tokenIdCounter.increment();
        userMintedCount[to]++;
        ++totalSupply;
    }

    function batchMint(address to, uint256 amount) public {
        for (uint256 i = 0; i < amount; i++) {
            mint(to);
        }
    }
    totalSupply += amount;


    function setUserMintLimit(uint256 newLimit) public onlyOwner {
        maxMintPerUser = newLimit;
    }

    function _baseURI() internal view override returns (string memory) {
        return "ipfs://";
    }
}