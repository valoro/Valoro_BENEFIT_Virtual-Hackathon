pragma solidity ^0.5.0;
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

import "./EhsanAdmins.sol";

/** this contract should manage all type of ChrtyOrgs */
 
contract Registration   {
    enum Authorization {pending, rejected, approved, banned}
    EhsanAdmins public Admins;
    // CampaignFactory public factory;
    
    struct Organization {
        string license;
        string auditReport;
        string passport;
        string name;
       // string location;
       // string desc;
        string bankAccount;
        address cryptoAddress;
        Authorization status;
    }
    
    mapping(address => Organization) chrtyOrgs;
    
    event OrgJoinRequest(
        uint timeStamp,
        address sender
    );
        
    event AdminHandleOrgRequest(
        uint timeStamp,
        address sender,
        Authorization status,
        address orgAddress
    );
        
    constructor(EhsanAdmins _ehsanAdmin) public {
        Admins = _ehsanAdmin;
    }
    
    modifier onlyUnApprovedOrg(){
        require(!isOrg(msg.sender),"Org is already approved");
         _;
    }
    modifier onlyAdmin(){
        require(Admins.isEhsanAdmin(msg.sender),"Only admin can call this function");
         _;
    }
    modifier onlyUnbanned(){
        require(chrtyOrgs[msg.sender].status != Authorization.banned,"Organization is banned");
         _;
    }
    // modifier onlyApprovedOrg(address orgAddress){
    //     require(chrtyOrgs[orgAddress].status == Authorization.approved)
    //      _;
    // }
    
    // function setCampaignFactoryContract(CampaignFactory _factory) public onlyAdmin returns (bool){
    //     factory = _factory;
    //     return true;
    // }

    // function createNewAccount() public returns (bool) {// address owner , Registration _registration ,TokenFactory _factory ,IERC20 _attaToken
    //     address newUser = address(new UserWalletContract(msg.sender,Registration(address(this)),factory,attaToken));
    //     users[msg.sender] = newUser;
    //     return true;
    // } 
    
    function requestToApprove(
        string memory _license,
        string memory _auditReport,
        string memory _passport,
        string memory _name,
        // string calldata _location,
        // string calldata _desc,
        string memory _bankAccount,
        address _cryptoAddress) public onlyUnbanned onlyUnApprovedOrg returns(bool) {
            chrtyOrgs[msg.sender] = Organization({
                license: _license,
                auditReport: _auditReport,
                passport: _passport,
                name: _name,
                // location: _location,
                // desc: _desc,
                bankAccount: _bankAccount,
                status: Authorization.pending,
                cryptoAddress: _cryptoAddress});

        emit OrgJoinRequest(now, msg.sender);
        
        return true;
        }
        
    function approveChrtyOrg(address orgAddress) public onlyAdmin onlyUnApprovedOrg returns (bool) {
       chrtyOrgs[orgAddress].status = Authorization.approved;
       emit AdminHandleOrgRequest(now, msg.sender, chrtyOrgs[orgAddress].status, orgAddress);
       return true;
   }

// TODO :  need to think in whether we have to manage org request on chain or off chain
    function rejectChrtyOrg(address orgAddress) public onlyAdmin returns (bool) {
       chrtyOrgs[orgAddress].status = Authorization.rejected;
       emit AdminHandleOrgRequest(now, msg.sender, chrtyOrgs[orgAddress].status, orgAddress);
       return true;
   }
   
   function banChrtyOrg(address orgAddress) public onlyAdmin returns(bool){
       chrtyOrgs[orgAddress].status = Authorization.banned;
       emit AdminHandleOrgRequest(now, msg.sender, chrtyOrgs[orgAddress].status, orgAddress);
       return true;
   }
   
   function getOrgRequest(address orgAddress)
   public view onlyAdmin returns(string memory,string memory,string memory, string memory,/* string memory, string memory,*/ string memory, Authorization, address){
       return (
           chrtyOrgs[orgAddress].license,
           chrtyOrgs[orgAddress].auditReport,
           chrtyOrgs[orgAddress].passport,
           chrtyOrgs[orgAddress].name,
           // chrtyOrgs[orgAddress].location,
           // chrtyOrgs[orgAddress].desc,
           chrtyOrgs[orgAddress].bankAccount,
           chrtyOrgs[orgAddress].status,
           chrtyOrgs[orgAddress].cryptoAddress
        );
   }
   
   function getOrgAccount(address orgAddress) public view returns(string memory/*,string memory,string memory*/,string memory, address) {
       return(
           chrtyOrgs[orgAddress].name,
           // chrtyOrgs[orgAddress].location,
           // chrtyOrgs[orgAddress].desc,
           chrtyOrgs[orgAddress].bankAccount,
           chrtyOrgs[orgAddress].cryptoAddress
        );
   }
  
   function getOrgAuthority(address orgAddress) public view returns(Authorization) {
      return chrtyOrgs[orgAddress].status;
   }
   
   function isOrg(address orgAddress) public view returns (bool){
       return chrtyOrgs[orgAddress].status == Authorization.approved;
   }
}