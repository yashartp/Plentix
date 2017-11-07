pragma solidity ^0.4.17;

/** 
 * @Title DataEntities
 * @Author Steve French
 * @Dev DataEntities will have all the actors, data elements in the system and related operations that can be performed on them. 
 */


/**
 * Admins will be the persons who would be able to change the critical configurations in the system. 
 * At the start, the constructor of the primary contract will set the contract deployer as the admin
 */


contract dataEntities{ 

/**
 * Admins will be the persons who would be able to change the critical configurations in the system. 
 * At the start, the constructor of the primary contract will set the contract deployer as the admin
 */

    struct Admin {
       string name;
       bool active;
    }

    mapping(address=>Admin) public admins;
/**
 * A user is a generic type for both referrer and referee as a single person can be both
 */
    
    struct user {
        string name;
        referral[] reffered; // it will store the refferals a particular user did
        referral[] gotReffered; // it will store the refferals which this user got reffered by
    }



/**
 * Scheme is the central datatype which will store the terms and conditions of a particular referral scheme
 */
    
    struct scheme {
        address business; //This will store the id of the business running the scheme. In the later stages when write the full application we will add the registration mechanism for business
        uint8 redemptionsAllowed; //redemptions allowed per referral to referee
        uint16 totalReferralsAllowed;
        string domain;
        uint16[] referrerReward; // The sequential rewards which referrer will get 
        uint8[] refereeRewardPerc; // The sequential rewards which referee will get 
        mapping(address=>referral) referrals;
    }
    
    mapping(uint=>scheme) public schemes;
    
    /**
 * A referral is an event of a user actually referring other user from front end
 */
       
    struct referral {
        address referrer;
        address referee;
        uint8 noOfRedemptions; //We should be able to know how many redemptions have beeen made against this referral. Basis this number we will define the rewards given to the referrer and referee
        uint schemeId;
    }
    
    mapping(bytes32=>referral) referrals;
    mapping(address=>uint)=> referrerRewardPointsEarned;
}
