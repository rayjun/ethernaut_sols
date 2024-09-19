pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Shop, BuyerAttacker} from "../src/Shop.sol";


/** 
 * 解题思路：和之前 Elevator 的思路一样，让函数两次返回的结果不一样就行
 * 稍微有些不同的地方在于 price 是一个 view 方法，无法在该方法里面修改状态，所以要借助 Shop 的 isSold 状态来判断
 */
contract HackShopTest is Test {
    address hacker = address(hacker);
    Shop public s;
    BuyerAttacker public ba;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        s = new Shop();
        ba = new BuyerAttacker(address(s));
    }
    function testHackShop() public {
        vm.startPrank(hacker);
        ba.attack();
        assert(s.isSold() == true);
        assert(s.price() == 1);
        vm.stopPrank();
    }
}