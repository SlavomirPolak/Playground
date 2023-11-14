/**
 * @description Test for NN_LogSelector
 */
@IsTest(IsParallel=true)
public with sharing class NN_LogSelectorTest {
    
    @IsTest
    static void selectAllLogsTest() {

        insert NN_TestDataFactory.prepareDefaultLogs();

        Test.startTest();
        List<NN_Log__c> selectedLogs = NN_LogSelector.selectAllLogs();
        Test.stopTest();

        System.assertEquals(2, selectedLogs.size());
        System.assertEquals(NN_TestDataFactory.CLASS_NAME, selectedLogs.get(0).Name);
        System.assertEquals(NN_TestDataFactory.CLASS_NAME, selectedLogs.get(1).Name);
        System.assert(NN_TestDataFactory.MESSAGE.equals(selectedLogs.get(0).NN_Message__c));
        System.assert(NN_TestDataFactory.MESSAGE.equals(selectedLogs.get(1).NN_Message__c));
    }

    @IsTest
    static void selectAllLogsNoLogsTest() {

        Test.startTest();
        List<NN_Log__c> selectedLogs = NN_LogSelector.selectAllLogs();
        Test.stopTest();

        System.assertEquals(0, selectedLogs.size());
    }
}