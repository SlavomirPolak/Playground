import { LightningElement, wire } from 'lwc';
import getRelatedContacts from "@salesforce/apex/NN_ConnectAccountAndContactHandler.getRelatedContacts";
import getAccounts from "@salesforce/apex/NN_ConnectAccountAndContactHandler.getAccounts";

export default class NnConnectAccountAndContact extends LightningElement {

    
    @wire(getAccounts)
    wiredQueue({ data }) {
            this.controllingValues = data.map((item) => {
                return { value: item.Id, label: item.Name };
            });
    }

}