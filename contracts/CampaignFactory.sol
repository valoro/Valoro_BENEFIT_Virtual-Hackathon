pragma solidity ^0.5.0;

import "./Registration.sol";
import "./Campaign.sol";

contract CampaignFactory {
    mapping (address => address[]) deployedCampaigns;
    Registration public EhsanRegistration;
    
    constructor(Registration _ehsanRegistration) public {
        EhsanRegistration = _ehsanRegistration;
    }
    
    modifier onlyApprovedOrg(){
        require(EhsanRegistration.isOrg(msg.sender), "Organization not approved");
        _;
    }
    
    function createCampaign(string memory name, uint totalSupply) public onlyApprovedOrg returns (address){
        address newCampaign = address (new Campaign(msg.sender, name, totalSupply));
        deployedCampaigns[msg.sender].push(newCampaign);
        return newCampaign;
    }
    
    function getDeployedCampaigns(address Organization) public onlyApprovedOrg view returns (address[] memory) {
        return deployedCampaigns[Organization];
    }
}
