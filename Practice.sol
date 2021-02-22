pragma solidity ^0.5.2;

contract Escrow {
  address public lawyer;
  uint public amount;
  address payable public payer;
  address public payee;

  constructor(
    address payable _payer;
    address _payee;
    uint amount;
  ) public {
    msg.sender = lawyer;
    amount = _amount;
    payer = _payer;
    payee = _payee;
  }

  function deposit() payable public {
    require(msg.sender == payer, "must be payer");
    require(address(this).balance <= amount);
  }

  function withdraw() public {
    require(msg.sender == lawyer, "must be lawyer");
    require(address(this).balance == amount, "must be balance")
    payee.transfer(amount);
  }


  funciton balanceOf() view public returns(uint){
    return address(this).balance;
  }
}