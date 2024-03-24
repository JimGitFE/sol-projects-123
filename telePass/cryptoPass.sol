// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./tools.sol";

contract cryptoPass {
    // Variables 0xAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF
    // Variables 0xAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF

    // Contract Variables
    using priceTools for int256;
    using addressTools for address[];

    int256 public constant minimumDeposit = 10*1e18;
    // ETH => USD 
    AggregatorV3Interface public priceFeed;
    address[] public auhtorizedSpender;

    // Scenario Variables
    struct Depositor {
        // address depositor;
        uint deposited;
        uint depositsCount;
    }
    
    struct Car {
        uint balance;
        mapping(address => Depositor) depositor;

        address[] depositors;
        mapping(address => bool) depositorExist;
    }
    mapping(bytes16 => Car) public realBalance;
    // address => plates
    mapping(address => bytes16[]) public addrToPlates;
    // plate => balance
    // mapping(bytes16 => uint) public balance;

    constructor() {
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        auhtorizedSpender.push(payable(msg.sender));
    }

    function getBalance (bytes16 _plate) public view returns(uint bal) {
      return realBalance[_plate].balance;
    }
    function getDepositors (bytes16 _plate) public view returns(address[] memory depositors) {
      return realBalance[_plate].depositors;
    }
    function getDeposited (bytes16 _plate) public view returns(uint depositors) {
      // address person = realBalance[_plate].depositors[0];
      return realBalance[_plate].depositor[msg.sender].deposited;
    }
    // function getDepositorsExist (bytes16 _plate) public view returns(bool exists) {
    //   return realBalance[_plate].depositorExist[msg.sender];
    // }
    function getDepositorCount (bytes16 _plate) public view returns(uint counter) {
      return realBalance[_plate].depositor[msg.sender].depositsCount;
    }

    // function addDeposit(bytes16 _plate, uint _deposited) private view returns(address asd) {
    function addDeposit(bytes16 _plate) public payable returns(uint count) {
      require(msg.value>0, "No charge");
      Car storage car = realBalance[_plate];
      Depositor storage account = car.depositor[msg.sender];

      // Add deposited value 
      car.balance += msg.value;
      account.deposited += msg.value;
      account.depositsCount += 1;
      // Add address => plates
      addrToPlates[msg.sender].push(_plate);

      // Adding to array of depositors
      if (!car.depositorExist[msg.sender]) {
        car.depositors.push(msg.sender);
        car.depositorExist[msg.sender] = true;
      }
      // needed?
      // Common Practice, mapping with array


      return account.depositsCount;
    }
    // Functions
    function spend(bytes16 _plate, uint _value) public onlyAuhtorized returns (uint tobespentleft) {
      Car storage car = realBalance[_plate];

      uint toBeSpent = _value;

      // Spend for each depositor until _value is reached
      for (uint i = 0; i < car.depositors.length; i++) {
        Depositor storage accountI = car.depositor[car.depositors[i]];
        
        // Subtract spent amount
        if (accountI.deposited > toBeSpent) {
          accountI.deposited -= toBeSpent;
          car.balance -= toBeSpent;
          toBeSpent -= toBeSpent;

          // Remove User from Array
        } else {
          car.balance -= accountI.deposited;
          toBeSpent -= accountI.deposited;
          accountI.deposited -= accountI.deposited;

          break;
        }
        // car.depositors[i];
        // remove spent depositors
      }
      require(toBeSpent == 0, "Insufficient Balance");
      return toBeSpent;
    }

    function withdraw(uint _amount) public {
      uint toBeWithdrawn = _amount;
      bytes16[] storage toBeRemoved;

      for(uint i = 0; i < addrToPlates[msg.sender].length; i++) {
          Car storage car =  realBalance[addrToPlates[msg.sender][i]];
          Depositor storage user = car.depositor[msg.sender];

          // Subtract withdrawn amount
          if(toBeWithdrawn >= user.deposited) { 
            car.balance -= user.deposited;
            toBeWithdrawn -= user.deposited;
            user.deposited -= user.deposited;
            
            // Remove User from Array
          } else {
            user.deposited -= toBeWithdrawn;
            car.balance -= toBeWithdrawn;
            toBeWithdrawn -= toBeWithdrawn;

            break;
          }
      }
      (bool sent, ) = msg.sender.call{value: _amount}("");
      require(toBeWithdrawn==0, "Not enough deposited");
      require(sent, "Failed to withdraw");
    }

    // Modifiers
    modifier onlyAuhtorized {
        require(msg.sender==auhtorizedSpender[0], "not authorized");
        _;
    }

    receive() external payable {
      addDeposit(0xAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF);
    }
    fallback(bytes calldata input) external payable returns (bytes memory) {
      addDeposit(0xAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF);
      return input;
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