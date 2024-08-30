pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Fallback.sol";


/** 
 * 解题思路：
 */
contract TestTemplateTest is Test {
    address hacker = address(hacker);

    function setUp() public {
        vm.deal(hacker, 1 ether);
    }
    function testFallback() public {
        vm.startPrank(hacker);

        vm.stopPrank();
    }
}