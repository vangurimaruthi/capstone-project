const MTToken = artifacts.require("ERC20");

contract('MTToken', function(accounts){
    var tokenInstance;
    it('Checks token details', function(){
        return MTToken.deployed().then(function(instance){
            tokenInstance =  instance;
            return tokenInstance.name();
        }).then(function(name){
            assert.equal(name,'Marz Token','Invalid Token Name');
            return tokenInstance.symbol();
        }).then(function(symbol){
            assert.equal(symbol,'MtZ','Invlid symbol');
            return tokenInstance.decimals();
        }).then(function(decimal){
            assert.equal(decimal.toNumber(),2,'Decimal number is not valid')
        })
    })

    it('Valite transfer function',function(){
        return MTToken.deployed().then(function(instance){
            tokenInstance = instance;
            return tokenInstance.transfer.call(accounts[1],9999999);
        }).then(assert.fail).catch(function(error){
            assert(error.message.indexOf('Insufficient') >=0, 'Insufficient Balance check failed' );
        })
    })


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