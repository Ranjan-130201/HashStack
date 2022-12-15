var Access = artifacts.require("Access.sol");

module.exports = function(deployer) {
    const artifact = require("../build/contracts/MultiSig.json");
    address = artifact.networks[5].address;
  // deployment steps
  deployer.deploy(Access,address);
  console.log(address);
};