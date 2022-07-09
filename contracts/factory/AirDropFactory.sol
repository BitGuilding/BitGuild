// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../airdrop/airdrop.sol";
import "../airdrop/airdropbyowner.sol";

contract AirDropFactory {
    

    address public admin;
    address public tokenaddress;
    uint public fee;
    mapping(address => address[]) public _AIRDROP_REGISTRY_1;
     mapping(address => address[]) public _AIRDROP_REGISTRY_2;
   
    // ============ Events ============

    event NewAirDrop(address erc20, address creator, bool isMintable);
    event AdminChange(address indexed Admin, address indexed newAdmin);


    constructor(address _token,uint256 _fee)  public {
        admin = msg.sender;
        tokenaddress = _token;
        fee = fee;
    }
    
    modifier  _isOwner() {
        require(msg.sender == admin);
        _;
    }
    function changeOwner(address manager) external _isOwner {
        admin = manager;
        emit AdminChange(msg.sender,manager);
    }
    function changefee(address _token,uint256 _fee) external _isOwner {
        tokenaddress = _token;
        fee = fee;
    }
     function createAirDrop(address manager, address _token) external returns (address ) {
        address _airdrop = address (new airdrop(manager,_token));
        _AIRDROP_REGISTRY_1[msg.sender].push(_airdrop);
        IERC20(tokenaddress).transfer(admin,fee);
        emit NewAirDrop(_airdrop, msg.sender, false);
        return _airdrop;
    }
    
    function createAirDropByOwner(address manager, address _token,uint256 _time) external returns (address ) {
        address _airdrop =address (new airdropbyowner(manager,_token,_time));
        _AIRDROP_REGISTRY_2[msg.sender].push(_airdrop);
        IERC20(tokenaddress).transfer(admin,fee);
        emit NewAirDrop(_airdrop, msg.sender, false);
        return _airdrop;
    }
   function getRegistry1(address user) public view returns (address[] memory )
    {
        return _AIRDROP_REGISTRY_1[user];
    }
    function getRegistry2(address user) public view returns (address[] memory )
    {
        return _AIRDROP_REGISTRY_2[user];
    }
}
