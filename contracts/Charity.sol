// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Charity
{
    address owner = 0xd0C5650F2033C662100ea38Fdb69aCc763B1367e;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    //Organization structure
    uint transactionIDDonations = 1;
    uint transactionIDWithdrawal = 1;
    struct organization
    {
        string orgID;
        string orgName;
        string aim;
        string website;
        uint balance;
        uint donationsRecieved;
    }

    mapping(string => organization) OrganizationsMap;
    organization[] organizationArray;

    // Donor structure

    struct donor
    {
        string donorID;
        string donorName;
    }

    mapping(string => donor) DonorsMap;
    donor[] donorArray;

    //Donations structure

    struct donations
    {
        uint tranID;
        string donorID;
        string organizationID;
        uint donatedAmount;
    }

    mapping(uint => donations) DonationsMap;
    donations[] donationTransactions;

    //Withdraw structure

    struct withdrawal
    {
        uint tranID;
        string orgID;
        uint withdrawalAmount;
        string vendorName;
        string vendorAddress;
        string useofAmount;
    }

    mapping (uint => withdrawal) WithDrawalMap;
    withdrawal[] withdrawalTransactions;

    //Set Organization

    function setOrganization(
        string memory _orgID, 
        string memory _orgName, 
        string memory _aim, 
        string memory _website,
        uint _balance)
        public 
        onlyOwner{
            require(
        keccak256(abi.encodePacked((OrganizationsMap[_orgID].orgID)))
                    !=
        keccak256(abi.encodePacked(_orgID)), "Organization already exists"); 

            organization memory newOrg = organization(_orgID, _orgName, _aim, _website, _balance, 0);

            OrganizationsMap[_orgID] = organization(_orgID, _orgName, _aim,_website, _balance, 0);
            organizationArray.push(newOrg);
        }

    //Get Organization

    function getOrganization(string memory _orgID) public view returns(string memory, string memory, string memory,string memory, uint, uint)
    {
        require(keccak256(abi.encodePacked((OrganizationsMap[_orgID].orgID)))
                    ==
        keccak256(abi.encodePacked(_orgID)), "Organization does not exist");
        return ( OrganizationsMap[_orgID].orgID, OrganizationsMap[_orgID].orgName, OrganizationsMap[_orgID].aim,OrganizationsMap[_orgID].website, OrganizationsMap[_orgID].balance, OrganizationsMap[_orgID].donationsRecieved);
    }

    //Get all Organizations

    function getAllOrganizations()public view returns(organization[] memory){

        return organizationArray;
    }

    //Set Donor

    function setDonor(string memory _donorID, string memory _donorName)public{

        require(
        keccak256(abi.encodePacked((DonorsMap[_donorID].donorID)))
                    !=
        keccak256(abi.encodePacked(_donorID)), "Donor already exists"); 

        donor memory newDonor = donor(_donorID, _donorName);
        DonorsMap[_donorID] = newDonor;
        donorArray.push(newDonor);
    }

    //Get Donor

    function getDonor(string memory _donorID)public view returns(string memory, string memory)
    {
        require(keccak256(abi.encodePacked((DonorsMap[_donorID].donorID)))
                    ==
        keccak256(abi.encodePacked(_donorID)), "Donor does not exist");
        return (DonorsMap[_donorID].donorID, DonorsMap[_donorID].donorName);
    }

    //Get all donors
    function getAllDonors() public view returns(donor[] memory)
    {
        return donorArray;
    }


    // Make Donations

    function makeDonation(string memory _donorID, string memory _orgID, uint _donatedAmount)public {

        require(
             (keccak256(abi.encodePacked((DonorsMap[_donorID].donorID)))
                    ==
        keccak256(abi.encodePacked(_donorID)) && keccak256(abi.encodePacked((OrganizationsMap[_orgID].orgID)))
                    ==
        keccak256(abi.encodePacked(_orgID))), "Wrong donor ID or wrong organization ID"); 

        
        DonationsMap[transactionIDDonations] = donations(transactionIDDonations, _donorID, _orgID, _donatedAmount);
        OrganizationsMap[_orgID].balance += _donatedAmount;
        OrganizationsMap[_orgID].donationsRecieved += _donatedAmount;


        for(uint i = 0;i < organizationArray.length; i++)
        {
            if(keccak256(abi.encodePacked(OrganizationsMap[_orgID].orgID))
                    ==
            keccak256(abi.encodePacked(organizationArray[i].orgID)))
            {
                organizationArray[i].balance = OrganizationsMap[_orgID].balance;
                organizationArray[i].donationsRecieved = OrganizationsMap[_orgID].donationsRecieved;
            }
        }

        donations memory newDonation = donations(transactionIDDonations, _donorID, _orgID, _donatedAmount);
        donationTransactions.push(newDonation);

        transactionIDDonations += 1;
        
    }

    // Withdrawal function

    function makeWithDrawal(string memory _orgID, uint _withDrawalAmount, string memory _useofAmount, string memory _vendorName, string memory _vendorAddress)public {

    require(keccak256(abi.encodePacked((OrganizationsMap[_orgID].orgID)))
                    ==
        keccak256(abi.encodePacked(_orgID)), "Wrong organization ID");

    require(OrganizationsMap[_orgID].balance >= _withDrawalAmount, "No sufficient amount");

    WithDrawalMap[transactionIDWithdrawal] = withdrawal(transactionIDWithdrawal, _orgID, _withDrawalAmount, _vendorName, _vendorAddress, _useofAmount);
    OrganizationsMap[_orgID].balance -= _withDrawalAmount;

    for(uint i = 0;i < organizationArray.length; i++)
    {
        if(keccak256(abi.encodePacked(OrganizationsMap[_orgID].orgID))
                ==
        keccak256(abi.encodePacked(organizationArray[i].orgID)))
        {
            organizationArray[i].balance = OrganizationsMap[_orgID].balance;
        }
    }

    withdrawal memory newWithdrawal = withdrawal(transactionIDWithdrawal, _orgID, _withDrawalAmount, _vendorName, _vendorAddress, _useofAmount);
    withdrawalTransactions.push(newWithdrawal);

    transactionIDWithdrawal += 1;
    }
    // Get all donations

    function getAllDonations() public view returns(donations[] memory)
    {
        return donationTransactions;
    }

    //Get all withdrawals

    function getAllWithdrawals() public view returns(withdrawal[] memory)
    {
        return withdrawalTransactions;
    }

}