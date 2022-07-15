const MTToken = artifacts.require("ERC20");

module.exports = function (deployer) {
  deployer.deploy(MTToken,"Marz Token","MtZ",10000,2);
};


/* Commands to test in truffle

    -> truffle console: opens the console to run the commands

    -> ERC20.deployed().then(function(i){token=i;})

    -> token.address: to get the deployed token address

    -> token.totalSuply().then(function(s) {totalSuply = s;})

    -> totalSuply : get the initial tokens count


*/