import { LightningElement } from 'lwc';
import getData from '@salesforce/apex/dataTableLWC.getData';

const columns = [
    { label: 'Id', fieldName: 'id', type: 'id' },
    { label: 'Label', fieldName: 'name' },
    { label: 'Website', fieldName: 'website', type: 'url' },
    { label: 'Phone', fieldName: 'phone', type: 'phone' },
    { label: 'Balance', fieldName: 'amount', type: 'currency' },
    { label: 'CloseAt', fieldName: 'closeAt', type: 'date' },
];

const actions = [
    { label: 'Show details', name: 'show_details' },
    { label: 'Delete', name: 'delete' }
];

export default class DataTableComponent extends LightningElement {
    data = [];
    columns = columns;

    connectedCallback() {
        getData()
            .then((result) => {
                this.data = result; 
            })
            .catch((error) => {
                console.log('In connected call back error....');
            });
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'show_details':
                alert('Showing Details: ' + JSON.stringify(row));
                break;
            case 'delete':
                const rows = this.data;
                const rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);
                this.data = rows;
                break;
        }
    }
}