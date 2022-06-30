const MTToken = artifacts.require("ERC20");

contract('MTToken', function(accounts){
    it('sets the total supply upon deployment', function(){
        return MTToken.deployed().then(function(instance){
            tokenInstance = instance;
            return tokenInstance.totalSupply();
        }).then(function(totalSupply){
            assert.equal(totalSupply.toNumber(),100000,'set total supply to 100,000')
        });
    });
})