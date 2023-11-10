import { LightningElement } from 'lwc';
import getCasesForAccount from '@salesforce/apex/SP_LwcHandler.getCasesForAccount';
import { NavigationMixin } from 'lightning/navigation';
import { bikes } from 'c/data';


// export default class List extends LightningElement
export default class List extends NavigationMixin(LightningElement) {
    bikes = bikes;
    cases;
    accountNumber = 'CD439877';
    caseNumberList;

    


    connectedCallback() {
        getCasesForAccount ({ accountNumber: this.accountNumber })
            .then((result) => {
                this.caseNumber = result[0].CaseNumber; 
                console.log('connectedCallback');
                console.log('result.CaseNumber ' + result[0].CaseNumber);
                console.log('result.AccountId ' + result[0].AccountId);
                console.log('caseNumber ' + this.caseNumber);
                this.cases = result;
            })
            .catch((error) => {
                console.log('In connected call back error....');
            });
    }

    handleTileClick(evt) {
        // This component wants to emit a productselected event to its parent
        const event = new CustomEvent('productselected', {
            detail: evt.detail
        });
        // Fire the event from c-list
        this.dispatchEvent(event);
    }

    handleClick(event) {
        const recordId = event.target.dataset.caseid;
        console.log('event.target.dataset.caseid ' + event.target.dataset.caseid);
        console.log('event.target.dataset.casesid ' + event.target.dataset.casesid);
        console.log('event.target.dataset.CaseId ' + event.target.dataset.CaseId);

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                actionName: "view",
                recordId: recordId
            }
        });
    }

    /*@wire (getCasesForAccount,{accountNumber: '$searchKey'}) accounts;
    handleKeyChange(event){
        this.bikes = event.target.value;
    }*/


}
