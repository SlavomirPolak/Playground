/**
 * @description Test for NN_UtilityClass
 */
@IsTest(IsParallel=true)
public with sharing class NN_UtilityClassTest {

    private static final String TEST_STRING = 'test';


    @IsTest
    static void testCreateLogFullParam() {

        Test.startTest();
        NN_Log__c createdLog = NN_UtilityClass.createLog(TEST_STRING, TEST_STRING);
        Test.stopTest();

        System.assertEquals(TEST_STRING, createdLog.Name);
        System.assertEquals(TEST_STRING, createdLog.NN_Message__c);
    }

    @IsTest
    static void testCreateLogNullSecondParam() {

        Test.startTest();
        NN_Log__c createdLog = NN_UtilityClass.createLog(TEST_STRING, null);
        Test.stopTest();

        System.assertEquals(TEST_STRING, createdLog.Name);
        System.assertEquals(null, createdLog.NN_Message__c);
    }

    @IsTest
    static void testProcessInsertResult() {
        
        Database.SaveResult[] results = (List<Database.SaveResult>) JSON.deserialize('[{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}]', List<Database.SaveResult>.class);

        Test.startTest();
        NN_UtilityClass.processInsertResult(TEST_STRING, results);
        Test.stopTest();

        List<NN_Log__c> logs = NN_LogSelector.selectAllLogs();

        System.assertEquals(1, logs.size());
        System.assertEquals(TEST_STRING, logs.get(0).Name);
    }

    @IsTest
    static void testProcessUpsertResult() {
        
        Database.UpsertResult[] results = (List<Database.UpsertResult>) JSON.deserialize('[{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}]', List<Database.UpsertResult>.class);

        Test.startTest();
        NN_UtilityClass.processUpsertResult(TEST_STRING, results);
        Test.stopTest();

        List<NN_Log__c> logs = NN_LogSelector.selectAllLogs();

        System.assertEquals(1, logs.size());
        System.assertEquals(TEST_STRING, logs.get(0).Name);
    }

    @IsTest
    static void testCreateLogNullParam() {

        Exception ex = null;

        Test.startTest();
        try {
        NN_Log__c createdLog = NN_UtilityClass.createLog(TEST_STRING, null);
        } catch (Exception e) {
            ex = e;
        }

        System.assertEquals(null, ex);
    }
}