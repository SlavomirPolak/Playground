/**
 * @description Test for Flow NN_LeadBeforeUpsert. Flow test with update owner is not possible, therefore class is created.
 * https://ideas.salesforce.com/s/idea/a0B8W00000Nwyt3UAB/allow-owner-change-in-flow-debuggingtests
 * 
 * Test is without IsParallel=true -> APEX_DATA_ACCESS_RESTRICTION, In parallel Apex tests, DML operations aren't permitted on this type of object: User: []
 */
@IsTest
public with sharing class NN_LeadBeforeUpsertFlowTest {

    private static final String LEAD_SOURCE_VALUE = 'Web';
    
    @IsTest
    static void leadBeforeUpsertUpdateTest() {

        Lead leadToInsert = NN_TestDataFactory.prepareDefaultLeads().get(NN_TestDataFactory.LEAD_A_LAST_NAME);
        leadToInsert.NumberOfEmployees = 2;
        leadToInsert.LeadSource =  LEAD_SOURCE_VALUE;
        insert leadToInsert;

        User testUser = NN_TestDataFactory.prepareDefaultAdminUser();
        insert testUser;

        leadToInsert.OwnerId = testUser.Id;

        Test.startTest();
        update leadToInsert;
        Test.stopTest();

        List<Lead> testedLead = NN_LeadSelector.selectOwnerSinceDataById(leadToInsert.Id);

        System.assertNotEquals(leadToInsert.NN_OwnerSince__c, testedLead.get(0).NN_OwnerSince__c);     
    }

    /**
     * @description This test is prepared among FLow Tests in the file NN_LeadBeforeUpsert_Insert.flowtest-meta.xml.
     * Becuase of the Owner refference passed by ID, after the dpeloyment, test throw an error: An error occurred while saving the triggering record: invalid cross reference id.
     * Due to reason above I created apex test as well.
     */
    @IsTest
    static void leadBeforeUpsertInsertTest() {

        Lead leadToInsert = NN_TestDataFactory.prepareDefaultLeads().get(NN_TestDataFactory.LEAD_A_LAST_NAME);
        leadToInsert.NumberOfEmployees = 2;
        leadToInsert.LeadSource =  LEAD_SOURCE_VALUE;

        Test.startTest();
        insert leadToInsert;
        Test.stopTest();

        List<Lead> testedLead = NN_LeadSelector.selectOwnerSinceDataById(leadToInsert.Id);

        System.assertNotEquals(leadToInsert.NN_OwnerSince__c, testedLead.get(0).NN_OwnerSince__c);     
    }
}
