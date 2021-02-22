pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;

contract Voting {

  mapping(address => bool) public voters;
  mapping(uint => Ballot) public ballots;
  address public admin;
  uint public nextBallotId;

  struct Choice{
    uint id;
    string name;
    uint votes;
  }

  struct Ballot {
    uint id;
    string name;
    Choice[] choices;
    uint end;
  }

  constructor() public {
    msg.sender = admin;
  }

  function addVoters(address[] calldata _voters) external onlyAdmin() {
    for(uint i = 0; i < _voters.length; i++) {
      voters[_voters[i]] = true;
    }

  }

  function createBallot(
    string memory name,
    string[] memory choices,
    uint offset
  ) public  onlyAdmin() {
      ballots[nextBallotId].id =nextBallotId;
      ballots[nextBallotId].name = name;
      ballots[nextBallotId].end = now + offset;
      for(uint i = 0; i < choices.length; i++) {
        ballots[nextBallotId].choices.push(Choice(i, choice[i],0));
      }
  }


  modifier onlyAdmin() {
    require(msg.sender == admin, "not allowed");
    _;
  }
}