pragma solidity ^0.5.2;

contract MultiSig {
    address[] public approvers;
    uint public quorum;
    struct Transfer {
        uint id;
        uint amount;
        address payable to;
        uint approvals;
        bool sent;
    }
    
    mapping(uint => Transfer) transfers;
    uint nextId;
    
    constructor(address[] memory _approvers, uint _quorum) 
        public payable
        {
            approvers = _approvers;
            quorum = _quorum;
        }
    
    function createTransfer(address payable to, uint amount) 
        external
        {
            transfers[nextId] = Transfer(
                nextId,
                amount,
                to,
                0,
                false
            );
            nextId++;
        }
}

