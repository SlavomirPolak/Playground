/**
 * @description Test for NN_UtilityClass
 */
@IsTest(IsParallel=true)
public with sharing class NN_UtilityClassTest {

    private static final String TEST_STRING = 'test';
    private static final String FAILED_RESULT = '[{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}]';

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
    static void testCreateLogNullParam() {

        Exception ex = null;
        NN_Log__c createdLog;

        Test.startTest();
        try {
        createdLog = NN_UtilityClass.createLog(null, null);
        } catch (Exception e) {
            ex = e;
        }

        System.assertEquals(null, createdLog.Name);
        System.assertEquals(null, createdLog.NN_Message__c);
        System.assertEquals(null, ex);
    }

    @IsTest
    static void testProcessInsertResult() {
        
        Database.SaveResult[] results = (List<Database.SaveResult>) JSON.deserialize(FAILED_RESULT, List<Database.SaveResult>.class);

        Test.startTest();
        NN_UtilityClass.processInsertResult(TEST_STRING, results);
        Test.stopTest();

        List<NN_Log__c> logs = NN_LogSelector.selectAllLogs();

        System.assertEquals(1, logs.size());
        System.assertEquals(TEST_STRING, logs.get(0).Name);
    }

    @IsTest
    static void testProcessInsertResultNullParam() {
        
        Database.SaveResult[] results = (List<Database.SaveResult>) JSON.deserialize(FAILED_RESULT, List<Database.SaveResult>.class);

        Test.startTest();
        NN_UtilityClass.processInsertResult(null, null);
        Test.stopTest();

        List<NN_Log__c> logs = NN_LogSelector.selectAllLogs();

        System.assertEquals(0, logs.size());
    }

    @IsTest
    static void testProcessUpsertResult() {
        
        Database.UpsertResult[] results = (List<Database.UpsertResult>) JSON.deserialize(FAILED_RESULT, List<Database.UpsertResult>.class);

        Test.startTest();
        NN_UtilityClass.processUpsertResult(TEST_STRING, results);
        Test.stopTest();

        List<NN_Log__c> logs = NN_LogSelector.selectAllLogs();

        System.assertEquals(1, logs.size());
        System.assertEquals(TEST_STRING, logs.get(0).Name);
    }

    @IsTest
    static void testProcessUpsertResultNullParam() {
        
        Database.UpsertResult[] results = (List<Database.UpsertResult>) JSON.deserialize(FAILED_RESULT, List<Database.UpsertResult>.class);

        Test.startTest();
        NN_UtilityClass.processUpsertResult(null, null);
        Test.stopTest();

        List<NN_Log__c> logs = NN_LogSelector.selectAllLogs();

        System.assertEquals(0, logs.size());
    }
}