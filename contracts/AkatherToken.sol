pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AkatherToken is ERC20 {
  constructor() ERC20("Akather Token", "AKT") {
    _mint(msg.sender, 100 * (10 ** uint256(decimals())));
  }
}