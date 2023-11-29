// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/** 
* @title ISupraSValueFeed
* @notice Interface for interacting directly with Supra's sValueFeed contract.
* @dev Please refer to Supra's documentation: https://supraoracles.com/docs
*/
interface ISupraSValueFeed {

    // Data structure to hold the pair data
    struct dataWithoutHcc {
    uint256 round;
    uint256 decimals;
    uint256 time;
    uint256 price;
    }

    // Data structure to hold the pair data with History Consistency Check
    struct dataWithHcc {
    uint256 round;
    uint256 decimals;
    uint256 time;
    uint256 price;
    uint256 historyConsistent;
    }

    // Data structure to hold the derived pair data 
    struct derivedData{
    int256 roundDifference;
    int256 timeDifference;
    uint256 derivedPrice;
    uint256 decimals;
    }

    // Below functions enable you to retrieve different flavours of S-Value

    // Function to fetch the data for a single data pair
    function getSvalue(uint256 _pairIndex)
    external
    view
    returns (dataWithoutHcc memory);

    //Function to fetch the data for a multiple data pairs
    function getSvalues(uint256[] memory _pairIndexes)
    external
    view
    returns (dataWithoutHcc[] memory);

    // Function to Fetch the Data for a single data pair with HCC
    function getSvalueWithHCC(uint256 _pairIndex)
    external
    view
    returns (dataWithHcc memory);

    // Function to Fetch the Data for a multiple data pairs with HCC
    function getSvaluesWithHCC(uint256[] memory _pairIndexes)
    external
    view
    returns (dataWithHcc[] memory);

    // Function to fetch the data for a derived data pair.
    function getDerivedSvalue(uint256 _derivedPairId)
    external
    view
    returns (derivedData memory);

    // Function to fetch the timestamp(Last or Latest) of the data pair
    // If you need to check the staleness of the data prior to requesting S-values
    // use this function to check the last updated time stamp of the data pair.
    
    function getTimestamp(uint256 _tradingPair) 
    external
    view
    returns (uint256);

}