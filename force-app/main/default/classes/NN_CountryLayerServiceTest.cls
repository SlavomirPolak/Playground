/**
 * @description Test for NN_CountryLayerService
 */
@IsTest(IsParallel=true)
public with sharing class NN_CountryLayerServiceTest {
    
    private static final Integer NUMBER_OF_COUNTRIES = 3;

    @IsTest
    static void testUpdateCountriesInitialInsert() {

        Test.setMock(HttpCalloutMock.class, new NN_MockHttpResponseGenerator(200));

        Test.startTest();
        NN_CountryLayerService.updateCountries();
        Test.stopTest();

        List<NN_Country__c> returnedCountries = NN_CountrySelector.selectAllCountries();

        System.assertEquals(NUMBER_OF_COUNTRIES, returnedCountries.size());

        Map<String, NN_Country__c> expectedCountries = NN_TestDataFactory.prepareDefaultCountries();
        List<NN_Log__c> logs = NN_LogSelector.selectAllLogs();

        System.assertEquals(0, logs.size());        
        System.assert(equalsWithoutId(expectedCountries.get(returnedCountries.get(0).Name), returnedCountries.get(0)), 'Countries are not equal!');
        System.assert(equalsWithoutId(expectedCountries.get(returnedCountries.get(1).Name), returnedCountries.get(1)), 'Countries are not equal!');
    }

    @IsTest
    static void testUpdateCountriesInitialUpdate() {
        
        Test.setMock(HttpCalloutMock.class, new NN_MockHttpResponseGenerator(200));

        List<NN_Country__c> originalCountries = NN_TestDataFactory.prepareDefaultCountries().values();

        originalCountries.get(0).NN_Alpha2Code__c = 'aa';
        originalCountries.get(0).NN_Alpha3Code__c = 'aaa';
        originalCountries.get(0).NN_Capital__c = 'test';
        originalCountries.get(0).NN_Region__c = 'test';
        originalCountries.get(0).NN_RegionalBlocs__c = 'test';

        originalCountries.get(1).NN_Alpha2Code__c = 'aa';
        originalCountries.get(1).NN_Alpha3Code__c = 'aaa';
        originalCountries.get(1).NN_Capital__c = 'test';
        originalCountries.get(1).NN_Region__c = 'test';
        originalCountries.get(1).NN_RegionalBlocs__c = 'test';

        insert originalCountries;

        Test.startTest();
        NN_CountryLayerService.updateCountries();
        Test.stopTest();

        List<NN_Country__c> returnedCountries = NN_CountrySelector.selectAllCountries();

        System.assertEquals(NUMBER_OF_COUNTRIES, returnedCountries.size());

        Map<String, NN_Country__c> expectedCountries = NN_TestDataFactory.prepareDefaultCountries();

        System.assert(equalsWithoutId(expectedCountries.get(returnedCountries.get(0).Name), returnedCountries.get(0)), 'Countries are not equal!');
        System.assert(equalsWithoutId(expectedCountries.get(returnedCountries.get(1).Name), returnedCountries.get(1)), 'Countries are not equal!');
    }

    @IsTest
    static void testUpdateCountriesInitialUpsert() {
        
        Test.setMock(HttpCalloutMock.class, new NN_MockHttpResponseGenerator(200));
        List<NN_Country__c> originalCountries = NN_TestDataFactory.prepareDefaultCountries().values();

        originalCountries.get(0).NN_Alpha2Code__c = 'aa';
        originalCountries.get(0).NN_Alpha3Code__c = 'aaa';
        originalCountries.get(0).NN_Capital__c = 'test';
        originalCountries.get(0).NN_Region__c = 'test';
        originalCountries.get(0).NN_RegionalBlocs__c = 'test';

        insert originalCountries.get(0);

        Test.startTest();
        NN_CountryLayerService.updateCountries();
        Test.stopTest();

        List<NN_Country__c> returnedCountries = NN_CountrySelector.selectAllCountries();

        System.assertEquals(NUMBER_OF_COUNTRIES, returnedCountries.size());

        Map<String, NN_Country__c> expectedCountries = NN_TestDataFactory.prepareDefaultCountries();

        System.assert(equalsWithoutId(expectedCountries.get(returnedCountries.get(0).Name), returnedCountries.get(0)));
        System.assert(equalsWithoutId(expectedCountries.get(returnedCountries.get(1).Name), returnedCountries.get(1)));
    }

    @IsTest
    static void testUpdateCountriesInitialUpsertNullValues() {
        
        Test.setMock(HttpCalloutMock.class, new NN_MockHttpResponseGenerator(200));
        List<NN_Country__c> originalCountries = NN_TestDataFactory.prepareDefaultCountries().values();

        originalCountries.get(0).NN_Alpha2Code__c = null;
        originalCountries.get(0).NN_Alpha3Code__c = null;
        originalCountries.get(0).NN_Capital__c = null;
        originalCountries.get(0).NN_Region__c = null;
        originalCountries.get(0).NN_RegionalBlocs__c = null;

        insert originalCountries.get(0);

        Test.startTest();
        NN_CountryLayerService.updateCountries();
        Test.stopTest();

        List<NN_Country__c> returnedCountries = NN_CountrySelector.selectAllCountries();

        System.assertEquals(NUMBER_OF_COUNTRIES, returnedCountries.size());

        Map<String, NN_Country__c> expectedCountries = NN_TestDataFactory.prepareDefaultCountries();

        System.assert(equalsWithoutId(expectedCountries.get(returnedCountries.get(0).Name), returnedCountries.get(0)), 'Countries are not equal!');
        System.assert(equalsWithoutId(expectedCountries.get(returnedCountries.get(1).Name), returnedCountries.get(1)), 'Countries are not equal!');
    }

    @IsTest
    static void testUpdateCountriesInitialInsertBadResponse() {

        Test.setMock(HttpCalloutMock.class, new NN_MockHttpResponseGenerator(400));

        Test.startTest();
        NN_CountryLayerService.updateCountries();
        Test.stopTest();

        List<NN_Country__c> returnedCountries = NN_CountrySelector.selectAllCountries();
        List<NN_Log__c> logs = NN_LogSelector.selectAllLogs();

        System.assertEquals(0, returnedCountries.size());
        System.assertEquals(1, logs.size());
        System.assert(logs.get(0).Name.contains(NN_CountryLayerService.LOG_CLASS_NAME), 'Log name does NOT contain expected Class name');
    }

    @IsTest
    static void testUpdateCountriesInitialUpdateBadResponse() {
        
        Test.setMock(HttpCalloutMock.class, new NN_MockHttpResponseGenerator(400));
        List<NN_Country__c> originalCountries = NN_TestDataFactory.prepareDefaultCountries().values();
        insert originalCountries;

        Test.startTest();
        NN_CountryLayerService.updateCountries();
        Test.stopTest();

        List<NN_Country__c> returnedCountries = NN_CountrySelector.selectAllCountries();
        List<NN_Log__c> logs = NN_LogSelector.selectAllLogs();

        System.assertEquals(NUMBER_OF_COUNTRIES, returnedCountries.size());
        System.assertEquals(1, logs.size());
        System.assert(logs.get(0).Name.contains(NN_CountryLayerService.LOG_CLASS_NAME), 'Log name does NOT contain expected Class name');
    }

    @IsTest
    static void testUpdateCountriesInitialUpsertBadResponse() {
        
        Test.setMock(HttpCalloutMock.class, new NN_MockHttpResponseGenerator(400));
        List<NN_Country__c> originalCountries = NN_TestDataFactory.prepareDefaultCountries().values();
        insert originalCountries.get(0);

        Test.startTest();
        NN_CountryLayerService.updateCountries();
        Test.stopTest();

        List<NN_Country__c> returnedCountries = NN_CountrySelector.selectAllCountries();
        List<NN_Log__c> logs = NN_LogSelector.selectAllLogs();

        System.assertEquals(1, returnedCountries.size());
        System.assertEquals(1, logs.size());
        System.assert(logs.get(0).Name.contains(NN_CountryLayerService.LOG_CLASS_NAME), 'Log name does NOT contain expected Class name');
    }

    /***** HELPER METHODS *****/

    /**
     * @description perform equality check without Id field on two NN_Country__c objects.
     * Method is used only for testing.
     * @param  countryA first NN_Country__c object
     * @param  countryB second NN_Country__c object
     * @return          return True if objects are equals without Id
     */
    public static Boolean equalsWithoutId(NN_Country__c countryA, NN_Country__c countryB) {
        
        countryA.Id = countryB.Id;
        countryA.NN_RegionalBlocs__c = countryB.NN_RegionalBlocs__c;
        return countryA == countryB;
    }
}