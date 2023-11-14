/**
 * @description contains utility methods 
 */
public with sharing class NN_UtilityClass {

    /**
     * @description process Database.upsert() result and creates log
     * @param  classAndMethod       class.method
     * @param  results              result of insertion
     */
    public static void processUpsertResult(String classAndMethod, Database.UpsertResult[] results) {

        List<NN_Log__c> logs = new List<NN_Log__c>();

        if (results != null && classAndMethod != null) {
            for (Database.UpsertResult ur : results) {
                if (!ur.isSuccess()) {
                    logs.add(createLog(classAndMethod, String.valueOf(ur.getErrors())));
                }
            }
        }

        if (!logs.isEmpty()) {
            Database.insert(logs);
        }
    }

    /**
     * @description process Database.insert() result and creates log
     * @param  classAndMethod       class.method
     * @param  results              result of insertion
     */
    public static void processInsertResult(String classAndMethod, Database.SaveResult[] results) {

        List<NN_Log__c> logs = new List<NN_Log__c>();

        if (results != null && classAndMethod != null) {
            for (Database.SaveResult sr : results) {
                if (!sr.isSuccess()) {
                    logs.add(createLog(classAndMethod, String.valueOf(sr.getErrors())));
                }
            }
        }

        if (!logs.isEmpty()) {
            Database.insert(logs);
        }
    }

    /**
     * @description insert new Log based on the input
     * @param  name    log name - class.method
     * @param  message log message
     */
    public static NN_Log__c createLog(String name, String message) {

        NN_Log__c newLog = new NN_Log__c();
        newLog.Name = name;
        newLog.NN_Message__c = message;

        return newLog;
    }
}