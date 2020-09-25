pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

interface IWEV {
    function mint(address account, uint amount) external;
    function burn(uint amount) external;
}

contract RewardDistributionRecipient is Ownable {
    address rewardDistribution;

    function notifyRewardAmount(uint256 reward) external;

    modifier onlyRewardDistribution() {
        require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
        _;
    }
    constructor () public {
       rewardDistribution = msg.sender; 
    }
    function setRewardDistribution(address _rewardDistribution) external onlyOwner {
        rewardDistribution = _rewardDistribution;
    }
}

contract LPTokenWrapper {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using Address for address; 
    
    IERC20 public y;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    
    constructor (IERC20 _token) public {
        y = IERC20(_token);
    }
    
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function stake(uint256 amount) public {
        address sender = msg.sender;
        require(!address(sender).isContract(),"only EOA");
        require(tx.origin == sender);

        _totalSupply = _totalSupply.add(amount);
        _balances[msg.sender] = _balances[msg.sender].add(amount);
        y.safeTransferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 amount) public {
        _totalSupply = _totalSupply.sub(amount);
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        y.safeTransfer(msg.sender, amount);
    }
}
