// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// 0xAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF
contract cryptoPass {
    int256 public minimumDeposit = 10*1e18;

    // ETH => USD 
    AggregatorV3Interface public priceFeed;
    constructor() {
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }
    struct Car {
        uint balance;
        
    }
    mapping(bytes16 => uint) public balance;
    mapping(address => uint) public balance2;

    function spend(bytes16 _plate, uint _value) public {
        balance[_plate] -= _value;

    }

    function addFunds(bytes16 _plate) public payable {
        require(convertETHtoUSD(int256(msg.value))>=minimumDeposit, "minimumDeposit");
        balance[_plate] += msg.value;
    }

    function getETHUSD () public view returns (int256) {
        (,int256 price,,,) = priceFeed.latestRoundData();
        return price;
    }

    function convertETHtoUSD (int256 _ETH) public view returns (int256) {
        int256 price = getETHUSD(); 
        int256 decimals = int8(priceFeed.decimals());

        // return (_ETH / 1e18) * (price/int256(10**uint256(decimals))); //no comma values
        return _ETH * (price/int256(10**uint256(decimals)));
    } 


}