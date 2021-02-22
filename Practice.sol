pragma solidity ^0.5.2;

contract MultiSig {
  address[] public approvers;
  uint public quorum;

  struct Transfer {
    uint id;
    uint amount;
    address payable to;
    uint approvals;
    bool sent
  }

  mapping(nextId => Transfer) transfers;
  uint public nextId;
  mapping(address => mapping(uint => bool)) approvals;

  constructor(
    address[] memory _approvers,
    uint _quorum
  ) 
  payable public
  {
    approvers = _approvers;
    quorum = _quorum;

  }

  function createTransfer(uint amount, address payable to) 
    external  onlyApprover()
    {
      transfers[nextId] = Transfer {
        nextId,
        amount,
        to,
        0,
        false
      };
      nextId++;
   }

   function sendTransfer(uint id) external onlyApprover(){
      require(transfers[id].sent == false, "The transfer has been sent");
      if(approvals[msg.sender][id] == false) {
        approvals[msg.sender][id] = true;
        transfers[id].approvals++;
      }

      if(transfers[id].approvals >= quorum) {
        uint amount = transfers[id].amount;
        address payable to = transfers[id].to;
        to.transfer(amount);
        transfers[id].sent = true;
        return;
      }
   }

   modifier onlyApprover(){
     bool allowed = false;
     for(uint i = 0; i < approvers.length; i++) {
       if(approvers[i] == msg.sender) {
         allowed = true;
       }
     }

     require(allowed == true, "Not allowed");
     _;
   }
}