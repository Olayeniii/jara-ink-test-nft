// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {JaraInkTestNFT} from "../src/JaraInkTestNFT.sol";

contract JaraInkTestNFTTest is Test {
    JaraInkTestNFT nft;
    address minter = address(0xBEEF);

    function setUp() public {
        nft = new JaraInkTestNFT();
    }

    function testMintOneForZeroEth() public {
        vm.prank(minter);
        nft.mint(1);
        assertEq(nft.ownerOf(1), minter);
        assertEq(nft.totalSupply(), 1);
        assertTrue(nft.hasMinted(minter));
    }

    function testRejectsZeroQuantity() public {
        vm.expectRevert(JaraInkTestNFT.InvalidQuantity.selector);
        nft.mint(0);
    }

    function testRejectsMoreThanOnePerCall() public {
        vm.expectRevert(JaraInkTestNFT.InvalidQuantity.selector);
        nft.mint(2);
    }

    function testRejectsSecondMintFromSameWallet() public {
        vm.startPrank(minter);
        nft.mint(1);
        vm.expectRevert(JaraInkTestNFT.AlreadyMinted.selector);
        nft.mint(1);
        vm.stopPrank();
    }

    function testSupplyCap() public {
        for (uint256 i = 0; i < 3; ++i) {
            vm.prank(address(uint160(i + 1)));
            nft.mint(1);
        }

        vm.prank(address(0xCAFE));
        vm.expectRevert(JaraInkTestNFT.SoldOut.selector);
        nft.mint(1);
    }

    function testRejectsUnexpectedValue() public {
        vm.deal(minter, 1 ether);
        vm.prank(minter);
        vm.expectRevert(JaraInkTestNFT.WrongValue.selector);
        nft.mint{value: 1}(1);
    }

    function testUniqueTokenUris() public {
        address a = address(1);
        address b = address(2);
        address c = address(3);
        vm.prank(a); nft.mint(1);
        vm.prank(b); nft.mint(1);
        vm.prank(c); nft.mint(1);
        assertTrue(keccak256(bytes(nft.tokenURI(1))) != keccak256(bytes(nft.tokenURI(2))));
        assertTrue(keccak256(bytes(nft.tokenURI(2))) != keccak256(bytes(nft.tokenURI(3))));
    }
}
