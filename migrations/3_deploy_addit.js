var Addit = artifacts.require("Addit");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(Addit);
};
