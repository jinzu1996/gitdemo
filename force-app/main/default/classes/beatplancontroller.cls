public without sharing class beatplancontroller 
{
    /*
    @AuraEnabled
    public static list<Account> csvFileRead(Id contentDocumentId,string caseData ,string emailsubject, string emailbody, string status,id temp)
    {
        //saravana start
        system.debug('tempid'+temp);
        //saravana end
        system.debug('caseData--->'+caseData);
        system.debug('contentDocumentId--->'+contentDocumentId);
        system.debug('status--->'+status);
        
        list<Account> accountInsertList = new list<Account>();
        list<Account> accountInsertFinaLList = new list<Account>();
        list<case> caseInsertList = new list<case>();
        map<string,id> accWithPhoneMap = new map<string,id>();
        map<string,id> DublicateaccWithPhoneMap = new map<string,id>();
        Map<string,object> m = (Map<string, object>) JSON.deserializeUntyped(caseData);
        Map<string,object> caseDetails =(Map<string,object>) m.get('fields');

        if(contentDocumentId != null) 
        {    
            // Fetch File Data based on the basic of document id 
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            // split the file data
            list<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');
            
            string duplicateKey; 
            set<string> accEmailList = new set<string>();
            set<string> accNamesList = new set<string>();
            set<string> emailSet = new set<string>();
            //Tocheck:Senthil Account creation need to be commented and I assume case trigger will create the person account.
            //Tocheck:Senthil Instead of returning accounts created case created can be returned to UI
            ///Tocheck: Senthil Emails sent to the users would have atleast the case id and Descriotion. So it can to be processed with Case objects
            //Tocheck: FMZ_Exceptionlogger can be used to logged the log the errors in the component
            
            for(Integer i = 1; i < csvRecordsList.size(); i++)
            {
                Account accountObj = new Account();
                list<String> csvRowData = csvRecordsList[i].split(',');
                accountObj.Name = csvRowData[0];  
                accountObj.phone  = csvRowData[1];
                accountObj.Person_Email__c	 = csvRowData[2];
               // accountObj.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_Person_Account').getRecordTypeId();
                accNamesList.add(accountObj.Name);
                if(!AccEmailList.contains(accountObj.Person_Email__c ))
                    accountInsertList.add(accountObj);
                AccEmailList.add(accountObj.Person_Email__c	 );
                system.debug('AccEmailList===>'+AccEmailList);
            }
            system.debug('AccEmailList--->'+AccEmailList);
            for(account acc :[SELECT id, name, Phone, Person_Email__c	 FROM Account where Person_Email__c	 IN : AccEmailList ])
            {
                
                accWithPhoneMap.put(acc.Person_Email__c	 ,acc.id);   ///dub

            }
            system.debug('accWithPhoneMap--->'+accWithPhoneMap);
            for(Account accountval:accountInsertList) {
                if(!accWithPhoneMap.containskey(accountval.Person_Email__c	)){
                    accountInsertFinaLList.add(accountval);
                    system.debug(accountval.Person_Email__c	);
                }
                    
            }
            system.debug('accountInsertList---'+accountInsertList.size());
            Insert accountInsertFinaLList;

            for(Account accountval:accountInsertFinaLList) {
                if(!accWithPhoneMap.containskey(accountval.Person_Email__c	)){
                    accWithPhoneMap.put(accountval.Person_Email__c	,accountval.id);
                    system.debug('accWithPhoneMap====>'+accountval.Person_Email__c	);
                    system.debug('accWithPhoneMap'+accWithPhoneMap);
                }

                    
            }

            for(Integer i = 1; i < csvRecordsList.size(); i++)
             {
                case csObj = new case();
                list<String> csvRowData = csvRecordsList[i].split(',');
                    csObj.Subject = emailsubject;
                    csObj.origin = 'Email';
                   // csObj.Status = 'Solved';
                    //csObj.Ticket_Driver__c = TravelDetails;
                    csObj.Do_not_send_to_Stella__c = true;
                    csObj.Description = csvRowData[3];
                    csObj.AccountId = accWithPhoneMap.get(csvRowData[2]);
                    csObj.Tier__c = (string)caseDetails.get('Tier__c');
                    csObj.Group_Family__c = (string) caseDetails.get('Group_Family__c');
                    csObj.Group_Skill__c =(string) caseDetails.get('Group_Skill__c');
                    csObj.Ticket_Driver_Level_1__c = (string) caseDetails.get('Ticket_Driver_Level_1__c');
                    csObj.Ticket_Driver_Level_2__c = (string) caseDetails.get('Ticket_Driver_Level_2__c');
                    csObj.Ticket_Driver_Level_3__c = (string) caseDetails.get('Ticket_Driver_Level_3__c');
                    csObj.Ticket_Driver_Level_4__c = (string) caseDetails.get('Ticket_Driver_Level_4__c');
                    csObj.Ticket_Driver_Level_5__c = (string) caseDetails.get('Ticket_Driver_Level_5__c');
                    csObj.status = status;
                    emailSet.add(csvRowData[2]);
                    caseInsertList.add(csObj);
                    //csvmailnotify(csvRowData[2],emailsubject,emailbody);
                
               
            }
           insert caseInsertList;
           csvmailnotify(caseInsertList, emailsubject,emailbody,temp );
          
        }
        return accountInsertFinaLList;    
    }
    public static void csvmailnotify(list<case> caseList, string emailsubject, string emailbody,id temp)
    { 
       // system.debug('temp = '+temp);
       id userinfoid=[select firstname from user where id=:userinfo.getuserid()].id;
        list<messaging.SingleEmailMessage> sendEmailList = new list<messaging.SingleEmailMessage> ();
        orgwideemailaddress owea = [select id,address from orgwideemailaddress where address = 'help@robinhood.com'];
        list<string> emailList = new list<string>();
        list<emailmessage> emailMsgList = new list<emailmessage>();
        set<id> caseIds = new set<id>();
        for(case cs : caseList){
            caseIds.add(cs.id);
        }
        for(case cs : [select id,account.Person_Email__c from case where id IN: caseIds]){
            system.debug('email----'+cs.account.Person_Email__c	);
            if(cs.account.Person_Email__c	 != null){
                messaging.SingleEmailMessage sendmail = new messaging.SingleEmailMessage();       
                sendmail.setSubject(emailsubject);
                //saravana start(23/8/21)
                //EmailTemplate emailTemplate = [Select Id,Subject,Description,Name,Body from EmailTemplate where name = 'case fields'];
                sendmail.setTargetObjectId(userinfoid); 
              //  0056g000006GYeKAAW
                //    2F0056g000006GYeK
                sendmail.setTemplateID(temp); 
                sendmail.setWhatId(cs.id); 
                sendmail.setSaveAsActivity(false);
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {sendmail};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
               //end
                String body =emailbody ;
                sendmail.setOrgWideEmailAddressId(owea.Id);
                sendmail.setHtmlBody(body);     
                string[] usermail =new string[] {cs.account.Person_Email__c	};
                sendmail.setToAddresses(usermail);
                sendEmailList.add(sendmail);
                emailmessage em = new emailmessage();
                em.subject = emailsubject;
                em.textbody = emailbody;
                em.parentid = cs.Id;
                em.HtmlBody = emailbody;
                em.toaddress = cs.account.Person_Email__c;
                em.ValidatedFromAddress = owea.address;
                emailMsgList.add(em);
    
                emailList.add(cs.account.Person_Email__c);
            
            }
        }
        messaging.sendEmail(sendEmailList); 
        if(emailMsgList != null && emailMsgList.size()>0)
            insert emailMsgList;
            
    }

    @AuraEnabled(cacheable=true)
    public static string getSampleCsv() {
        string docID = [SELECT ContentDocumentId, FileExtension, Title 
        FROM ContentVersion WHERE Title = 'TemplateCSV' limit 1].ContentDocumentId;
        
       
        return docID;
    } */


}