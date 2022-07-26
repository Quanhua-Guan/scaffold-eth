// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Lib1 as Lib, HackMe1 as HackMe, Attack1 as Attack } from "./DelegatecallAttack1.sol";
import { Lib as lb, HackMe as hm, Attack as ak} from "./DelegatecallAttack2.sol";

contract YourContract_DelegatecallAttack1 {
    string public message = "Hello World";
    Lib public lib;
    HackMe public hackMe;
    Attack public attack;
    
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }

    function deployDelegatecallAttackDemoContracts() public {
        lib = new Lib();
        hackMe = new HackMe(lib);
        attack = new Attack(address(hackMe));
    }

    function doAttack() public {
        attack.attack();
    }

    function getAttackCount() public view returns (uint) {
        return attack.count();
    }

    function getHackMeOwnerAddr() public view returns (address) {
        return hackMe.owner();
    }
}

contract YourContract_DelegatecallAttack2 {
    lb public lib;
    hm public hackMe;
    ak public attack;

    function deployDelegatecallAttackDemoContracts() public {
        lib = new lb();
        hackMe = new hm(address(lib));
        attack = new ak(hackMe);
    }

    function doAttack() public {
        attack.attack();
    }

    function getHackMeOwnerAddr() public view returns (address) {
        return hackMe.owner();
    }

    function getAttackSomeNumber() public view returns (uint) {
        return attack.someNumber();
    }
}