pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Campaign{
    address public manager;
    uint public totalSupply;
    string public name;
    string public DB_id;
    // string public deadline;
    
    constructor(address owner, string memory _name, uint _totalSupply) public {
        manager = owner;
        name = _name;
        totalSupply = _totalSupply;
        // DB_id = _DB_id;
        // deadline = _deadline;
    }
    
    // function contribute() public payable {
    //     require(msg.value > minimimContribution, "your contribution is less than the minimum amount!");
        
    // }

}