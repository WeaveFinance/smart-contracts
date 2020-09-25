/**
 *Submitted for verification at Etherscan.io on 2020-07-26
*/

pragma solidity ^0.5.16;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract WEV is ERC20, ERC20Detailed {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint;
  
  address public governance;
  mapping (address => bool) public minters;

  constructor () public ERC20Detailed("Weave DAO Token", "WEV", 18) {
      governance = tx.origin;
  }

  function mint(address account, uint256 amount) public {
      require(minters[msg.sender], "!minter");
      _mint(account, amount);
  }
  
  function setGovernance(address _governance) public {
      require(msg.sender == governance, "!governance");
      governance = _governance;
  }
  
  function addMinter(address _minter) public {
      require(msg.sender == governance, "!governance");
      minters[_minter] = true;
  }
  
  function removeMinter(address _minter) public {
      require(msg.sender == governance, "!governance");
      minters[_minter] = false;
  }
}