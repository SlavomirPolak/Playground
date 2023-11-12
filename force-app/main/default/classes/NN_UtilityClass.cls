/**
 * @description contains utility methods 
 */
public with sharing class NN_UtilityClass {
    
    /**
     * @description perform equality check without Id field on two NN_Country__c objects
     * @param  countryA first NN_Country__c object
     * @param  countryB second NN_Country__c object
     * @return          return True if objects are equals without Id
     */
    public Boolean equalsWithoutId(NN_Country__c countryA, NN_Country__c countryB) {
        
        countryA.Id = countryB.Id;
        countryA.NN_RegionalBlocs__c = countryB.NN_RegionalBlocs__c;
        return countryA == countryB;
    }

    /**
     * @description perform equality on fields of NN_Country__c object
     * @param  countryA first NN_Country__c object
     * @param  countryB second NN_Country__c object
     * @return          return True if criteria are met
     */
    public Boolean compareFields(NN_Country__c countryA, NN_Country__c countryB) {
        
        return (countryA != null && countryB != null) && (countryA.Name == countryB.Name &&
        countryA.NN_Alpha2Code__c == countryB.NN_Alpha2Code__c &&
        countryA.NN_Alpha3code__c == countryB.NN_Alpha3code__c &&
        countryA.NN_Capital__c == countryB.NN_Capital__c &&
        countryA.NN_Region__c == countryB.NN_Region__c &&
        countryA.NN_RegionalBlocs__c == countryB.NN_RegionalBlocs__c);
    }
}