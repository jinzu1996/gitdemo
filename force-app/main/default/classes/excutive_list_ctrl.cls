@RestResource(urlMapping='/Apiresponse1/*')
global with sharing class excutive_list_ctrl 
{
   @HttpGet
    global static list<BeatPlan__c> getval()
    {
            String invoiceId = RestContext.request.params.get('invoice_id');
            string excutivenam;
            
            List<User> uids = [SELECT Id, Username, LastName, FirstName, Name, CompanyName FROM User where Id = :invoiceId];
            excutivenam = uids[0].Name;
            List<BeatPlan__c> OppWrapperList = new List<BeatPlan__c>();        
            for(BeatPlan__c  accountObj : [SELECT Id,Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, Executive_Remark__c, Executive_Name__c,  Store_Visit_Date__c, Status__c,Store_Account__r.Stage__c,Store_Account__r.Store_Location__c, Store_Account__r.Disposition__c,Store_Account__r.name ,Store_Account__r.Address__c FROM BeatPlan__c where Store_Visit_Date__c =LAST_N_DAYS:6 AND Store_Visit_Date__c <= TODAY  And Executive_Name__c=:excutivenam Order by Store_Visit_Date__c DESC ])//Order by CreatedDate DESC
            {
                OppWrapperList.add(accountObj);
            }
            
            return OppWrapperList; 
        
            }
    
    @HTTPPut
    global static BeatPlan__c updatetbeat(string valid,double lat,double lon,datetime strenter,datetime strexit,Double ef,Double brand,Double wall, string re,string bas,boolean isEnterTime) 
    {
        if(isEnterTime == true)
        {
            system.debug('enter'+strenter+'exit'+strexit);
            map<string,string>  regparams = Restcontext.request.Params;
            string regid = regparams.get('Id');
            if(bas != null)
            {
                Blob tempBlob = EncodingUtil.base64Decode(bas);
                ContentVersion cv = new ContentVersion();
                cv.Title = 'Test Document';
                cv.PathOnClient = 'TestDocument.jpg';
                cv.VersionData = tempBlob;
                cv.IsMajorVersion = true;
                cv.Origin = 'H';
                Insert cv;
                
                //Get Content Documents
                Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
                
                //Create ContentDocumentLink 
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = regid;
                cdl.ContentDocumentId = conDocId;
                //  cdl.shareType = 'V';
                Insert cdl;
            }
            RestRequest req = RestContext.request;    
         
            BeatPlan__c sd = new BeatPlan__c();
            sd.Id = regid;
            sd.Store_Account__c = valid;
            Datetime GMTDate = system.now();
            sd.Store_Entry_Time__c = system.now();//datetime.valueOf(strConvertedDate);//.addHours(-6).addMinutes(31);
            sd.Entry_Store_Location__Latitude__s = lat;
            sd.Entry_Store_Location__Longitude__s = lon;
            update sd; 
            return sd;
        }
        else
        {
            map<string,string>  regparams = Restcontext.request.Params;
            string regid = regparams.get('Id');
            RestRequest req = RestContext.request;
            BeatPlan__c sd = new BeatPlan__c();
            sd.Id = regid;
            sd.Executive_Remark__c = re;
            sd.Brand_EMI__c = brand;
            sd.Wallet_EMI__c = wall;
            sd.EFT__c = ef;
            sd.Exit_Store_Location__Latitude__s = lat;
            sd.Exit_Store_Location__Longitude__s = lon;
            sd.Store_Exit_Time__c = system.now();
                //datetime.valueOf(strConvertedDate);//ateTime.valueOf(strexit);
            update sd;
            return sd;
        }       
    } 
    
}