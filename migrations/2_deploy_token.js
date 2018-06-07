var KanCoin = artifacts.require("./KanCoin.sol");
var launch = '0x';
module.exports = function(deployer) {
  deployer.deploy(KanCoin,launch);
};