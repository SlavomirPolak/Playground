import { LightningElement, wire, api } from "lwc";
import getContacts from "@salesforce/apex/ContactController.getContacts";
import getFields from "@salesforce/apex/ContactController.getFields";
import { refreshApex } from "@salesforce/apex";
import { updateRecord } from "lightning/uiRecordApi";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import FIRSTNAME_FIELD from "@salesforce/schema/Contact.FirstName";
import LASTNAME_FIELD from "@salesforce/schema/Contact.LastName";
import TITLE_FIELD from "@salesforce/schema/Contact.Title";
import PHONE_FIELD from "@salesforce/schema/Contact.Phone";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
import ID_FIELD from "@salesforce/schema/Contact.Id";

const COLS = [
  {
    label: "First Name",
    fieldName: FIRSTNAME_FIELD.fieldApiName,
    editable: true,
  },
  {
    label: "Last Name",
    fieldName: LASTNAME_FIELD.fieldApiName,
    editable: true,
  },
  { label: "Title", fieldName: TITLE_FIELD.fieldApiName, editable: true },
  {
    label: "Phone",
    fieldName: PHONE_FIELD.fieldApiName,
    type: "phone",
    editable: true,
  },
  {
    label: "Email",
    fieldName: EMAIL_FIELD.fieldApiName,
    type: "email",
    editable: true,
  },
];
export default class DataTableEne extends LightningElement {
  @api recordId;
  @api accountId;
  @api columns;
  columns = COLS; //List<Schema.FieldSetMember>
  //columns = getFields(); //SObjectType.Contact.FieldSets.TestFieldSet.getFields();
  draftValues = [];

  @wire(getContacts, { accId: "$accountId" })
  contacts;

  //console.log(text);

 /* array1.forEach((element) => console.log(element));

  getFields() {
      columns = SObjectType.Contact.FieldSets.TestFieldSet.getFields();

      //array1.forEach((element) => console.log(element));
      for (columns.forEach((element) => prepareColumn()));
  }*/

  // just a comment

  async handleSave(event) {
    // Convert datatable draft values into record objects
    const records = event.detail.draftValues.slice().map((draftValue) => {
      const fields = Object.assign({}, draftValue);
      return { fields };
    });

    // Clear all datatable draft values
    this.draftValues = [];

    try {
      // Update all records in parallel thanks to the UI API
      const recordUpdatePromises = records.map((record) => updateRecord(record));
      await Promise.all(recordUpdatePromises);

      // Report success with a toast
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Success",
          message: "Contacts updated",
          variant: "success",
        }),
      );

      // Display fresh data in the datatable
      await refreshApex(this.contacts);
    } catch (error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error updating or reloading contacts",
          message: error.body.message,
          variant: "error",
        }),
      );
    }
  }
}





