pragma solidity ^0.5.0;

import "../external/CloneFactory.sol";

contract Clone {

  CloneFactory public Factory;

  uint public blockInitialized;

  modifier requireNotInitialized () {
    require(blockInitialized == 0);
    Factory = CloneFactory(msg.sender);
    _;
    blockInitialized = block.number;
  }

}
