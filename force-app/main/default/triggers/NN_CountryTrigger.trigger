trigger NN_CountryTrigger on NN_Country__c (after insert, after update) {
    
    if (Trigger.isAfter && Trigger.isInsert) {
        NN_CountryTriggerHandler.afterInsert(Trigger.newMap);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        NN_CountryTriggerHandler.afterUpdate(Trigger.newMap);
    }
}