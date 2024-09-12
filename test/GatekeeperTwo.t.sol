pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {GatekeeperTwo, GatekeeperTwoAttacker} from "../src/GatekeeperTwo.sol";


/** 
 * 解题思路：总共要破解三个 gate，和 GatekeeperOne 类似，但是更复杂一些
 * 1. 第一个通过跨合约调用就可以完成
 * 2. 第二个通过构造函数来调用就会让 extcodesize 为零，这里需要理解 assembly 的机制以及 extcodesize 方法，这里构造函数是 creation code 而不是 runtime code，只会运行一次，所以 extcodesize 会返回 0
 * 3. 第三个需要理解异或操作，然后反向生成一个 gateKey
 */
contract HackGatekeeperTwoTest is Test {
    address hacker = address(12346788888888);
    GatekeeperTwo public g;
    GatekeeperTwoAttacker public ga;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        g = new GatekeeperTwo();
    }
    function testHackkeeperTwo() public {
        vm.startPrank(hacker, hacker);
        ga = new GatekeeperTwoAttacker(address(g));
        console.log("Gate entrant");
        console.logAddress(g.entrant());
        assert(g.entrant() == hacker);
        vm.stopPrank();
    }
}