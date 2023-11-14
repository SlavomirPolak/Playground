/**
 * @description Selector class for Profile object
 */
public with sharing class NN_ProfileSelector {
    
    /**
     * @description select Profile Id by Profile name
     * @param  profileName Profile Name
     * @return             List of Profiles
     */
    public static List<Profile> selectProfileIdByName(String profileName) {
        
        return [SELECT
                    Id
                FROM Profile
                WHERE Name = :profileName];
    }
}