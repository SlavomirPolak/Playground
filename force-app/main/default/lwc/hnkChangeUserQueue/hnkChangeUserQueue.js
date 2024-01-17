import { LightningElement, track, wire, api } from 'lwc';
import getQueues from "@salesforce/apex/HNK_ChangeUserQueueHandler.getQueues";
import getUsersFromGroup from "@salesforce/apex/HNK_ChangeUserQueueHandler.getUsersFromGroup";
import getAllUsers from "@salesforce/apex/HNK_ChangeUserQueueHandler.getAllUsers";
import updateGroup from "@salesforce/apex/HNK_ChangeUserQueueHandler.updateGroup";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";
//import ChooseQ from "@salesforce/label/c.HNK_ChangeUserQueue_ChooseQ"; // add custom label
// ChooseUforQ, Save, Selected, ConfigureQ, Abailable

export default class ChangeUserQueue extends LightningElement {
    /*label = {
        ChooseQ,
        ChooseUforQ,
        Save,
        Selected,
        ConfigureQ,
        Abailable
    }*/

    @track controllingValues = [];
    @track options = [];
    @track defaultValues = [];
    @api idQueueSelected;
    getGroupMemberResult;
    mainPaneVisible;
    errorsPresent;
    errorMessage = 'ERROR';

    /**
     * @description Wired method. This method calls Apex method that gets all regular groups manageable by the current user, on the basis of his role.c/dataTableLWC
     * Method parse respone from Apex. If Data is present, method prepare panel to display groups. If data is not present main panel is not visible and error is shown.
     * @param {object} result contains values returned form apex
     * @param {error} result.error contains error value
     * @param {object} result.data contains queues form Apex method 
     */
    @wire(getQueues)
    wiredQueue({ error, data }) {
        if (data) {
            this.mainPaneVisible = true;
            this.errorsPresent = false;
            this.controllingValues = data.map((item) => {
                return { value: item.Id, label: item.Name };
            });
        } else if (error) {
            this.mainPaneVisible = false;
            this.errorsPresent = true;
        }
    }

    /**
     * @description Wired method. This method calls Apex method to gets the list of all users with a role which is child of to the current user's one (just one depth level).
     * Method parse response from Apex.
     * @param {object} value contains result of wired function
     * @param {object} value.data contains Users from Apex method
     * @param {object} value.error contains error value
     */
    @wire(getAllUsers)
    wiredAllUsers(value) {
        if (value.data) {
            this.options = value.data.map((item) => {
                return { value: item.Id, label: item.LastName + ", " + item.FirstName };
            });
            this.mainPaneVisible = true;
            this.errorsPresent = false;
        } else if (value.error) {
            this.mainPaneVisible = false;
            this.errorsPresent = true;
        }
    }

    /**
     * @description Wired method. This method calls Apex method that takes the id of a group and looks for the list of users which are members of the group.
     * Method parse response from Apex. If data is present, method parse result to display Users from Group.
     * @param {object} value contains result of wired function 
     */
    @wire(getUsersFromGroup, { idQueueSelected: "$idQueueSelected" })
    wiredUsers(value) {
        this.getGroupMemberResult = value;
        if (value.data) {
            this.defaultValues = value.data.map((item) => item.Id);
        } else if (value.error) {
            this.showToast(false, "ERROR retrieving users");
        }
    }

    /**
     * @description This method handles selection of Queue
     * @param {event} event contains event details
     */
    changeSelectedQueue(event) {
        this.defaultValues = [];
        this.idQueueSelected = event.detail.value;
    }

    /**
     * @description This method handles adding and removing Users to/from Group.
     * It calls Apex method that takes a list of users Ids and a group's Id and configures the group,
     * making the users passed as input its all and only members.
     * If exception is thrown during Apex processing error is shown in Toast.
     */
    changeGroupComposition() {
        updateGroup({ users: this.defaultValues, grId: this.idQueueSelected })
            .then((result) => {
                console.log('before');
                if (result === true) this.showToast(true, "Configuration confirmed!");
                else this.showToast(false, "ERROR 2");
                console.log('before apex refresh');
                refreshApex(this.getGroupMemberResult);
                console.log('after apex refresh');
            });
    }

    /**
     * @description This method handles change in values
     * @param {event} event contains event details
     */
    handleChange(event) {
        this.defaultValues = event.detail.value;
    }

    /**
     * @description This method show toast with success or error
     * @param {boolean} successOrNot decides if toast should be success or error
     * @param {string} message message contains message of the toast
     */
    showToast(successOrNot, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: successOrNot === true ? "Success" : "Error",
                message: message
            })
        );
    }
}