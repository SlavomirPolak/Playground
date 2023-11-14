/**
 * @description Test for NN_CountrySelector
 */
@IsTest(IsParallel=true)
public with sharing class NN_CountrySelectorTest {
    
    @IsTest
    static void selectAllCountriesTest() {

        insert NN_TestDataFactory.prepareDefaultCountries().values();

        Test.startTest();
        List<NN_Country__c> selectedCountries = NN_CountrySelector.selectAllCountries();
        Test.stopTest();

        System.assertEquals(3, selectedCountries.size());     
    }

    @IsTest
    static void selectAllCountriesParamTest() {

        insert NN_TestDataFactory.prepareDefaultCountries().get(NN_TestDataFactory.CZECHIA_NAME);

        Test.startTest();
        List<NN_Country__c> selectedCountries = NN_CountrySelector.selectAllCountries();
        Test.stopTest();

        System.assertEquals(1, selectedCountries.size());        
        System.assertEquals(NN_TestDataFactory.CZECHIA_NAME, selectedCountries.get(0).Name);
        System.assertEquals(NN_TestDataFactory.CZECHIA_A2C, selectedCountries.get(0).NN_Alpha2Code__c);
        System.assertEquals(NN_TestDataFactory.CZECHIA_A3C, selectedCountries.get(0).NN_Alpha3Code__c);
        System.assertEquals(NN_TestDataFactory.CZECHIA_CAPITAL, selectedCountries.get(0).NN_Capital__c);
        System.assertEquals(NN_TestDataFactory.EUROPE_REGION, selectedCountries.get(0).NN_Region__c);
        System.assertEquals(NN_TestDataFactory.CZECHIA_RB, selectedCountries.get(0).NN_RegionalBlocs__c);
    }

    @IsTest
    static void selectAllCountriesNoCountriesTest() {

        Test.startTest();
        List<NN_Country__c> selectedCountries = NN_CountrySelector.selectAllCountries();
        Test.stopTest();

        System.assertEquals(0, selectedCountries.size());
    }

    @IsTest
    static void selectCountryByNameTest() {

        insert NN_TestDataFactory.prepareDefaultCountries().values();

        Test.startTest();
        List<NN_Country__c> selectedCountries = NN_CountrySelector.selectCountryByName(new Set<String>{NN_TestDataFactory.CZECHIA_NAME});
        Test.stopTest();

        System.assertEquals(1, selectedCountries.size());
        System.assertEquals(NN_TestDataFactory.CZECHIA_NAME, selectedCountries.get(0).Name);
        System.assertEquals(NN_TestDataFactory.CZECHIA_A2C, selectedCountries.get(0).NN_Alpha2Code__c);
        System.assertEquals(NN_TestDataFactory.CZECHIA_A3C, selectedCountries.get(0).NN_Alpha3Code__c);
        System.assertEquals(NN_TestDataFactory.CZECHIA_CAPITAL, selectedCountries.get(0).NN_Capital__c);
        System.assertEquals(NN_TestDataFactory.EUROPE_REGION, selectedCountries.get(0).NN_Region__c);
        System.assertEquals(NN_TestDataFactory.CZECHIA_RB, selectedCountries.get(0).NN_RegionalBlocs__c);
    }

    @IsTest
    static void selectCountryByNameNoCountriesTest() {

        insert NN_TestDataFactory.prepareDefaultCountries().values();

        Test.startTest();
        List<NN_Country__c> selectedCountries = NN_CountrySelector.selectCountryByName(new Set<String>{'NON existing country'});
        Test.stopTest();

        System.assertEquals(0, selectedCountries.size());
    }
}