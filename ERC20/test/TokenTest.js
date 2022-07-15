const MTToken = artifacts.require("ERC20");

contract('MTToken', function(accounts){
    var tokenInstance;
    it('sets the total supply upon deployment', function(){
        return MTToken.deployed().then(function(instance){
            tokenInstance = instance;
            return tokenInstance.totalSupply();
        }).then(function(totalSupply){
            assert.equal(totalSupply.toNumber(),10000,'set total supply to 10,000');
            return tokenInstance.balanceOf(accounts[0]);
        }).then(function(adminBalance){
            assert.equal(adminBalance.toNumber(),10000, "Owner Account was not funded/incorrect balance");
        });
    });
});