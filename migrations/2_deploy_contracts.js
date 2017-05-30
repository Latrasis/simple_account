var SimpleAccount = artifacts.require("./SimpleAccount.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleAccount);
};
