// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface IBikeSharingContract {
    // Provides the monthly income in IOTX for a given NFT
    function getMonthlyIncome(uint256 nftId) external view returns (uint256);

}