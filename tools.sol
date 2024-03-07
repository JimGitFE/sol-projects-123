// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library priceTools {
    // We could make this public, but then we'd have to deploy it

    function getETHUSD (AggregatorV3Interface _priceFeed) internal view returns (int256) {
        (,int256 price,,,) = _priceFeed.latestRoundData();
        return price;
    }
    
    function convertETHtoUSD (int256 _ETH, AggregatorV3Interface _priceFeed) internal view returns (int256) {
        int256 price = getETHUSD(_priceFeed); 
        int256 decimals = int8(_priceFeed.decimals());

        // return (_ETH / 1e18) * (price/int256(10**uint256(decimals))); //no comma values
        return _ETH * (price/int256(10**uint256(decimals)));
    } 
}

library addressTools {
    struct Depositor {
        address depositor;
        uint deposited;
    }

    function removeFirst(address[] memory _array) internal pure returns (address[] memory) {
        address[] memory newArray = new address[](_array.length-1);

        for (uint i = 0; i < _array.length - 1; i++) {
            newArray[i] = address(_array[i+1]); 
        }
        return newArray;
    }

    function removeFirstDepositor(Depositor[] memory _array) internal pure returns (Depositor[] memory) {
        Depositor[] memory newArray = new Depositor[](_array.length-1);

        for (uint i = 0; i < _array.length - 1; i++) {
            newArray[i] = _array[i+1];
        }
        return newArray;
    }
}