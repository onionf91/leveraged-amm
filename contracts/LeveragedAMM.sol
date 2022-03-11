// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LeveragedAMM is Ownable {
    IERC20 public immutable tokenUsdc;

    uint256 public reserveUsdc;
    uint256 public reserveEth;

    mapping(address => uint256) private _usdcCash;
    mapping(address => uint256) private _ethCash;

    modifier notOwner() {
        require(owner() != _msgSender(), "LeverageAMM: caller is the owner");
        _;
    }

    receive() external payable {
        if (owner() == _msgSender()) {
            reserveEth += msg.value;
        } else {
            _ethCash[_msgSender()] += msg.value;
        }
    }

    constructor(address tokenUsdc_) Ownable() {
        tokenUsdc = IERC20(tokenUsdc_);
    }

    function usdcCashOf(address account) public view returns(uint256) {
        return _usdcCash[account];
    }

    function ethCashOf(address account) public view returns(uint256) {
        return _ethCash[account];
    }

    function depositUSDC(uint256 amount) public {
        tokenUsdc.transferFrom(_msgSender(), address(this), amount);
        if (owner() == _msgSender()) {
            reserveUsdc += amount;
        } else {
            _usdcCash[_msgSender()] += amount;
        }
    }
}
