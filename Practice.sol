pragma solidity ^0.5.0;

contract Deed {
    address public lawyer;
    address payable public beneficiary;
    uint public earliest;
    uint public paidPayouts;
    uint constant public PAYOUTS = 10;
    uint constant public INTERVAL = 10;
    
    constructor(
        address _lawyer,
        address payable _beneficiary,
        uint fromNow)
        payable
        public {
            lawyer = _lawyer;
            beneficiary = _beneficiary;
            earliest = now + fromNow;
            amount = msg.value / PAYOUTS;
        }
        
    function withdraw() public {
        require(msg.sender == beneficiary, 'lawyer only');
        require(now >= earliest, "too early");
        require(paidPayouts < PAYOUTS);
        uint elligiblePayouts = (now - earliest) / INTERVAL;
        beneficiary.transfer(elligiblePayouts * amount);
    }
}