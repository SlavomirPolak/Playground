/**
 * @description Test data factory class to create common test data
 */
@isTest
public with sharing class NN_TestDataFactory {

    private static final String ADMIN_PROFILE_NAME = 'System Administrator';
    
    @TestVisible
    private static final String EUROPE_REGION = 'Europe';

    /***** SLOVAKIA *****/
    @TestVisible
    private static final String SLOVAKIA_NAME = 'Slovakia';
    @TestVisible
    private static final String SLOVAKIA_A2C = 'SK';
    @TestVisible
    private static final String SLOVAKIA_A3C = 'SVK';
    @TestVisible
    private static final String SLOVAKIA_CAPITAL = 'Bratislava';
    @TestVisible
    private static final String SLOVAKIA_RB = 'Kosice,\nTrencin,\nBratislava';

    /***** CZECHIA *****/
    @TestVisible
    private static final String CZECHIA_NAME = 'Czech Republic';
    @TestVisible
    private static final String CZECHIA_A2C = 'CZ';
    @TestVisible
    private static final String CZECHIA_A3C = 'CZE';
    @TestVisible
    private static final String CZECHIA_CAPITAL = 'Praha';
    @TestVisible
    private static final String CZECHIA_RB = 'Brno,\nPraha,\nOstrava';

    /***** USA *****/
    @TestVisible
    private static final String US_A2C = 'US';
    @TestVisible
    private static final String US_A3C = 'USA';
    @TestVisible
    private static final String US_CAPITAL = 'Washington, D.C.';
    @TestVisible
    private static final String US_RB = null;
    @TestVisible
    private static final String US_REGION = 'Americas';

    /***** LEAD TEST *****/
    @TestVisible
    private static final String LEAD_A_LAST_NAME = 'Doe';

    /***** LOG TEST *****/
    @TestVisible
    private static final String CLASS_NAME = 'NN_ClassA';
    @TestVisible
    private static final String MESSAGE = 'Error';

    
    /**
     * @description prepared test payload for CountryLayer service
     */
    public static Map<String, NN_CountryLayerService.NN_CountryLayerPayload> preparePayload() {

        NN_CountryLayerService.NN_CountryLayerPayload skPayload = new NN_CountryLayerService.NN_CountryLayerPayload();
        skPayload.Name = SLOVAKIA_NAME;
        skPayload.alpha2Code = SLOVAKIA_A2C;
        skPayload.alpha3Code = SLOVAKIA_A3C;
        skPayload.capital = SLOVAKIA_CAPITAL;
        skPayload.region = EUROPE_REGION;
        skPayload.regionalBlocs = SLOVAKIA_RB;

        NN_CountryLayerService.NN_CountryLayerPayload czPayload = new NN_CountryLayerService.NN_CountryLayerPayload();
        czPayload.Name = CZECHIA_NAME;
        czPayload.alpha2Code = CZECHIA_A2C;
        czPayload.alpha3Code = CZECHIA_A3C;
        czPayload.capital = CZECHIA_CAPITAL;
        czPayload.region = EUROPE_REGION;
        czPayload.regionalBlocs = CZECHIA_RB;

        NN_CountryLayerService.NN_CountryLayerPayload usPayload = new NN_CountryLayerService.NN_CountryLayerPayload();
        usPayload.Name = NN_CountryLayerService.USA_EX_SYS_NAME;
        usPayload.alpha2Code = US_A2C;
        usPayload.alpha3Code = US_A3C;
        usPayload.capital = US_CAPITAL;
        usPayload.region = US_REGION;
        usPayload.regionalBlocs = US_RB;

        return new Map<String, NN_CountryLayerService.NN_CountryLayerPayload>{SLOVAKIA_NAME => skPayload, CZECHIA_NAME => czPayload, NN_CountryLayerService.USA_EX_SYS_NAME => usPayload};
    }

    /**
     * @description prepared default Countries for testing purpose
     */
    public static Map<String, NN_Country__c> prepareDefaultCountries() {

        NN_Country__c slovakia = new NN_Country__c();
        slovakia.Name = SLOVAKIA_NAME;
        slovakia.NN_Alpha2Code__c = SLOVAKIA_A2C;
        slovakia.NN_Alpha3Code__c = SLOVAKIA_A3C;
        slovakia.NN_Capital__c = SLOVAKIA_CAPITAL;
        slovakia.NN_Region__c = EUROPE_REGION;
        slovakia.NN_RegionalBlocs__c = SLOVAKIA_RB;

        NN_Country__c czechia = new NN_Country__c();
        czechia.Name = CZECHIA_NAME;
        czechia.NN_Alpha2Code__c = CZECHIA_A2C;
        czechia.NN_Alpha3Code__c = CZECHIA_A3C;
        czechia.NN_Capital__c = CZECHIA_CAPITAL;
        czechia.NN_Region__c = EUROPE_REGION;
        czechia.NN_RegionalBlocs__c = CZECHIA_RB;

        NN_Country__c us = new NN_Country__c();
        us.Name = NN_Constant.USA_SALESFORCE_NAME;
        us.NN_Alpha2Code__c = US_A2C;
        us.NN_Alpha3Code__c = US_A3C;
        us.NN_Capital__c = US_CAPITAL;
        us.NN_Region__c = US_REGION;
        us.NN_RegionalBlocs__c = US_RB;

        return new Map<String, NN_Country__c>{SLOVAKIA_NAME => slovakia, CZECHIA_NAME => czechia, NN_Constant.USA_SALESFORCE_NAME => us};
    }

    /**
     * @description prepared default Lead for testing purpose
     */
    public static Map<String, Lead> prepareDefaultLeads() {

        Lead leadA = new Lead();
        leadA.Company = 'ACME';
        leadA.FirstName = 'John';
        leadA.LastName = LEAD_A_LAST_NAME;
        leadA.Status = 'Working - Contacted';
        leadA.Country = CZECHIA_NAME;
        leadA.NN_Alpha2Code__c = CZECHIA_A2C;
        leadA.NN_Alpha3Code__c = CZECHIA_A3C;
        leadA.NN_Capital__c = CZECHIA_CAPITAL;
        leadA.NN_Region__c = EUROPE_REGION;
        leadA.NN_RegionalBlocs__c = CZECHIA_RB;

        Lead leadB = new Lead();
        leadB.Company = 'ADAD';
        leadB.FirstName = 'BoB';
        leadB.LastName = 'D';
        leadB.Status = 'Working - Contacted';
        leadB.Country = SLOVAKIA_NAME;

        Lead leadC = new Lead();
        leadC.Company = 'US_ADAD';
        leadC.FirstName = 'BoB';
        leadC.LastName = 'M';
        leadC.Status = 'Working - Contacted';
        leadC.Country = 'USA';

        return new Map<String, Lead>{leadA.LastName => leadA, leadB.LastName => leadB, leadC.LastName => leadC};
    }

    /**
     * @description prepared default NN_Log__c for testing purpose
     */
    public static List<NN_Log__c> prepareDefaultLogs() {

        NN_Log__c newLogA = new NN_Log__c();
        newLogA.Name = CLASS_NAME;
        newLogA.NN_Message__c = MESSAGE;

        NN_Log__c newLogB = new NN_Log__c();
        newLogB.Name = CLASS_NAME;
        newLogB.NN_Message__c = MESSAGE;

        return new List<NN_Log__c>{newLogA, newLogB};
    }

    /**
     * @description prepared default Admin User for testing purpose
     */
    public static User prepareDefaultAdminUser() {

        Profile adminProfile = NN_ProfileSelector.selectProfileIdByName(ADMIN_PROFILE_NAME).get(0);

        User testUser = new User(Alias = 'adminA', Email='adminuser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = adminProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='adminuser@testorg.com');

        return testUser;
    }
}