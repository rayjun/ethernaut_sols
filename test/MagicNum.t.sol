pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/MagicNum.sol";


/** 
 * 解题思路：MagicNum 表示 42，也就是说需要部署一个合约，让合约中的 function whatIsTheMeaningOfLife() 方法返回 42，opcode 的 size 要在 10 以内
 */
contract HackMagicNumTest is Test {
    address hacker = address(hacker);
    MagicNum public m;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        m = new MagicNum();
    }
    function testHackMagicNum() public {
        vm.startPrank(hacker);

        bytes memory code = "600a600c600039600a6000f3602a60805260206080f3";
        address solver;
        assembly {
            solver := create(0, add(code, 0x20), mload(code))
        }
        MagicNum(m).setSolver(solver);
        vm.stopPrank();
    }
}