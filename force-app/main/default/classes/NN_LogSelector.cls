/**
 * @description Selector class for NN_Log__c object
 */
public with sharing class NN_LogSelector {
    
    /**
     * @description select all NN_Log__c
     * @return list of NN_Log__c
     */
    public static List<NN_Log__c> selectAllLogs() {
        
        return [SELECT
                    Id,
                    Name,
                    NN_Message__c
                FROM NN_Log__c];
    }
}