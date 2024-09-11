pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {GatekeeperOne, GatekeeperOneAttacker} from "../src/GatekeeperOne.sol";


/** 
 * 解题思路：总共要破解三个 gate
 * 1. 第一个通过跨合约调用就可以完成
 * 2. 第二个条件通过暴力破解 gas 用量來使最终的 gas 剩余量满足要求
 * 3. 第三个条件要了解 solidity 类型转型以及 & 操作符的用途
 */
contract HackGatekeeperOneTest is Test {
    address hacker = address(12346788888888);
    GatekeeperOne public g;
    GatekeeperOneAttacker public ga;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        g = new GatekeeperOne();
        ga = new GatekeeperOneAttacker();
    }
    function testHackkeeperOne() public {
        vm.startPrank(hacker, hacker);
        bool re = ga.attack(address(g));
        assert(re == true);
        console.log("Gate entrant");
        console.logAddress(g.entrant());
        assert(g.entrant() == hacker);
        vm.stopPrank();
    }
}