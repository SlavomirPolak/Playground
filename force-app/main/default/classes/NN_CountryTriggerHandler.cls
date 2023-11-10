/**
 * @description trigger handler for NN_Country__c object
 */
public with sharing class NN_CountryTriggerHandler {

    @TestVisible
    private static final String USA_MAPPING = 'United States of America';

    /**
     * @description method is executed after insertion of NN_Country__c
     * @param  newMap A map of IDs to the new versions of the sObject records.
     */
    public static void afterInsert(Map<Id, NN_Country__c> newMap) {
        
        // applies for all after updates
        updateLeads(newMap);
    }
    
    /**
     * @description method is executed after update of NN_Country__c
     * @param  newMap A map of IDs to the new versions of the sObject records.
     */
    public static void afterUpdate(Map<Id, NN_Country__c> newMap) {
        
        // applies for all after updates
        updateLeads(newMap);
    }

    /**
     * @description update Leads country fields based on the update on NN_Country__c object
     * @param  newMap A map of IDs to the new versions of the sObject records.
     */
    private static void updateLeads(Map<Id, NN_Country__c> newMap) {

        Map<String, NN_Country__c> countriesByCountryName = new Map<String, NN_Country__c>();

        for (NN_Country__c country : newMap.values()) {
            countriesByCountryName.put(country.Name, country);

            // United States of America is used in external system as USA therefore special logic is needed
            if (USA_MAPPING.equals(country.Name)) {
                countriesByCountryName.put(country.NN_Alpha3code__c, country);
            }
        }

        List<Lead> leadsToBeUpdated = NN_LeadSelector.selectLeadCountryDataByCountry(countriesByCountryName.keySet());

        for (Lead leadToBeUpdated : leadsToBeUpdated) {
            leadToBeUpdated.NN_Alpha2Code__c = countriesByCountryName.get(leadToBeUpdated.Country).NN_Alpha2Code__c;
            leadToBeUpdated.NN_Alpha3code__c = countriesByCountryName.get(leadToBeUpdated.Country).NN_Alpha3code__c;
            leadToBeUpdated.NN_Capital__c = countriesByCountryName.get(leadToBeUpdated.Country).NN_Capital__c;
            leadToBeUpdated.NN_Country__c = countriesByCountryName.get(leadToBeUpdated.Country).Name;
            leadToBeUpdated.NN_Region__c = countriesByCountryName.get(leadToBeUpdated.Country).NN_Region__c;
            leadToBeUpdated.NN_RegionalBlocs__c = countriesByCountryName.get(leadToBeUpdated.Country).NN_RegionalBlocs__c;
        }

        // add logging
        Database.update(leadsToBeUpdated);
    }
}