pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {DelegateERC20, IDetectionBot, CVDetectionBot, IForta, Forta, CryptoVault, LegacyToken, DoubleEntryPoint} from "../src/DoubleEntryPoint.sol";
import "openzeppelin-contracts-08/contracts/token/ERC20/ERC20.sol";

/** 
 * 解题思路：关键是要实现一个 DetectionBot 阻止 DET token 被转移走
 */
contract TestDoubleEntryPoint is Test {
    address hacker = address(1111111111);
    address sweptTokensRecipient = address(1235712653612);
    LegacyToken public lgt;
    CryptoVault public cv;
    CVDetectionBot public cvd;
    Forta public forta;
    DoubleEntryPoint public det;

    function setUp() public {
        // 初始化合约数据并创建 DetectionBot 合约
        vm.deal(hacker, 1 ether);
        vm.deal(sweptTokensRecipient, 1 ether);
        lgt = new LegacyToken();
        cv = new CryptoVault(sweptTokensRecipient);
        forta = new Forta();
        det = new DoubleEntryPoint(address(lgt), address(cv), address(forta), hacker);
        cvd = new CVDetectionBot(address(cv));
        cv.setUnderlying(address(det));
    }

    function testDoubleEntryPoint() public {
        vm.startPrank(hacker);
        forta.setDetectionBot(address(cvd));

        cv.sweepToken(IERC20(lgt));

        vm.stopPrank();
    }
}