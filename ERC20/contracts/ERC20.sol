// SPDX-License-Identifier: Maruthi Vanguri
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20{

    string tokenName;
    string tokenSymbol;
    uint256 totalTokens;
    uint256 remainingTokens;
    uint8 decimal;
    address owner;

    mapping(address => uint256) internal balances;
    mapping(address => mapping(address => uint256)) internal allowanceOf;

    constructor(string memory _name, string memory _Symbol, uint256 _supply, uint8 _decimal){
    //constructor(){
        tokenName = _name;
        tokenSymbol = _Symbol;
        totalTokens = _supply;
        decimal = _decimal;
        balances[msg.sender]=_supply;
        owner = msg.sender;
    }

    function name() public override view returns (string memory){
        return(tokenName);
    }

    function symbol() public override view returns(string memory){
        return(tokenSymbol);
    }

    function decimals() public override view returns(uint8){
        return(decimal);
    }
    
    function totalSupply() public override view returns(uint256){
        return(totalTokens);
    }

    function balanceOf(address _accountAddress) public override view returns(uint256){
        require(_accountAddress != address(0),"Invalid Address");
        return(balances[_accountAddress]);
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns(bool){
        require(_to != address(0),"Invalid Address to receive");
        require(_from != address(0),"Invalid Address to send");
        require(_value <= balances[_from],"Insufficient Balance" );
        require(_value <= allowanceOf[_from][msg.sender],"Not authorized to send requested amount");
        balances[_from] -= _value;
        balances[_to] += _value;
        allowanceOf[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public override returns(bool){
        require(_to != address(0),"Invalid Address to receive");
        require(msg.sender != address(0),"Invalid Address to send");
        require(_value <= balances[msg.sender],"Insufficient Balance" );
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public override returns (bool) {
        allowanceOf[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _tokenOwner, address _spender) public override view returns (uint256) {
        return allowanceOf[_tokenOwner][_spender];
    }
}
