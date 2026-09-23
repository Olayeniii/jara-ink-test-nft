// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {JaraInkTestNFT} from "../src/JaraInkTestNFT.sol";

contract JaraInkTestNFTTest is Test {
    JaraInkTestNFT nft;

    address approved1 = address(0xA11CE);
    address approved2 = address(0xB0B);
    address approved3 = address(0xCAFE);
    address unapproved = address(0xBAD);

    function setUp() public {
        address[3] memory approvedWallets = [approved1, approved2, approved3];
        nft = new JaraInkTestNFT(approvedWallets);
    }

    function testApprovedWalletCanMintOne() public {
        vm.prank(approved1);
        nft.mint(1);

        assertEq(nft.totalSupply(), 1);
        assertTrue(nft.hasMinted(approved1));
    }

    function testNftOwnerIsApprovedCaller() public {
        vm.prank(approved1);
        nft.mint(1);

        assertEq(nft.ownerOf(1), approved1);
    }

    function testUnapprovedWalletReverts() public {
        vm.prank(unapproved);
        vm.expectRevert(JaraInkTestNFT.NotApproved.selector);
        nft.mint(1);
    }

    function testApprovedWalletCannotMintTwice() public {
        vm.startPrank(approved1);
        nft.mint(1);

        vm.expectRevert(JaraInkTestNFT.AlreadyMinted.selector);
        nft.mint(1);
        vm.stopPrank();
    }

    function testQuantityZeroReverts() public {
        vm.prank(approved1);
        vm.expectRevert(JaraInkTestNFT.InvalidQuantity.selector);
        nft.mint(0);
    }

    function testQuantityAboveOneReverts() public {
        vm.prank(approved1);
        vm.expectRevert(JaraInkTestNFT.InvalidQuantity.selector);
        nft.mint(2);
    }

    function testNonzeroEthReverts() public {
        vm.deal(approved1, 1 ether);
        vm.prank(approved1);
        vm.expectRevert(JaraInkTestNFT.WrongValue.selector);
        nft.mint{value: 1}(1);
    }

    function testTotalSupplyCannotExceedThree() public {
        vm.prank(approved1);
        nft.mint(1);
        vm.prank(approved2);
        nft.mint(1);
        vm.prank(approved3);
        nft.mint(1);

        assertEq(nft.totalSupply(), 3);

        vm.prank(approved1);
        vm.expectRevert(JaraInkTestNFT.SoldOut.selector);
        nft.mint(1);
    }

    function testAllowlistCannotBeChangedAfterDeployment() public {
        assertTrue(nft.approvedMinter(approved1));
        assertFalse(nft.approvedMinter(unapproved));

        (bool ok,) = address(nft).call(
            abi.encodeWithSignature("setApproved(address,bool)", unapproved, true)
        );

        assertFalse(ok);
        assertTrue(nft.approvedMinter(approved1));
        assertFalse(nft.approvedMinter(unapproved));
    }

    function testConstructorRejectsZeroApprovedWallet() public {
        address[3] memory approvedWallets = [approved1, address(0), approved3];

        vm.expectRevert(JaraInkTestNFT.InvalidApprovedWallet.selector);
        new JaraInkTestNFT(approvedWallets);
    }

    function testConstructorRejectsDuplicateApprovedWallet() public {
        address[3] memory approvedWallets = [approved1, approved2, approved1];

        vm.expectRevert(JaraInkTestNFT.DuplicateApprovedWallet.selector);
        new JaraInkTestNFT(approvedWallets);
    }

    function testUniqueTokenUrisRemainFixed() public {
        vm.prank(approved1);
        nft.mint(1);
        vm.prank(approved2);
        nft.mint(1);
        vm.prank(approved3);
        nft.mint(1);

        assertTrue(keccak256(bytes(nft.tokenURI(1))) != keccak256(bytes(nft.tokenURI(2))));
        assertTrue(keccak256(bytes(nft.tokenURI(2))) != keccak256(bytes(nft.tokenURI(3))));
    }
}
