pragma solidity ^0.5.2;

contract Escrow {
  address public payer;
  address payable public payee;
  address public lawyer;
  uint public amount;

  constructor(
    address _payer;
    address payable _payee;
    uint _amount;
  ) payable public {
    msg.sender = lawyer;
    payer = _payer;
    payee = _payee;
    amount = _amount;
  }

  function deposit() payable public{
    require(msg.sender == payer, "must be payer");
    require(address(this).balance <= amount, "must be equal or superior de amount");
  }

  function release() public {
    require(msg.sender == lawyer, "must be lawyer");
    require(address(this).balance == amount, "cannot be released");
    payee.transfer(amount);
      }

  function balanceOf() view public returns(uint){
    return address(this).balance;
  }
}