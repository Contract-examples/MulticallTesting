// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { Test, console2 } from "forge-std/Test.sol";
import { Bank } from "../src/Bank.sol";

contract BankTest is Test {
    Bank public bank;
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");

    function setUp() public {
        bank = new Bank();
        vm.deal(alice, 100 ether);
        vm.deal(bob, 100 ether);
        vm.deal(address(bank), 1 ether);
    }

    function testMulticall() public {
        // multicall data
        bytes[] memory data = new bytes[](2);

        // 1. call getBalance
        data[0] = abi.encodeWithSelector(bank.getBalance.selector);

        // 2. call getTopDepositors
        data[1] = abi.encodeWithSelector(bank.getTopDepositors.selector);

        // alice call multicall
        vm.startPrank(alice);

        bytes[] memory results = bank.multicall(data);

        // decode and verify results
        uint256 balance = abi.decode(results[0], (uint256));
        address[3] memory topDepositors = abi.decode(results[1], (address[3]));

        assertEq(balance, 1 ether); // because we give 1 ether to the contract in setUp
        assertEq(topDepositors[0], address(0));

        vm.stopPrank();
    }
}
