pragma solidity ^0.4.15;

import './S_dataEntities.sol';

/** 
 * @Title DataEntities
 * @Author Sandeep Nailwal
 * @Dev Functionalities will have all the events in the system and related operations that can be performed on them. 
 */


/**
 * The main contract of the Plentix application . It will be central point for all blockchain interaction for our application
 */
// TODO - Put a function to retrieve redeemed percentage

contract Plentix is dataEntities  {
    
    address public owner;
    mapping(address=>Admin) admins;
    
    //This program, called constructor, runs "ONLY" the first time the contract is deployed.
    function Plentix(){
        // Admin admin;
        // admin.name = "Super Admin";
        // admin.active = true;
        // admins[msg.sender]=admin;
        owner = msg.sender;
    }
    
    //For users to create Referrals
    function createReferral(uint _schemeId, address _referee) returns(bytes32 referralId){
        require(referrerToReferee[msg.sender][_referee] != _schemeId && msg.sender!=_referee);
        referralId = keccak256(_schemeId,_referee,now); //Creating a unique id for this referral
        referrals[referralId].referrer = msg.sender; //assigning the referral
        referrals[referralId].referee = _referee; //assigning the referee
        referrals[referralId].noOfRedemptions = 0; // Initiatializing the num of redemptions
        referrals[referralId].schemeId = _schemeId; //assigning the schemeId to referral
        // TODO - SAVE it with referee and refferer and scheme if required
        //schemes[_schemeId].referrals[_referee]=referrals[referralsId];
        //refereeReferrals[]
        referrerToReferee[msg.sender][_referee]=_schemeId;
        refereeReferrals[_referee][_schemeId] = referralId;
        Referral(msg.sender,_referee,referralId);
        return referralId; //Returning the referralId to the dapp
    }
    
    function returnReferralIds_referee(uint _schemeId) constant returns(bytes32){
        return  refereeReferrals[msg.sender][_schemeId];
    }
    //For Referees to redeem their rewards
    function redeemReferral(uint _schemeId) returns(uint8) { //recieve referralId from redeemer
        bytes32 _referralId = refereeReferrals[msg.sender][_schemeId];
        referral ref = referrals[_referralId];
        uint8 noOfRedemptionsTillNow = ref.noOfRedemptions;
        scheme schemeStruct = schemes[ref.schemeId];
        address referrerAddress = ref.referrer;
        address refereeAddress = ref.referee;
        require(noOfRedemptionsTillNow < schemeStruct.redemptionsAllowed //Check whether the redemptions are still allowed/available
            && refereeAddress == msg.sender); //Check whether the redeemer is the actual referee
        referrals[_referralId].noOfRedemptions += 1; //update the number of redemptions
        referrerRewardPointsEarned[referrerAddress] += schemeStruct.referrerReward[noOfRedemptionsTillNow];//Update the referrers reward points . ATTENTION , USE SafeMath when dealing with tokens 
        return schemeStruct.refereeRewardPerc[noOfRedemptionsTillNow];
    }

    function referralDiscountAvailable(bytes32 _referralId) returns(uint8) { //recieve referralId from redeemer
        referral memory ref = referrals[_referralId];
        uint8 noOfRedemptionsTillNow = ref.noOfRedemptions;
        scheme schemeStruct = schemes[ref.schemeId];
        address referrerAddress = ref.referrer;
        address refereeAddress = ref.referee;
        require(noOfRedemptionsTillNow < schemeStruct.redemptionsAllowed //Check whether the redemptions are still allowed/available
            && refereeAddress == msg.sender); //Check whether the redeemer is the actual referee
        return schemeStruct.refereeRewardPerc[noOfRedemptionsTillNow];
    }

        // address business; //This will store the id of the business running the scheme. In the later stages when write the full application we will add the registration mechanism for business
        // uint8 redemptionsAllowed;
        // uint8 totalReferralsAllowed;
        // string domain;
        // uint8[] referrerReward; // The sequential rewards which referrer will get 
        // uint8[] refereeRewardPerc; // The sequential rewards which referee will get 
        // mapping(address=>referral) referrals;
    
    //For admin to create new schemes
    function createScheme( uint _schemeId,address _business,uint8 _redemptionsAllowed,uint16 _totalReferralsAllowed, string _domain,uint16[] _referrerRewards, uint8[] _refereeRewardPerc) returns(uint16){
        require (msg.sender == owner && _redemptionsAllowed<=maxRedemptionsAllowedPerReferral);//check whether the creater is admin/owner and check the configuration
        require (_redemptionsAllowed == _referrerRewards.length && _redemptionsAllowed == _refereeRewardPerc.length ); //Check whether arrays have equalent values for rewards as per no. of redemptions available
        //TODO Make sure this scheme ID is not already present
        scheme s = schemes[_schemeId]; //fetch scheme
        s.business = _business;
        s.redemptionsAllowed = _redemptionsAllowed;
        s.totalReferralsAllowed = _totalReferralsAllowed;
        s.domain = _domain;
        uint16[] memory temp1 = new uint16[] (_redemptionsAllowed); //create temp arrays to assign to scheme struct
        uint8[] memory temp2 = new uint8[] (_redemptionsAllowed);
        for( uint8 i=0;i<=_redemptionsAllowed-1;i++ ){ //fetch values from the input arrays
            temp1[i]= _referrerRewards[i];
            temp2[i]= _refereeRewardPerc[i];
        }
        schemes[_schemeId].referrerReward = temp1; //assign the temp arrays to the actual scheme struct object
        schemes[_schemeId].refereeRewardPerc = temp2;
        return(schemes[_schemeId].referrerReward[0]); //RETURN SCHEME ID TODO
    }
    
    function getSchemeReferrerRewards(uint _schemeid) constant returns(uint16[]){
        return schemes[_schemeid].referrerReward;
    }

    function getSchemeRefereeRewardPerc(uint _schemeid) constant returns(uint8[]){
        return schemes[_schemeid].refereeRewardPerc;
    }
}

