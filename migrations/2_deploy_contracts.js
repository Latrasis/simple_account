var SimpleAccount = artifacts.require("./SimpleAccount.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleAccount);
  deployer.deploy(Payroll);
};
