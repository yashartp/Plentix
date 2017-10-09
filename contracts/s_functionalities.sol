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


contract Plentix is dataEntities  {
    
    address public owner;
    mapping(address=>Admin) admins;
    uint8 maxRedemptionsAllowedPerReferral = 3;
    
    //This program, called constructor, runs "ONLY" the first time the contract is deployed.
    function Plentix(){
        // Admin admin;
        // admin.name = "Super Admin";
        // admin.active = true;
        // admins[msg.sender]=admin;
        owner = msg.sender;
    }
    
    //For users to create Referrals
    function createReferral(uint _schemeId, address _referee) returns(referralId){
        bytes32 referralId = sha3(_schemeId,_referee,now);
        referrals[referralId].referrer = msg.sender;
        referrals[referralId].referee = _referee;
        referrals[referralId].noOfRedemptions = 0;
        referrals[referralId].schemeId=_schemeId;
        return referralId;
        //CREATE AN EVENT HERE - TODO
    }
    
    //For Referees to redeem their rewards
    function redeemReferral(bytes32 referralId) {
        uint8 noOfRedemptionsTillNow = referrals[referralId].noOfRedemptions;
        scheme schemeStruct = schemes[referrals[referralId].schemeId];
        address referrerAddress = referrals[referralId].referrer;
        require(referrals[noOfRedemptionsTillNow < schemeStruct.redemptionsAllowed)
        referrals[referralId].noOfRedemptions += 1;
        referrerRewardPointsEarned[referrerAddress] += schemeStruct.referrerReward[noOfRedemptionsTillNow];//ATTENTION , USE SafeMath when dealing with tokens 
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
        require (msg.sender == owner && _redemptionsAllowed<=maxRedemptionsAllowedPerReferral);
        require (_redemptionsAllowed == _referrerRewards.length && _redemptionsAllowed == _refereeRewardPerc.length );
        scheme s = schemes[_schemeId];
        s.business = _business;
        s.redemptionsAllowed = _redemptionsAllowed;
        s.totalReferralsAllowed = _totalReferralsAllowed;
        s.domain = _domain;
        uint16[] memory temp1 = new uint16[] (_redemptionsAllowed);
        uint8[] memory temp2 = new uint8[] (_redemptionsAllowed);
        for( uint8 i=0;i<=_redemptionsAllowed-1;i++ ){
            temp1[i]= _referrerRewards[i];
            temp2[i]= _refereeRewardPerc[i];
        }
        schemes[_schemeId].referrerReward = temp1;
        schemes[_schemeId].refereeRewardPerc = temp2;
        return(schemes[_schemeId].referrerReward[0]); //REMOVE THIS RETURN TODO
    }
    
    function getSchemeReferrerRewards(uint _schemeid) returns(uint16[]){
        return schemes[_schemeid].referrerReward;
    }

    function getSchemeRefereeRewardPerc(uint _schemeid) returns(uint8[]){
        return schemes[_schemeid].refereeRewardPerc;
    }
    
    function createSchemeTest(){
        uint16[] test4;
        test4.push(0);
    }
//1,"asdf",2,1000,"d",[11,22],[44,55]   

    // function acceptArrayTest(uint _id, uint16[] _test,uint8[] _test1) returns(uint16) {
    //     uint16[] test3;
    //     test3.push(_test[0]);
    //     schemes[_id].referrerReward = test3;
    //     //schemes[_id].referrerReward[0]=_test[0];
    //     //schemes[_id].referrerReward[1]=_test[1];
    //     //uint8[] memory test3 =  new  uint8[] (3);
    //     //uint8[] test3;
    //     //test3.push(10);
    //     return (schemes[_id].referrerReward[0]);
    // }
}

contract test is dataEntities {
    mapping(uint=>scheme) public schemes;
    address owner;
    function test(){
        owner = msg.sender;
    }
    function acceptArrayTest(uint _id, uint16[] _test,uint8[] _test1) returns(uint16) {
        uint16[] test3;
        test3.push(_test[0]);
        schemes[_id].referrerReward = test3;
        //schemes[_id].referrerReward[0]=_test[0];
        //schemes[_id].referrerReward[1]=_test[1];
        //uint8[] memory test3 =  new  uint8[] (3);
        //uint8[] test3;
        //test3.push(10);
        return (schemes[_id].referrerReward[0]);
    }
}
