// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./tools.sol";

contract cryptoPass {
    // Variables 0xAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF
    // Variables 0xAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF
    using priceTools for int256;
    using addressTools for address[];

    int256 public minimumDeposit = 10*1e18;
    // ETH => USD 
    AggregatorV3Interface public priceFeed;
    address[] public auhtorizedSpender;

    struct Depositor {
        address depositor;
        uint deposited;
    }
    
    struct Car {
        uint balance;
        Depositor[] depositors;
        
    }
    // plate => balance
    mapping(bytes16 => uint) public balance;
    mapping(bytes16 => Car) public balance2;

    constructor() {
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        auhtorizedSpender.push(payable(msg.sender));
    }

    // Functions
    function spend(bytes16 _plate, uint _value) public onlyAuhtorized returns (Depositor[] memory) {
        balance[_plate] -= _value;

        Depositor[] memory depositorsCopy = balance2[_plate].depositors;
        // for (uint i = 0; i < 2 - 1; i++) {
        //     // if exceeds value added by depositor
        //     depositorsCopy = depositorsCopy.removeFirstDepositor();
        // }

        // payable(msg.sender).transfer(_value);
        return depositorsCopy;
    }

    function addDeposit(bytes16 _plate, uint _deposited) public returns(address asd) {
        Depositor[] memory _depositors = balance2[_plate].depositors;

        balance2[_plate].balance = _deposited;
        _depositors[0].deposited = 3e10;
        _depositors[0].depositor = msg.sender;
        balance2[_plate].depositors = _depositors;
        return _depositors[0].depositor;
    }

    function getCar (bytes16 _plate) public view returns(Car memory) {
        return balance2[_plate];
    }

    function addFunds(bytes16 _plate) public {
        // require(int256(msg.value).convertETHtoUSD(priceFeed)>=minimumDeposit, "minimumDeposit");
        // for (uint256 depositorIndex=0; depositorIndex < balance2[_plate].depositors.length; depositorIndex++) {

        // }
        addDeposit(_plate, 25);
        balance[_plate] += 25;
        // return arrayLength+1;
        // uint arrayLength = balance2[_plate].depositors.length;
        // balance2[_plate].balance += 25;
        // balance2[_plate].depositors[arrayLength+1].push(msg.sender, 25e10);

    }

    // Modifiers
    modifier onlyAuhtorized {
        require(msg.sender==auhtorizedSpender[0], "not authorized");
        _;
    }
}

contract Nest {

  struct IpfsHash {
    bytes32 hash;
    uint hashSize;
  }

  struct Member {
    IpfsHash ipfsHash;
    uint deposited;
  }

  mapping(uint => Member) members;

  function addMember(uint id, bytes32 hash, uint size) public returns(bool success) {
    members[id].deposited = 2;
    members[id].ipfsHash.hash = hash;
    members[id].ipfsHash.hashSize = size;
    return true;
  }

  function getMember(uint id) public view returns(bytes32 hash, uint hashSize, Member memory) {
    return(members[id].ipfsHash.hash, members[id].ipfsHash.hashSize, members[id]);
  }
}