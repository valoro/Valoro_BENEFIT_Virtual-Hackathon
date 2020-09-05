pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/access/Roles.sol";

contract EhsanAdmins {
  using Roles for Roles.Role;

  event EhsanAdminAdded(address indexed account);
  event EhsanAdminRemoved(address indexed account);

  Roles.Role private EhsanAdmin;

  constructor() public { 
    _addEhsanAdmin(msg.sender);
  }

  modifier onlyEhsanAdmin() {
    require(isEhsanAdmin(msg.sender),"Only admin can call this function");
    _;
  }

  function isEhsanAdmin(address account) public view returns (bool) {
    return EhsanAdmin.has(account);
  }

  function addEhsanAdmin(address account) public onlyEhsanAdmin   returns (bool){
    _addEhsanAdmin(account);
    return true;
  }

  function renounceEhsanAdmin() public {
    _removeEhsanAdmin(msg.sender);
  }

  function _addEhsanAdmin(address account) internal {
    EhsanAdmin.add(account);
    emit EhsanAdminAdded(account);
  }

  function _removeEhsanAdmin(address account) internal {
    EhsanAdmin.remove(account);
    emit EhsanAdminRemoved(account);
  }
}
