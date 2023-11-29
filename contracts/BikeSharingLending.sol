// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "./ISupraSValueFeed.sol";
//Price Feed Addresses: https://supraoracles.com/docs/price-feeds/decentralized/networks
//IOTEX mainnet: 0x1a83f5937979CdF9E60Af4C064Da367af2289eD3
//IOTEX testnet: 0x59f433fa29Fb2227b6E860956C654AfF7673Af10

contract BikeShareLending {

    IERC721 public bikeNFT;
    IBikeSharingContract public bikeSharingContract;
    ISupraSValueFeed internal sValueFeed;
    ERC20 public usdtToken;

    uint256 private constant IOTX_USD_PAIR_INDEX = 134; // iotx_usdt pair (https://supraoracles.com/docs/price-feeds/trading-pairs)

    mapping(uint256 => address) public nftCollateralOwner;
    mapping(address => uint256) public debtBalance;

    constructor(address _bikeNFTAddress, 
                address _bikeSharingContractAddress, 
                address _supraOracleAddress, 
                address _usdtTokenAddress) {
        bikeNFT = IERC721(_bikeNFTAddress);
        bikeSharingContract = IBikeSharingContract(_bikeSharingContractAddress);
        usdtToken = ERC20(_usdtTokenAddress);
        sValueFeed = ISupraSValueFeed(_supraOracleAddress);
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

    function getCurrentIOTXPrice() internal view returns (uint256) {
        //Get the price data for iotx_usdt
        ISupraSValueFeed.dataWithoutHcc memory data = sValueFeed.getSvalue(IOTX_USD_PAIR_INDEX);
        //uint256 data.round
        //uint256 data.decimals
        //uint256 data.time
        //uint256 data.price
        return data.price;
    }

    // Additional functions like repayLoan, withdrawNFT, etc.
}