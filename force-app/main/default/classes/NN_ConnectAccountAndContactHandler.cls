public without sharing class NN_ConnectAccountAndContactHandler {
    
    @AuraEnabled(Cacheable=true)
    public static List<Account> getAccounts(){
        
        List<Account> accounts = new List<Account>();
        
        accounts = [
            SELECT Id, Name
            FROM Account
            WITH SECURITY_ENFORCED
            ORDER BY Name
        ];
        return accounts;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Contact> getRelatedContacts(String accountId) {

        List<Contact> relatedContacts = [
            SELECT Id, FirstName, LastName
            FROM Contact
            WHERE Id = :accountId
            WITH SECURITY_ENFORCED
            ORDER BY LastName, FirstName
        ];

        return relatedContacts;
    }
}