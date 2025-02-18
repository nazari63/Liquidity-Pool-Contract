// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract LiquidityPool {
    address public admin;
    IERC20 public token1;
    IERC20 public token2;
    
    uint public totalLiquidity1;
    uint public totalLiquidity2;

    event LiquidityAdded(address indexed user, uint amount1, uint amount2);
    event LiquidityRemoved(address indexed user, uint amount1, uint amount2);

    constructor(address _token1, address _token2) {
        admin = msg.sender;
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
    }

    function addLiquidity(uint amount1, uint amount2) external {
        require(token1.transferFrom(msg.sender, address(this), amount1), "Transfer of token1 failed");
        require(token2.transferFrom(msg.sender, address(this), amount2), "Transfer of token2 failed");

        totalLiquidity1 += amount1;
        totalLiquidity2 += amount2;

        emit LiquidityAdded(msg.sender, amount1, amount2);
    }

    function removeLiquidity(uint amount1, uint amount2) external {
        require(amount1 <= totalLiquidity1 && amount2 <= totalLiquidity2, "Insufficient liquidity");

        totalLiquidity1 -= amount1;
        totalLiquidity2 -= amount2;

        require(token1.transfer(msg.sender, amount1), "Transfer of token1 failed");
        require(token2.transfer(msg.sender, amount2), "Transfer of token2 failed");

        emit LiquidityRemoved(msg.sender, amount1, amount2);
    }

    function getLiquidity() external view returns (uint, uint) {
        return (totalLiquidity1, totalLiquidity2);
    }
}