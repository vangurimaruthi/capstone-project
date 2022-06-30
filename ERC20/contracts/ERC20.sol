// SPDX-License-Identifier: Maruthi Vanguri
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20{

    string tokenName;
    string tokenSymbol;
    uint256 totalTokens;
    uint8 decimal;
    address owner;

    //constructor(string memory _name, string memory _Symbol, uint256 _supply, uint8 _decimal){
    constructor(){
        tokenName = "Marz Token";
        tokenSymbol = "MtZ";
        totalTokens = 100000;
        decimal = 2;
        owner = msg.sender;
    }

    function name() public view returns (string memory){
        return(tokenName);
    }

    function symbol() public view returns(string memory){
        return(tokenSymbol);
    }

    function decimals() public view returns(uint8){
        return(decimal);
    }
    
    function totalSupply() public view returns(uint256){
        return(totalTokens);
    }


}
