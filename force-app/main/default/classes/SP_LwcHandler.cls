/**
 * @description LWC handler for teting purpose
 */
public with sharing class SP_LwcHandler {
    
    @AuraEnabled
    public static List<Case> getCasesForAccount(String accountNumber) {
        String searchString = '%' + accountNumber + '%';
        System.debug('searchString ' + searchString);
        List<Case> caseList = [SELECT Id, CaseNumber, Subject, CreatedDate FROM Case WHERE Account.AccountNumber LIKE :searchString];
        System.debug('getCasesForAccount ' + caseList);
        return caseList;
    }
}