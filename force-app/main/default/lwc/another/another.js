import { LightningElement, wire, track, api } from 'lwc';
import fetchAssetRenOpp from '@salesforce/apex/OpportunityCls.fetchAssetRenOpp';
import csvFileRead from '@salesforce/apex/OpportunityCls.csvFileRead';

import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Store_Account__c';
import {getPicklistValues} from 'lightning/uiObjectInfoApi';
import SLA_FIELD from '@salesforce/schema/Store_Account__c.Executive_Name__c';
import UPSELL_FIELD from '@salesforce/schema/Store_Account__c.Location__c';

// import fetchMetaListLwc from '@salesforce/apex/OpportunityCls.fetchMetaListLwc';
import createrec from '@salesforce/apex/OpportunityCls.createrec';
import updaterec from '@salesforce/apex/OpportunityCls.updaterec';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';

import MODALSTYLE from "@salesforce/resourceUrl/ko";
import { loadStyle } from "lightning/platformResourceLoader";
// datatable columns

const actions = [
    { label: 'View', name: 'view' },
    //{ label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const RENEWALSTAOPTIONS = [
    {value: 'Renewed', label: 'Renewed'},
    {value: 'Churn', label: 'Churn'},
    {value: 'Upgraded', label: 'Upgraded'}
    
];

export default class Executivevi extends NavigationMixin(LightningElement)
{

    get acceptedFormats() {
        return ['.csv'];
    }

    // handleUploadFinished(event) {
    //     // Get the list of uploaded files
    //     const uploadedFiles = event.detail.files;
    //     // alert('No. of files uploaded : ' + uploadedFiles.length);
    //     this.filesUploaded = event.detail.files;
    //     console.log('uploadedFiles',JSON.stringify(this.filesUploaded));
    // }



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
        this.pickval = event.target.value;
    }


    //------------------
    value = 'inProgress';

    @track records;

    @track contactsRecord;
    searchKey = '';
    @track pickval = 'Karnataka';
    selectedLabel = 6;

    filesUploaded = [];



    @track totalContacts;
    @track visibleContacts;

    @track rep = [];

  //  @track Buttontrue=true; disabled={Buttontrue}

  @track orglis;
    @track myList;
    @track myList2;
    @track records;
    @track records1;
    saveDraftValues = [];
    @api recordId;
    @track wiredsObjectData;
    @track showLoadingSpinner = false;
    @api objectApiName;
    @track oppRecord = {};
    @track oppRecord1 = {};
    @track Renewal_Status;
    @track Renewal_Term_Months;
    @track daysList=[];
    @track tod;
    @track thi;
    @track sec;
    @track fou;
    @track fiv;
    @track six;
    @track sev;
    @track newrecs;
    @track oppid;
    @track sta;
    @track sto;
    @track loader = false;
    @track error = null;
    @track pageSize = 10;
    @track pageNumber = 1;
    @track totalRecords = 0;
    @track totalPages = 0;
    @track recordEnd = 0;
    @track recordStart = 0;
    @track isPrev = true;
    @track isNext = true;
    @track accounts = [];
    @track numberOfRecords = 6;
    @track days = [];

    
    
    connectedCallback()
    {
        function formatDate(date)
        {
            var dd = date.getDate();
            var mm = date.toLocaleString('default', { month: 'short' });
            if(dd<10) {dd='0'+dd}
            if(mm<10) {mm='0'+mm}
            date = dd+'-'+mm;
            return date
        }

        var result = [];
        this.getResults();
        for (var i=0; i<7; i++) 
        {
            var d = new Date();
            d.setDate(d.getDate() - i);
            result.push( formatDate(d) )
        }

        loadStyle(this, MODALSTYLE);
    
            this.tod = result[0];
            this.thi = result[1];   
            this.sec = result[2];
            this.fou = result[3];
            this.fiv = result[4];
            this.six = result[5];
            this.sev = result[6];
    }

    handleKeyChange(event) {
        const searchValue = event.target.value;
            this.searchKey = searchValue;
    }
    
    get options() {
        return [
            { label: 'Last 1-6', value: '6' },
            { label: 'Last 7-12', value: '12' },
            { label: 'Last 13-18', value: '18' },
            { label: 'Last 19-24', value: '24' },
            { label: 'Last 25-30', value: '30' },
        ];
    }

    handleChangeyu(event) {
        this.selectedLabel = event.target.options.find(opt => opt.value === event.detail.value).value;
      //  console.log("@@@@", this.selectedLabel);
      //  console.log(this.days);
        this.getResults(this.selectedLabel);
      //  console.log('Populate results wired Objects data -- ', this.wiredsObjectData);
        this.populateResults(this.wiredsObjectData);
    }

    handlechildChange2(event)
    {
            // this.oppi = event.target.dataset.targetId;
            const fiel = event.target.value;         
            this.pickval = fiel;
    }

    formatDate(date){
            var dd = date.getDate();
            var mm = date.toLocaleString('default', { month: 'short' });
            if(dd<10) {dd='0'+dd}
            if(mm<10) {mm='0'+mm}
            date = dd+'-'+mm;
            return date
    }

    getResults(input){
        var val = Number(this.selectedLabel)-6;
        var ds = [];
        for (let index = 0; index < 6; index++) {
            var dia1 = new Date();
            dia1.setDate(dia1.getDate()-val);
            dia1.setHours(0,0,0,0);
            ds.push(this.formatDate(dia1));
            val++;
        }
        this.days=ds;
    }

    populateResults(data){
        var val = Number(this.selectedLabel)-6;
        var currentData = [];
        data.data.forEach((row) => 
            {
                        let rowData = { 
                            to : "N/A"+"🔵",
                            ye  : "N/A"+"🔵",
                            ye1 : "N/A"+"🔵",
                            ye2 : "N/A"+"🔵",
                            ye3 : "N/A"+"🔵",
                            ye4 : "N/A"+"🔵",
                            ye5 :  "N/A"+"🔵",
                            ye6 :  "N/A"+"🔵"};
                        if(row != '' && row != null && row != 'null' && row != 'undefined' && row != undefined)
                        {
                            rowData.Id =  row.Id;
                            rowData.Name = row.Name;
                            rowData.Stage__c = row.Stage__c;
                            rowData.Disposition__c = row.Disposition__c;
                            rowData.UTID__c = row.UTID__c;
                            rowData.Executive_Name__c = row.Executive_Name__c;
                            if(row.BeatPlans__r != '' && row.BeatPlans__r != null && row.BeatPlans__r != 'null' && row.BeatPlans__r != 'undefined' && row.BeatPlans__r != undefined)
                            {
                                

                                row.BeatPlans__r.forEach((row1) => 
                                {
                                    var dwaa = row1.Id;
                                    rowData.ye6 = row1.Weekly_Assigned__c;
                                    var chk = row1.Store_Visit_Status__c;
                                    var chk1 = row1.Executive_Name__c;//Status__c;
                                    var text;
                                    switch(chk) 
                                    {
                                        case "Open":
                                            text =   "🔴 ";
                                        break;
                                        case "In Progress":
                                            text =  " 🟡";;
                                        break;
                                        case "Closed":
                                            text = " 🟢";;
                                        break;
                                      }
                                    var re = text + chk1;//String.fromCodePoint(
                          // let amountColor = item.Status__c == "OPEN" ? "slds-text-color_error":"slds-text-color_success"
                                    var today = new Date();
                                    today.setHours(0,0,0,0);
                                
                                    var dia = new Date();
                                    dia.setDate(dia.getDate()-(val+0));
                                    dia.setHours(0,0,0,0);
                                    var dia1 = new Date();
                                    dia1.setDate(dia1.getDate()-(val+1));
                                    dia1.setHours(0,0,0,0);
                                    var dia2 = new Date();
                                    dia2.setDate(dia2.getDate()-(val+2));
                                    dia2.setHours(0,0,0,0);
                                    var dia3 = new Date();
                                    dia3.setDate(dia3.getDate()-(val+3));
                                    dia3.setHours(0,0,0,0);
                                    var dia4 = new Date();
                                    dia4.setDate(dia4.getDate()-(val+4));
                                    dia4.setHours(0,0,0,0);
                                    var dia5 = new Date();
                                    dia5.setDate(dia5.getDate()-(val+5));
                                    dia5.setHours(0,0,0,0);
                                    var dia6 = new Date();
                                    dia6.setDate(dia6.getDate()-(val+6));
                                    dia6.setHours(0,0,0,0);
                                    
                                var ot = new Date(row1.Store_Visit_Date__c);
                                ot.setHours(0,0,0,0);
                                    if(dia.getTime() == ot.getTime())
                                    {
                                        rowData.to = re; 
                                        rowData.da = dwaa;
                                    }
                                    else if(dia1.getTime() == ot.getTime())
                                    {
                                        rowData.ye = re;
                                        // this.thi1 = row1.Store_Visit_Status__c;
                                    }
                                    else if(dia2.getTime() == ot.getTime())
                                    {
                                        rowData.ye1 = re;
                                    }
                                    else if(dia3.getTime() == ot.getTime())
                                    {
                                        rowData.ye2 = re;
                                    }
                                    else if(dia4.getTime() == ot.getTime())
                                    {
                                        rowData.ye3 = re;
                                    }
                                    else if(dia5.getTime() == ot.getTime())
                                    {
                                        rowData.ye4 = re;
                                    }
                                    else if(dia6.getTime() == ot.getTime())
                                    {
                                        rowData.ye5 = re;
                                    }
                                })
                            }
                            
                        }
                        currentData.push(rowData);
                       // this.records = currentData;
                        for(let i = 0; i < currentData.length; i++) 
                        {
                          if(currentData[i].Id)
                          currentData[i].recordUrl = `/${currentData[i].Id}`;
                      }
                    
            });
            console.log('PR - ', currentData);
            this.records = currentData;
            this.records1 = currentData;
            this.myList = currentData;
            this.totalContacts = currentData; 
            return currentData;
    }
    

    @wire(fetchAssetRenOpp, { keyval: '$searchKey',pickli: '$pickval'  })//pickli: this.selectedLabel pickli: '$pickval'
    wiredSobjects(result) 
    {
        this.showLoadingSpinner = true;
        this.wiredsObjectData = result;
        if(result.data) 
        {
            this.orglis = result.data;
            let currentData = [];
            var test = this.populateResults(result);
        }
        this.showLoadingSpinner = false;
    }
    updateContactHandler(event)
    {
        this.visibleContacts=[...event.detail.records]
    }

    redirectToReport0(event) 
    {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: '00O9I0000000h6bUAA',
                objectApiName: 'Report',
                actionName: 'view',
            },
        }).then(url => {
             window.open(url);
        });
    }

    handleUploadFinished(event) 
    {
        // Get the list of records from the uploaded files
        const uploadedFiles = event.detail.files;
        console.log(uploadedFiles);
        // calling apex class csvFileread method
        csvFileRead({contentDocumentId : uploadedFiles[0].documentId})
        .then(result => {
            window.console.log('result ===> '+result);
            this.data = result;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Accounts are created according to the CSV file upload!!!',
                    variant: 'Success',
                }),
            );
        })
        .catch(error => {
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: JSON.stringify(error),
                    variant: 'error',
                }),
            );     
        })

    }


    handlechildChange(event)
    {
            let Id = event.target.dataset.targetId;
            let field = event.target.name;

            console.log("test",Id);
            console.log("test",field);
            let newrecs = [];
        for(let rec of this.records)
        {
            let objnew = Object.assign({}, rec);
            if(rec.Id == Id)
            {
                objnew[field] = event.target.value;
            }
            newrecs.push(objnew);
        }
        console.log('klllllllllllllllllllll',newrecs);
        this.records = newrecs;
    }
    handlechildChange1(event)
    {
            // this.oppi = event.target.dataset.targetId;
            // this.fiel = event.target.value;     
            let Id = event.target.dataset.targetId;
            let field = event.target.name;
            console.log("test",Id);
            console.log("test",field);

            let newrecs1 = [];
        for(let rec of this.records1)
        {
            let objnew = Object.assign({}, rec);
            if(rec.Id == Id)
            {
                console.log("check",event.target.value);
                objnew[field] = event.target.value;
            }
            newrecs1.push(objnew);
        }
        this.records1 = newrecs1;      
    }

    

    handleup() 
    {
        this.showLoadingSpinner = true;
        let oprec = [];
        let stageNme = this.template.querySelector(".stageNme");
        let forecastCat = this.template.querySelector(".forecastCat");
        let agrType = this.template.querySelector(".agrType");
        let annUSD  = this.template.querySelector(".annUSD");
        let annUSD1  = this.template.querySelector(".annUSD1");

            updaterec({storeid: this.oppi,excutivename:this.fiel })
            .then(result => {
                this.showLoadingSpinner = false;
     
                // showing success message
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Excutive name change sucessfully'+ ' To '+this.fiel,
                    variant: 'success'
                }),);
                setTimeout(function() { window.location=window.location;},2000);
                // refreshing table data using refresh apex
                 return refreshApex(this.wiredsObjectData);
                 //this.dispatchEvent(new CloseActionScreenEvent());
     
            })
            .catch(error => {
                this.showLoadingSpinner = false;
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error!!', 
                    message: 'Not a Valid Assign!', 
                    variant: 'error'
                }),);
            });
        
    }

    // handleup1() 
    // {
    //     this.showLoadingSpinner = true;
    //     let oprec = [];
    //     let stageNme = this.template.querySelector(".stageNme");
    //     let forecastCat = this.template.querySelector(".forecastCat");
    //     let agrType = this.template.querySelector(".agrType");
    //     let annUSD  = this.template.querySelector(".annUSD");
    //     let annUSD1  = this.template.querySelector(".annUSD1");
    //         createrec({storeid: this.oppi1,excutivename:this.fie})//inval: this.oppi1,storenam:this.fie,sf:this.rep
    //         .then(result => {
    //             this.showLoadingSpinner = false;
    //             // showing success message
    //             this.dispatchEvent(new ShowToastEvent({
    //                 title: 'Success!!',
    //                 message: ' Store Assigned Sucessfully' +" To "+this.fie,
    //                 variant: 'success'
    //             }),);
                
    //             setTimeout(function() { window.location=window.location;},2000);
    //             // refreshing table data using refresh apex
    //              return refreshApex(this.wiredsObjectData);
    //              //this.dispatchEvent(new CloseActionScreenEvent());
     
    //         })
    //         .catch(error => {
    //             this.showLoadingSpinner = false;
    //             this.dispatchEvent(new ShowToastEvent({
    //                 title: 'Error!!', 
    //                 message: 'Not a Valid Assign!', 
    //                 variant: 'error'
    //             }),);
    //         });
        
    // }
    refreshComponent(event){
        eval("$A.get('e.force:refreshView').fire();");
    }

    async refresh() 
    {
        await refreshApex(this.wiredsObjectData);
    }


    handleSave(event) 
    {
        this.showLoadingSpinner = true;
            console.log('@@ this.records'+ JSON.stringify(this.records));
           createrec({sf:this.records}) //updateAursOpp({lstAurIds: this.records, fieldName : oppRec}) storeid: this.oppi1,excutivename:this.fie
            .then(result => {
                window.console.log('result ====> ' + result);
                this.showLoadingSpinner = false;
     
                // showing success message
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Record Created sucessfully',
                    variant: 'success'
                }),);
         //      setTimeout(function() { window.location=window.location;},2000);
                // refreshing table data using refresh apex
                 return refreshApex(this.wiredsObjectData);
                 //this.dispatchEvent(new CloseActionScreenEvent());
     
            })
            .catch(error => {
                console.log( 'Error is @@' + JSON.stringify( error ) );
                this.showLoadingSpinner = false;
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Not a Valid Assign!', 
                    message: error.message, 
                    variant: 'error'
                }),);
            });
            // Updateing the records using the UiRecordAPi
            /*const promises = recordInputs.map(recordInput => updateRecord(recordInput));
            Promise.all(promises).then(res => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Records Updated Successfully!!',
                        variant: 'success'
                    })
                );
                this.saveDraftValues = [];
                return this.refresh();
            }).catch(error => {
                console.log( 'Error is ' + JSON.stringify( error ) );
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message:error.message,
                        variant: 'error'
                    })
                );
            }).finally(() => {
                this.saveDraftValues = [];
            });*/
        }


        handleSave1(event) 
        {
            this.showLoadingSpinner = true;
            updaterec({sf:this.records1}) //updateAursOpp({lstAurIds: this.records, fieldName : oppRec}) storeid: this.oppi1,excutivename:this.fie
                .then(result => {
                    window.console.log('result ====> ' + result);
                    this.showLoadingSpinner = false;
         
                    // showing success message
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Success!!',
                        message: 'Excutive name change sucessfully',
                        variant: 'success'
                    }),);
             //      setTimeout(function() { window.location=window.location;},2000);
                    // refreshing table data using refresh apex
                     return refreshApex(this.wiredsObjectData);
                     //this.dispatchEvent(new CloseActionScreenEvent());
         
                })
                .catch(error => {
                    console.log( 'Error is @@' + JSON.stringify( error ) );
                    this.showLoadingSpinner = false;
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Not a Valid Assign!', 
                        message: error.message, 
                        variant: 'error'
                    }),);
                });
                // Updateing the records using the UiRecordAPi
                /*const promises = recordInputs.map(recordInput => updateRecord(recordInput));
                Promise.all(promises).then(res => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Records Updated Successfully!!',
                            variant: 'success'
                        })
                    );
                    this.saveDraftValues = [];
                    return this.refresh();
                }).catch(error => {
                    console.log( 'Error is ' + JSON.stringify( error ) );
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message:error.message,
                            variant: 'error'
                        })
                    );
                }).finally(() => {
                    this.saveDraftValues = [];
                });*/
            }

    //important update
    editAUR(event){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.value,
                objectApiName: 'Store_Visit__c',
                actionName: 'edit'
            }
        });
    }
    viewAUR(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'BeatPlan__c',
                actionName: 'new'
            }
        });
    }
    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    
    
}