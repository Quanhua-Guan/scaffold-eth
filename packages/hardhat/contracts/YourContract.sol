pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "./RDHStrings.sol";
import "./AddLib.sol";

contract YourContract {
    using RDHStrings for uint256;
    using AddLib for uint256;

    event SetPurpose(address sender, string purpose);

    string public purpose = "Building Unstoppable Apps!_!";

    constructor() payable {}

    function setPurpose(string memory newPurpose1) public {
        purpose = string.concat(newPurpose1, (uint256(22).add(21)).toString());
        emit SetPurpose(msg.sender, purpose);
    }

    // to support receiving ETH by default
    receive() external payable {}

    fallback() external payable {}
}
