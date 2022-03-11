@isTest
public with sharing class excutive_list_ctrl_test 
{
    @isTest static void testGetCaseByI() 
    {
        string recordI = '005C5000000HxRxIAK';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://innovitipaymentsolutions--sandboxpar.lightning.force.com/services/apexrest/ReportApiresponse/';
        req.addParameter('invoice_id', recordI);
        req.addParameter('daily', 'daily');
        req.addParameter('weekly', 'weekly');
        req.httpMethod = 'GET';
        // RestContext.request.params.put('invoice_id', id1);
        RestContext.request = req;
        RestContext.response= res;
        test.startTest();
        map<string,integer> returnbeatplan = ReportApi.getval();
        System.assert(returnbeatplan != null);
        system.assertNotEquals(null, returnbeatplan.size());
        test.stopTest();
    }  
    
    @isTest static void testGetCaseById() 
    {
        string recordI = '005C5000000HxRxIAK';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://innovitipaymentsolutions--sandboxpar.lightning.force.com/services/apexrest/Apiresponse1/';
        req.addParameter('invoice_id', recordI);
        req.httpMethod = 'GET';
        // RestContext.request.params.put('invoice_id', id1);
        RestContext.request = req;
        RestContext.response= res;
        test.startTest();
        list<BeatPlan__c> returnbeatplan = excutive_list_ctrl.getval();
        System.assert(returnbeatplan != null);
        system.assertNotEquals(null, returnbeatplan.size());
        test.stopTest();
    }
    
    @isTest static void testUpsertCase() 
    {
        Store_Account__c sobj = new Store_Account__c(
            Name = 'Pavan Mart',                                                                                                                                 // Store Name
            UTID__c = 'C05287A1',                                                                                                                                               // UTID
            MBO_EBO__c = 'MBO',                                                                                                                                                 // Store Type
            Preferred_Brand__c = 'Samsung',                                                                                                                                     // Preferred Brand
            Status__c = 'ON TAP',                                                                                                                                               // Status
            Stage__c = 'On TAP',                                                                                                                                                // Stage
            Disposition__c = 'TAP',                                                                                                                                             // Disposition
            Oppo_Dealer_Code__c = '451000098',                                                                                                                                  // Oppo Dealer Code
            Samsung_Dealer_Code__c = 'KARD006457',                                                                                                                              // Samsung Dealer Code
            Xiaomi_Dealer_Code__c = 'Pending from CRO/Sal',                                                                                                                     // Xiaomi Dealer Code
            Vivo_Dealer_Code__c = 'KAR100263',                                                                                                                                  // Vivo Dealer Code
            Vivo_State_Code__c = 'INKA01',                                                                                                                                      // Vivo State Code
            Phone_No__c = '(959) 164-6197',                                                                                                                                     // Phone No
            City__c = 'BENGALURU',                                                                                                                                              // City
            Region__c = 'KARNATAKA',                                                                                                                                            // Region
            Address__c = 'GROUND FLOOR PADAM SHREE ENTERPRISES 1,NEAR ANJANEYASWAMY TEMPLE 1ST MAIN,GARUDACHARPALYA MAHADEVPURA,BENGALURU (BANGALORE) URBAN,KARNATAKA,560048',  // Address
            Pincode__c = '560048',                                                                                                                                              // Pincode
            Count_Val__c = '0'                                                                                                                                                 // Count Val
        );
        insert sobj;
        list<user> useval = [SELECT Id, Name FROM User where name IN ('gunaseelandemo k', 'Dinesh S') ];
        BeatPlan__c sobj1 = new BeatPlan__c(
            Store_Name__c = 'Pavan Mart',                            
            Executive_Name__c = 'gunaseelandemo k',                            
            //   Store_Visit_Date__c = Datetime.valueOf('12-31-2021, 5:30 AM:00'),  
            Store_Account__c = sobj.Id,                                   
            Store_Executive_Name__c = useval[0].id,                             
            //   Store_Entry_Time__c = Datetime.valueOf('5-23-2012, 11:55 PM:00'),  
            Brand_EMI__c = 30.00,                                             
            Wallet_EMI__c = 302,                                               
            EFT__c = 301.00                                                   
        );
        insert sobj1;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://innovitipaymentsolutions--sandboxpar.lightning.force.com/services/apexrest/Apiresponse1/';
        req.addParameter('Id', sobj1.Id);
        req.httpMethod = 'PUT';
        // RestContext.request.params.put('invoice_id', id1);
        RestContext.request = req;
        RestContext.response= res;
        blob file =  Blob.valueOf('sample text');
        blob x = blob.valueof('this is a test');
        string sf = EncodingUtil.base64Encode(x);
        
        // BeatPlan__c case1Id = excutive_list_ctrl.updatetbeat(sobj1.Store_Account__c,null,null,null,null,6876,786,6767,sf,true);
        //   BeatPlan__c case2Id = excutive_list_ctrl.updatetbeat(sobj1.Store_Account__c,null,null,null,null,6877,786,6767,sf,false);
        //  excutive_list_ctrl.updatetbeat(valid, lat, lon, strenter, strexit, ef, brand, wall, re, bas, isEnterTime)
        //  System.assert(Case1Id != Case2Id);
        //    BeatPlan__c case1 = [SELECT Id,Executive_Remark__c,Executive_Name__c FROM BeatPlan__c WHERE Id=:case1Id.Id];
        //    System.assert(case1 != null);
        //   System.assertEquals(case1.Executive_Remark__c, 'checked');
        // 2. Update status of existing record to Working
        
        //   BeatPlan__c case2Id = excutive_list_ctrl.updatetbeat(sobj1.Store_Account__c,null,null,null,null,6876,786,6767,sobj1.Executive_Remark__c,null,true);
        /*   BeatPlan__c case2 = [SELECT Id,Executive_Remark__c,Executive_Name__c FROM BeatPlan__c WHERE Id =:case2Id.Id];
System.assert(case2 != null);
System.assertEquals(case2.Executive_Remark__c, 'checked'); */
    }
}