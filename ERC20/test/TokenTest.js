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
        });
    });

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

    it('Valite transfer function',function(){
        return MTToken.deployed().then(function(instance){
            tokenInstance = instance;
            return tokenInstance.transfer.call(accounts[1],9999999);
        }).then(assert.fail).catch(function(error){
            assert(error.message.indexOf('Insufficient') >=0, 'Insufficient Balance check failed' );
            return tokenInstance.transfer.call(accounts[1],1,{from: accounts[0]});
        }).then(function(success) {
            assert.equal(success, true, 'it returns true');
            return tokenInstance.transfer(accounts[1], 1, { from: accounts[0] });
        }).then(function(receipt){
            assert.equal(receipt.logs.length, 1, 'triggers one event');
            assert.equal(receipt.logs[0].event, 'Transfer', 'should be the "Transfer" event');
            assert.equal(receipt.logs[0].args.from, accounts[0], 'logs the account the tokens are transferred from');
            assert.equal(receipt.logs[0].args.to, accounts[1], 'logs the account the tokens are transferred to');
            assert.equal(receipt.logs[0].args.tokens, 1, 'logs the transfer amount');
            return tokenInstance.balanceOf(accounts[1]);
        }).then(function(balance){
            assert.equal(balance.toNumber(),1,'Invalid Balance');
            return tokenInstance.balanceOf(accounts[0]);
        }).then(function(balance){
            assert.equal(balance.toNumber(),9999,'Wrong Balance debited');
        });
    });

    it('approves tokens for delegated transfer', function() {
        return MTToken.deployed().then(function(instance) {
        tokenInstance = instance;
        return tokenInstance.approve.call(accounts[1], 20);
        }).then(function(success) {
        assert.equal(success, true, 'Approve is failed');
        return tokenInstance.approve(accounts[1], 20, { from: accounts[0] });
        }).then(function(receipt) {
        assert.equal(receipt.logs.length, 1, 'triggers one event');
        assert.equal(receipt.logs[0].event, 'Approval', 'should be the "Approval" event');
        assert.equal(receipt.logs[0].args.tokenOwner, accounts[0], 'Incorrect Owner Details');
        assert.equal(receipt.logs[0].args.spender, accounts[1], 'Incorrect Spender Details');
        assert.equal(receipt.logs[0].args.tokens, 20, 'Incorrect tokens');
        });
    });
});