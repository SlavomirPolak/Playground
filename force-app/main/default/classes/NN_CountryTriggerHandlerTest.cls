/**
 * @description Test for NN_CountryTriggerHandler
 */
@IsTest(IsParallel=true)
public with sharing class NN_CountryTriggerHandlerTest {
    
    @TestSetup
    static void makeData() {
        Database.insert(NN_TestDataFactory.prepareDefaultLeads().values());
    }
    
    @IsTest
    static void testAfterInsert() {

        Map<String, NN_Country__c> countriesByCountryName = NN_TestDataFactory.prepareDefaultCountries();
        
        Test.startTest();
        Database.insert(countriesByCountryName.values());
        Test.stopTest();

        List<Lead> leads = NN_LeadSelector.selectCountryDataForAllLeads();

        System.assertEquals(3, leads.size());

        for (Lead updatedLead : leads) {

            System.assertEquals(countriesByCountryName.get(updatedLead.Country).Name , updatedLead.Country);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_Alpha2Code__c , updatedLead.NN_Alpha2Code__c);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_Alpha3Code__c , updatedLead.NN_Alpha3Code__c);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_Capital__c , updatedLead.NN_Capital__c);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_Region__c , updatedLead.NN_Region__c);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_RegionalBlocs__c , updatedLead.NN_RegionalBlocs__c);
        }
    }

    @IsTest
    static void testAfterUpsert() {

        Map<String, NN_Country__c> countriesByCountryName = NN_TestDataFactory.prepareDefaultCountries();

        NN_Country__c modifiedCountry = new NN_Country__c();
        modifiedCountry.NN_Alpha2Code__c = 'aa';
        modifiedCountry.NN_Alpha3Code__c = 'aaa';
        modifiedCountry.NN_Capital__c = 'aa';
        modifiedCountry.NN_Region__c = 'aa';
        modifiedCountry.NN_RegionalBlocs__c = 'aa';
        modifiedCountry.Name = NN_TestDataFactory.CZECHIA_NAME;
        
        Database.insert(modifiedCountry);
        
        Test.startTest();
        Database.upsert(countriesByCountryName.values(), NN_Country__c.Name);
        Test.stopTest();

        List<Lead> leads = NN_LeadSelector.selectCountryDataForAllLeads();

        System.assertEquals(3, leads.size());

        for (Lead updatedLead : leads) {
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).Name , updatedLead.Country);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_Alpha2Code__c , updatedLead.NN_Alpha2Code__c);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_Alpha3Code__c , updatedLead.NN_Alpha3Code__c);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_Capital__c , updatedLead.NN_Capital__c);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_Region__c , updatedLead.NN_Region__c);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_RegionalBlocs__c , updatedLead.NN_RegionalBlocs__c);
        }
    }

    @IsTest
    static void testAfterUpseretWithNullValue() {

        Map<String, NN_Country__c> countriesByCountryName = NN_TestDataFactory.prepareDefaultCountries();

        NN_Country__c modifiedCountry = new NN_Country__c();
        modifiedCountry.Name = NN_TestDataFactory.CZECHIA_NAME;

        countriesByCountryName.get(NN_Constant.USA_SALESFORCE_NAME).NN_Alpha2Code__c = null;
        countriesByCountryName.get(NN_Constant.USA_SALESFORCE_NAME).NN_Alpha3Code__c = null;
        
        Database.insert(modifiedCountry);
        Database.insert(countriesByCountryName.get(NN_Constant.USA_SALESFORCE_NAME));
        
        Test.startTest();
        Database.upsert(countriesByCountryName.values(), NN_Country__c.Name);
        Test.stopTest();

        List<Lead> leads = NN_LeadSelector.selectCountryDataForAllLeads();

        System.assertEquals(3, leads.size());

        for (Lead updatedLead : leads) {
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).Name , updatedLead.Country);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_Alpha2Code__c , updatedLead.NN_Alpha2Code__c);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_Alpha3Code__c , updatedLead.NN_Alpha3Code__c);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_Capital__c , updatedLead.NN_Capital__c);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_Region__c , updatedLead.NN_Region__c);
            System.assertEquals(countriesByCountryName.get(updatedLead.Country).NN_RegionalBlocs__c , updatedLead.NN_RegionalBlocs__c);
        }
    }
}