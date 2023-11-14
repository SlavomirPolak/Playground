/**
 * @description Test for NN_LeadSelector
 */
@IsTest(IsParallel=true)
public with sharing class NN_LeadSelectorTest {
    
    @IsTest
    static void selectCountryDataForAllLeadsTest() {

        insert NN_TestDataFactory.prepareDefaultLeads().values();

        Test.startTest();
        List<Lead> selectedLeads = NN_LeadSelector.selectCountryDataForAllLeads();
        Test.stopTest();

        System.assertEquals(3, selectedLeads.size());
    }

    @IsTest
    static void selectCountryDataForAllLeadsParamTest() {

        Lead leadToInsert = NN_TestDataFactory.prepareDefaultLeads().get(NN_TestDataFactory.LEAD_A_LAST_NAME);
        insert leadToInsert;

        Test.startTest();
        List<Lead> selectedLeads = NN_LeadSelector.selectCountryDataForAllLeads();
        Test.stopTest();

        System.assertEquals(1, selectedLeads.size());
        System.assertEquals(leadToInsert.Country, selectedLeads.get(0).Country);
        System.assertEquals(leadToInsert.NN_Alpha2Code__c, selectedLeads.get(0).NN_Alpha2Code__c);
        System.assertEquals(leadToInsert.NN_Alpha3Code__c, selectedLeads.get(0).NN_Alpha3Code__c);
        System.assertEquals(leadToInsert.NN_Capital__c, selectedLeads.get(0).NN_Capital__c);
        System.assertEquals(leadToInsert.NN_Region__c, selectedLeads.get(0).NN_Region__c);
        System.assertEquals(leadToInsert.NN_RegionalBlocs__c, selectedLeads.get(0).NN_RegionalBlocs__c);
    }

    @IsTest
    static void selectCountryDataForAllLeadsNoLeadsTest() {

        Test.startTest();
        List<Lead> selectedLeads = NN_LeadSelector.selectCountryDataForAllLeads();
        Test.stopTest();

        System.assertEquals(0, selectedLeads.size());
    }

    @IsTest
    static void selectLeadCountryDataByCountryTest() {

        insert NN_TestDataFactory.prepareDefaultLeads().values();

        Test.startTest();
        List<Lead> selectedLeads = NN_LeadSelector.selectLeadCountryDataByCountry(new Set<String>{NN_TestDataFactory.CZECHIA_NAME});
        Test.stopTest();

        System.assertEquals(1, selectedLeads.size());
        System.assertEquals(NN_TestDataFactory.CZECHIA_NAME, selectedLeads.get(0).Country);
        System.assertEquals(NN_TestDataFactory.CZECHIA_A2C, selectedLeads.get(0).NN_Alpha2Code__c);
        System.assertEquals(NN_TestDataFactory.CZECHIA_A3C, selectedLeads.get(0).NN_Alpha3Code__c);
        System.assertEquals(NN_TestDataFactory.CZECHIA_CAPITAL, selectedLeads.get(0).NN_Capital__c);
        System.assertEquals(NN_TestDataFactory.EUROPE_REGION, selectedLeads.get(0).NN_Region__c);
        System.assertEquals(NN_TestDataFactory.CZECHIA_RB, selectedLeads.get(0).NN_RegionalBlocs__c);
    }

    @IsTest
    static void selectLeadCountryDataByCountryNoLeadsTest() {

        insert NN_TestDataFactory.prepareDefaultLeads().values();

        Test.startTest();
        List<Lead> selectedLeads = NN_LeadSelector.selectLeadCountryDataByCountry(new Set<String>{'NON existing country'});
        Test.stopTest();

        System.assertEquals(0, selectedLeads.size());
    }
}