/**
 * @description Selector class for Lead object
 */
public class NN_LeadSelector {
    
    /**
     * @description select Country data for all Lead by name
     * @param  countryNames set of Country names
     * @return list of Lead
     */
    public static List<Lead> selectLeadCountryDataByCountry(Set<String> countryNames) {
        
        return [SELECT
                    Id,
                    NN_Alpha2Code__c,
                    NN_Alpha3code__c,
                    NN_Capital__c,
                    NN_Region__c, 
                    NN_RegionalBlocs__c,
                    Country
                FROM Lead
                WHERE Country IN :countryNames];
    }

    /**
     * @description select Country data for all Lead by name
     * @return list of Lead
     */
    public static List<Lead> selectCountryDataForAllLeads() {
        
        return [SELECT
                    Id,
                    NN_Alpha2Code__c,
                    NN_Alpha3code__c,
                    NN_Capital__c,
                    NN_Region__c, 
                    NN_RegionalBlocs__c,
                    Country
                FROM Lead];
    }
}