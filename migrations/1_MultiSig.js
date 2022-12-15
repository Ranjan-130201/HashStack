var MultiSig = artifacts.require("MultiSig.sol");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MultiSig);
};