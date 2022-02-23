// Import Web3 JS library
const Web3 = require('web3');

// Import the ABI definition of the DemoContract
const artifact = require('../../build/contracts/Charity.json');

const contractAddress = '0x8F44B131B11a4aEA5D698B369CcD4bE90bbd9782';

const App = {
    web3: null,
    contractInstance: null,
    accounts: null,

    start: async function() {
        const { web3 } = this;
        // Get the accounts
        this.accounts = await web3.eth.getAccounts();

        console.log(this.accounts);

        this.contractInstance = new web3.eth.Contract(
            artifact.abi,
            contractAddress
        );
    },

    getOrganization: async function() {
        const OrganizationId = document.getElementById('getOrgId').value;
        const data = await this.contractInstance.methods.getOrganization(OrganizationId).call();
        const arr = Object.values(data);
        const str =  "Organization ID : " + arr[0] + ", Organization Name : " + arr[1] + ", Organization Aim : " + arr[2] + ", Organization Website : " + arr[3] + ", Balance : " + arr[4] + ", Donations Recieved : " + arr[5];
        console.log(str);
        document.getElementById("writeDetails").innerHTML = str;
    },


    getAllOrganizations: async function() {
        const data = await this.contractInstance.methods.getAllOrganizations().call();

        var result = "<table border=1><tr><th>Organization ID</th><th>Organization Name</th><th>Organization Aim</th><th>Organization Website</th><th>Balance</th><th>Donated Amount</th></tr>";
        for(var i=0; i<data.length; i++) {
            result += "<tr>";
            for(var j=0; j<data[i].length; j++){
                result += "<td>"+data[i][j]+"</td>";
            }
            result += "</tr>";
        }
        result += "</table>";

        document.getElementById('printOrgs').innerHTML = result;
        
    },

    getDonor: async function() {
        const DonorId = document.getElementById('getDonDet').value;
        const data = await this.contractInstance.methods.getDonor(DonorId).call();
        const arr = Object.values(data);
        const str = "Donor ID : " + arr[0] + ", Donor Name : "+ arr[1];
        document.getElementById('writeDonDetails').innerHTML = str;
    },

    getAllDonors: async function() {
        const data = await this.contractInstance.methods.getAllDonors().call();

        var result = "<table border=1><tr><th>Donor ID</th><th>Donor Name</th></tr>";
        for(var i=0; i<data.length; i++) {
            result += "<tr>";
            for(var j=0; j<data[i].length; j++){
                result += "<td>"+data[i][j]+"</td>";
            }
            result += "</tr>";
        }
        result += "</table>";

        document.getElementById('printDonors').innerHTML = result;

    },
    
    getAllDonations: async function(){
        const data = await this.contractInstance.methods.getAllDonations().call();

        var result = "<table border=1><tr><th>Transaction ID</th><th>Donor ID</th><th>Organization ID</th><th>Donated Amount</th></tr>";
        for(var i=0; i<data.length; i++) {
            result += "<tr>";
            for(var j=0; j<data[i].length; j++){
                result += "<td>"+data[i][j]+"</td>";
            }
            result += "</tr>";
        }
        result += "</table>";

        document.getElementById('writeAllDon').innerHTML = result;
    },

    getAllWithdrawals: async function(){
        const data = await this.contractInstance.methods.getAllWithdrawals().call();

        var result = "<table border=1><tr><th>Transaction ID</th><th>Organization ID</th><th>Withdrawed Amount</th><th>Use of Amount</th><th>Vendor Name</th><th>Vendor Address</th></tr>";
        for(var i=0; i<data.length; i++) {
            result += "<tr>";
            for(var j=0; j<data[i].length; j++){
                result += "<td>"+data[i][j]+"</td>";
            }
            result += "</tr>";
        }
        result += "</table>";

        document.getElementById('writeAllWith').innerHTML = result;

    },

    setOrganization: async function() {
        const OrganizationId = document.getElementById('orgId').value;
        const OrganizationName = document.getElementById('orgName').value;
        const OrganizationAim = document.getElementById('orgAim').value;
        const OrganizationWebsite = document.getElementById('orgWeb').value;
        const OrganizationBalance = document.getElementById('orgBal').value;

        console.log(OrganizationId + " " + OrganizationName + " " + OrganizationAim + " " + OrganizationWebsite + " " + OrganizationBalance);

        await this.contractInstance.methods.setOrganization(OrganizationId, OrganizationName, OrganizationAim, OrganizationWebsite, OrganizationBalance).send({from : this.accounts[9], gas:6721975});

        

    },

    setDonor: async function() {
        const DonorId = document.getElementById('donId').value;
        const DonorName = document.getElementById('donName').value;

        console.log(DonorId + " " + DonorName);

        await this.contractInstance.methods.setDonor(DonorId, DonorName).send({from: this.accounts[4], gas:6721975});

    },

    registerDonations: async function() {
        const DonorId = document.getElementById('donDonId').value;
        const OrganizationId = document.getElementById('donOrgId').value;
        const DonatedAmt = document.getElementById('donAmt').value;

        console.log(DonorId + " " + OrganizationId + " " + DonatedAmt);

        await this.contractInstance.methods.makeDonation(DonorId, OrganizationId, DonatedAmt).send({from: this.accounts[2], gas:6721975});
    },

    registerWithdrawals: async function() {
        const OrganizationId = document.getElementById('withOrgId').value;
        const WithdrawAmt = document.getElementById('withAmt').value;
        const UseofAmt = document.getElementById('withUse').value;
        const VendorName = document.getElementById('withVenName').value;
        const VendorAdd = document.getElementById('withVenAdd').value; 

        console.log(OrganizationId + " " + WithdrawAmt + " " + UseofAmt + " " + VendorName + " " + VendorAdd);

        await this.contractInstance.methods.makeWithDrawal(OrganizationId, WithdrawAmt, UseofAmt, VendorName, VendorAdd).send({from: this.accounts[3], gas:6721975});
    }
}

window.App = App;

window.addEventListener("load", function() {
    App.web3 = new Web3(
      new Web3.providers.HttpProvider("http://127.0.0.1:7545"),
    );

  App.start();
});