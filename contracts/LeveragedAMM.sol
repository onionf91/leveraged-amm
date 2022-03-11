// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LeveragedAMM is Ownable {
    IERC20 public immutable tokenUsdc;
    uint256 public immutable maxLeverage;

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
        maxLeverage = 10;
    }

    function usdcCashOf(address account) public view returns(uint256) {
        return _usdcCash[account];
    }

    function ethCashOf(address account) public view returns(uint256) {
        return _ethCash[account];
    }

    function depositUsdc(uint256 amount) public {
        tokenUsdc.transferFrom(_msgSender(), address(this), amount);
        if (owner() == _msgSender()) {
            reserveUsdc += amount;
        } else {
            _usdcCash[_msgSender()] += amount;
        }
    }

    function _calculateSwappedEth(uint256 usdcIn) internal view returns(uint256) {
        require(usdcIn < reserveUsdc, "LeveragedAMM: out of reserve usdc.");
        return reserveEth - ((reserveUsdc * reserveEth) / (reserveUsdc + usdcIn));
    }

    function _calculateSwappedUsdc(uint256 ethIn) internal view returns(uint256) {
        require(ethIn < reserveEth, "LeveragedAMM: out of reserve eth.");
        return reserveUsdc - ((reserveUsdc * reserveEth) / (reserveEth + ethIn));
    }

    function estimateEthPosition(uint256 usdc, uint256 leverage) public view returns(uint256) {
        require(leverage <= maxLeverage, "LeveragedAMM: max leverage is 10.");
        return _calculateSwappedEth(usdc * leverage);
    }

    function estimateUsdcPosition(uint256 eth, uint256 leverage) public view returns(uint256) {
        require(leverage <= maxLeverage, "LeveragedAMM: max leverage is 10.");
        return _calculateSwappedUsdc(eth * leverage);
    }
}
