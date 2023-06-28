// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployStormragerToken} from "../script/DeployStormragerToken.s.sol";
import {StormragerToken} from "../src/StormragerToken.sol";

contract StormragerTokenTest is Test {
    StormragerToken public stormragerToken;
    DeployStormragerToken public deployer;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address charlie = makeAddr("charlie");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployStormragerToken();
        stormragerToken = deployer.run();

        vm.prank(msg.sender);
        stormragerToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, stormragerToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        stormragerToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        stormragerToken.transferFrom(bob, alice, transferAmount);

        assertEq(stormragerToken.balanceOf(alice), transferAmount);
        assertEq(
            stormragerToken.balanceOf(bob),
            STARTING_BALANCE - transferAmount
        );
    }

    function testTransfer() public {
        uint256 transferAmount = 50 ether;
        uint256 senderBalance = stormragerToken.balanceOf(msg.sender);

        vm.prank(msg.sender);

        stormragerToken.transfer(alice, transferAmount);
        assertEq(stormragerToken.balanceOf(alice), transferAmount);
        assertEq(
            stormragerToken.balanceOf(msg.sender),
            senderBalance - transferAmount
        );
    }

    function testTransferFrom() public {
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 500;

        vm.prank(bob);
        stormragerToken.approve(alice, initialAllowance);

        vm.prank(alice);
        stormragerToken.transferFrom(bob, alice, transferAmount);

        assertEq(stormragerToken.balanceOf(alice), transferAmount);
        assertEq(
            stormragerToken.balanceOf(bob),
            STARTING_BALANCE - transferAmount
        );
        assertEq(
            stormragerToken.allowance(bob, alice),
            initialAllowance - transferAmount
        );
    }

    function testTransferWithInsufficientBalance() public {
        uint256 transferAmount = 150;

        (bool success, ) = address(stormragerToken).call(
            abi.encodeWithSignature(
                "transfer(address,uint256)",
                alice,
                transferAmount
            )
        );
        assertTrue(!success, "Transfer should fail with insufficient balance");
    }

    function testTransferFromWithInsufficientAllowance() public {
        uint256 initialAllowance = 100;
        uint256 transferAmount = 150;

        stormragerToken.approve(alice, initialAllowance);

        (bool success, ) = address(stormragerToken).call(
            abi.encodeWithSignature(
                "transferFrom(address,address,uint256)",
                bob,
                charlie,
                transferAmount
            )
        );
        assertTrue(
            !success,
            "TransferFrom should fail with insufficient allowance"
        );
    }
}
