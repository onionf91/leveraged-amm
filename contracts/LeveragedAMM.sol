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
    mapping(address => uint256) private _usdcPositionValue;
    mapping(address => uint256) private _ethPositionValue;
    mapping(address => uint256) private _usdcPosition;
    mapping(address => uint256) private _ethPosition;

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

    function _doSwapEth(uint256 usdcIn) internal returns(uint256 ethOut) {
        ethOut = _calculateSwappedEth(usdcIn);
        reserveUsdc += usdcIn;
        reserveEth -= ethOut;
    }

    function _doSwapUsdc(uint256 ethIn) internal returns(uint256 usdcOut) {
        usdcOut = _calculateSwappedUsdc(ethIn);
        reserveUsdc -= usdcOut;
        reserveEth += ethIn;
    }

    function estimateEthPosition(uint256 usdc, uint256 leverage) public view returns(uint256) {
        require(leverage <= maxLeverage, "LeveragedAMM: max leverage is 10.");
        return _calculateSwappedEth(usdc * leverage);
    }

    function estimateUsdcPosition(uint256 eth, uint256 leverage) public view returns(uint256) {
        require(leverage <= maxLeverage, "LeveragedAMM: max leverage is 10.");
        return _calculateSwappedUsdc(eth * leverage);
    }

    function ethPositionValueOf(address account) public view returns(uint256) {
        return _ethPositionValue[account];
    }

    function ethPositionRemainValueOf(address account) public view returns(uint256) {
        return (_usdcCash[account] * maxLeverage) - _ethPositionValue[account];
    }

    function usdcPositionValueOf(address account) public view returns(uint256) {
        return _usdcPositionValue[account];
    }

    function usdcPositionRemainValueOf(address account) public view returns(uint256) {
        return (_usdcCash[account] * maxLeverage) - _usdcPositionValue[account];
    }

    function openEthPosition(uint256 positionValue) public notOwner {
        require(positionValue <= ethPositionRemainValueOf(_msgSender()), "LeveragedAMM: out of remain position value");
        _ethPositionValue[_msgSender()] += positionValue;
        _ethPosition[_msgSender()] += _doSwapEth(positionValue);
    }

    function openUsdcPosition(uint256 positionValue) public notOwner {
        require(positionValue <= usdcPositionRemainValueOf(_msgSender()), "LeveragedAMM: out of remain position value");
        _usdcPositionValue[_msgSender()] += positionValue;
        _usdcPosition[_msgSender()] += _doSwapUsdc(positionValue);
    }
}
