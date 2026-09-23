// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract JaraInkTestNFT is ERC721 {
    uint256 public constant MAX_SUPPLY = 3;
    uint256 public constant MAX_PER_CALL = 1;
    uint256 public constant MINT_PRICE = 0;

    uint256 public totalSupply;
    mapping(address => bool) public hasMinted;
    mapping(address => bool) public approvedMinter;

    error InvalidQuantity();
    error SoldOut();
    error AlreadyMinted();
    error WrongValue();
    error NotApproved();
    error InvalidApprovedWallet();
    error DuplicateApprovedWallet();
    error NonexistentToken();

    constructor(address[3] memory approvedWallets) ERC721("Jara Ink Test NFT", "JITN") {
        for (uint256 i = 0; i < approvedWallets.length; ++i) {
            address wallet = approvedWallets[i];
            if (wallet == address(0)) revert InvalidApprovedWallet();
            if (approvedMinter[wallet]) revert DuplicateApprovedWallet();
            approvedMinter[wallet] = true;
        }
    }

    function mint(uint256 quantity) external payable {
        if (quantity == 0 || quantity > MAX_PER_CALL) revert InvalidQuantity();
        if (msg.value != MINT_PRICE * quantity) revert WrongValue();
        if (!approvedMinter[msg.sender]) revert NotApproved();
        if (totalSupply + quantity > MAX_SUPPLY) revert SoldOut();
        if (hasMinted[msg.sender]) revert AlreadyMinted();

        hasMinted[msg.sender] = true;
        uint256 tokenId = ++totalSupply;
        _safeMint(msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (_ownerOf(tokenId) == address(0)) revert NonexistentToken();
        if (tokenId == 1) return "https://raw.githubusercontent.com/Olayeniii/jara-ink-test-nft/main/metadata/1.json";
        if (tokenId == 2) return "https://raw.githubusercontent.com/Olayeniii/jara-ink-test-nft/main/metadata/2.json";
        return "https://raw.githubusercontent.com/Olayeniii/jara-ink-test-nft/main/metadata/3.json";
    }
}
