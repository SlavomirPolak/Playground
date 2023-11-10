/**
 * @description Selector class for NN_Country__c object
 */
public class NN_CountrySelector {

    /**
     * @description select all NN_Country__c
     * @return list of NN_Country__c
     */
    public static List<NN_Country__c> selectAllCountries() {
        
        return [SELECT
                    Id,
                    Name,
                    NN_Alpha2Code__c,
                    NN_Alpha3code__c,
                    NN_Capital__c,
                    NN_Region__c,
                    NN_RegionalBlocs__c
                FROM NN_Country__c];
    }
}