import { LightningElement,wire, api, track  } from 'lwc';

import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Store_Account__c';
import {getPicklistValues} from 'lightning/uiObjectInfoApi';
import SLA_FIELD from '@salesforce/schema/Store_Account__c.Executive_Name__c';
import UPSELL_FIELD from '@salesforce/schema/Store_Account__c.Location__c';

export default class Testdependentpicklist extends LightningElement {
    @wire(getObjectInfo, {objectApiName: ACCOUNT_OBJECT })
    accountInfo;

    @track slaOptions;
    @track upsellOptions;

    @wire(getPicklistValues, {recordTypeId: '$accountInfo.data.defaultRecordTypeId', fieldApiName: SLA_FIELD })
    slaFieldInfo({ data, error }) 
    {
        if (data) this.slaFieldData = data;
    }
    @wire(getPicklistValues, {recordTypeId:'$accountInfo.data.defaultRecordTypeId', fieldApiName: UPSELL_FIELD })
    upsellFieldInfo({ data, error }) 
    {
        if (data) this.upsellOptions = data.values;
    }
    handleUpsellChange(event) 
    {
        let key = this.slaFieldData.controllerValues[event.target.value];
        this.slaOptions = this.slaFieldData.values.filter(opt => opt.validFor.includes(key));
    }
}