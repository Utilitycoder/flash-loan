// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanExample is FlashLoanSimpleReceiverBase {
    using SafeMath for uint;

    event Log(address asset, uint val);
    /**
    * @dev Constructor 
    * @param the address of the pool contract
    */
    constructor(IPoolAddressesProvider provider) 
        public 
        FlashLoanSimpleReceiverBase(provider) 
        
    {}
    /**
    * @Dev Initiates the flash loan 
    * @param asset the asset the user wants to borrow
    * @param amount the amount the user wants to borrow
    */
    function createFlashLoan(address asset , uint amount) external {
        address receiver = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiver, asset, amount, 
            params, referralCode);

    }

    function executeOperation(
        address asset, 
        uint amount, 
        uint premium, 
        address initiator, 
        bytes calldata params
    ) external returns (bool) {
        uint amountOwing = amount.add(premium);
        IERC20(asset).approve(address(POOL), amountOwing);
        emit Log( asset, amountOwing);
        return true;
    }
} 

