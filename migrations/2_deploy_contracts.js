var SimpleStorage = artifacts.require("SimpleStorage");
var CryptoBDC = artifacts.require("CryptoBDC");
var User = artifacts.require("User")

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(CryptoBDC, "Ede");
  deployer.deploy(User, "0");
};
