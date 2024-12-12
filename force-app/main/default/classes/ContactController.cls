public with sharing class ContactController {

    public class Column {
        public String label;
        public String fieldName;
        public Boolean editable;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String accId) {
        return [
            SELECT AccountId, Id, FirstName, LastName, Title, Phone, Email
            FROM Contact
            WHERE AccountId = :accId
            WITH SECURITY_ENFORCED
        ];
    }

    @AuraEnabled(cacheable=true)
    public static String getFields() {

        List<Column> columns = new List<Column>();

        List<Schema.FieldSetMember> fieldSets = SObjectType.Contact.FieldSets.TestFieldSet.getFields();
  
        for (Schema.FieldSetMember sch : fieldSets) {
            Column col = new Column();
            col.label = sch.getLabel();
            col.fieldName = sch.getFieldPath();            
            col.editable = true;
            
            columns.add(col);
        }

        return JSON.serialize(columns);
    }
}