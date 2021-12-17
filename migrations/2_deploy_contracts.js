var AkatherToken = artifacts.require("./AkatherToken.sol");
var AkatherReward = artifacts.require("./AkatherReward.sol");
module.exports = async function(deployer) {
  await deployer.deploy(AkatherToken);
  await deployer.deploy(AkatherReward,AkatherToken.address);
};
