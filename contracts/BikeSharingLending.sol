// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "./IBikeSharingContract.sol";

contract BikeShareLending {

    IERC721 public bikeNFT;
    IBikeSharingContract public bikeSharingContract;
    ERC20 public usdtToken;

    mapping(uint256 => address) public nftCollateralOwner;
    mapping(address => uint256) public debtBalance;

    constructor(address _bikeNFTAddress, 
                address _bikeSharingContractAddress, 
                address _usdtTokenAddress) {
        bikeNFT = IERC721(_bikeNFTAddress);
        bikeSharingContract = IBikeSharingContract(_bikeSharingContractAddress);
        usdtToken = ERC20(_usdtTokenAddress);
    }

    function depositNFT(uint256 nftId) external {
        bikeNFT.transferFrom(msg.sender, address(this), nftId);
        nftCollateralOwner[nftId] = msg.sender;
    }

    function borrowUSDT(uint256 nftId, uint256 amount) external {
        require(nftCollateralOwner[nftId] == msg.sender, "Not NFT owner");
        uint256 incomeIOTX = bikeSharingContract.getMonthlyIncome(nftId);
        uint256 incomeUSD = incomeIOTX * getCurrentIOTXPrice() / (10 ** 18); // Convert IOTX income to USD
        uint256 maxBorrow = incomeUSD / 4; // 25% of income
        require(amount <= maxBorrow, "Exceeds maximum borrow amount");
        usdtToken.transfer(msg.sender, amount);
        debtBalance[msg.sender] += amount;
    }

    function getCurrentIOTXPrice() internal view returns (uint256) { }

    // Additional functions like repayLoan, withdrawNFT, etc.
}