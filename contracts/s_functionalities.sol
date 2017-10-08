pragma solidity ^0.4.17;

import './S_dataEntities.sol';

/** 
 * @Title DataEntities
 * @Author Sandeep Nailwal
 * @Dev Functionalities will have all the events in the system and related operations that can be performed on them. 
 */


/**
 * The main contract of the Plentix application . It will be central point for all blockchain interaction for our application
 */


contract Plentix {
    
    mapping(address=>Admin) admins;
    function Plentix(){
        Admin admin;    
    }
    
    //For users to create Referrals
    function createReferral(){
        
    }
    
    //For Referees to redeem their rewards
    function redeemReferral(); {
        
    }
    
    //For admin to create new schemes
    function createScheme() {
        
    }
    
}
