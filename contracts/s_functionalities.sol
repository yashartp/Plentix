pragma solidity ^0.4.17;

import './S_dataEntities.sol';

/** 
 * @Title DataEntities
 * @Author Steve French
 * @Dev Functionalities will have all the events in the system and related operations that can be performed on them. 
 */


/**
 * The main contract of the Plentix application . It will be central point for all blockchain interaction for our application
 */


contract Plentix is dataEntities  {
    
    address public owner;
    mapping(address=>Admin) admins;
    uint8 maxRedemptionsAllowedPerReferral = 3;
    
    //Constructor, runs "ONLY" the first time the contract is deployed.
    function Plentix(){
        // Admin admin;
        // admin.name = "Super Admin";
        // admin.active = true;
        // admins[msg.sender]=admin;
        owner = msg.sender;
    }
    
    //For users to create Referrals
    function createReferral(uint _schemeId, address _referee) returns(bytes32 referralId){
        referralId = keccak256(_schemeId,_referee,now); //Creating a unique id for this referral
        referrals[referralId].referrer = msg.sender; //assigning the referral
        referrals[referralId].referee = _referee; //assigning the referee
        referrals[referralId].noOfRedemptions = 0; // Initiatializing the num of redemptions
        referrals[referralId].schemeId=_schemeId; //assigning the schemeId to referral
        return referralId; //Returning the referralId to the dapp
        //CREATE AN EVENT HERE - TODO
    }
    
    //For Referees to redeem their rewards
    function redeemReferral(bytes32 _referralId) returns(uint8) { //recieve referralId from redeemer
        referral memory ref;
        uint8 noOfRedemptionsTillNow = ref.noOfRedemptions;
        scheme schemeStruct = schemes[ref.schemeId];
        address referrerAddress = ref.referrer;
        address refereeAddress = ref.referee;
        require(noOfRedemptionsTillNow < schemeStruct.redemptionsAllowed //Check whether the redemptions are still allowed/available
            && refereeAddress == msg.sender); //Check whether the redeemer is the actual referee
        ref.noOfRedemptions += 1; //update the number of redemptions
        referrerRewardPointsEarned[referrerAddress] += schemeStruct.referrerReward[noOfRedemptionsTillNow];//Update the referrers reward points . ATTENTION , USE SafeMath when dealing with tokens 
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



// Test code for checking various variable use strategies. IGNORE IT
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
