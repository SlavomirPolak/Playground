public with sharing class dataTableLWC {

    @AuraEnabled(cacheable = true)
    public static List<Account> fetchAccounts(){
       return [SELECT Id,Name,Phone,Type,Industry,Rating,Website, CreatedDate FROM Account LIMIT 100];
    }

    @AuraEnabled(cacheable = true)
    public static List<DataStructure> getData() {

        List<DataStructure> ret = createDataStructureList(fetchAccounts());
        System.debug('ret ' + ret);
        return ret;
    }

    public static List<DataStructure> createDataStructureList(List<Account> accounts) {
            
        List<DataStructure> dataStructures = new List<DataStructure>();

        for (Account acc : accounts) {
            DataStructure ds = new DataStructure();

            ds.id = acc.Id;
            ds.name = acc.Name;
            ds.website = 'www.salesforce.com';
            ds.amount = 7.00;
            ds.phone = acc.Phone;
            ds.closeAt = acc.CreatedDate;

            dataStructures.add(ds);
        }

        return dataStructures;
    }

    public class DataStructure {

        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public String website;
        @AuraEnabled public Double amount;
        @AuraEnabled public String phone;
        @AuraEnabled public DateTime closeAt;
    }
}