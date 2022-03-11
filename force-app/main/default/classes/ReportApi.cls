@RestResource(urlMapping='/ReportApiresponse/*')
global with sharing class ReportApi 
{
    @HttpGet
    global static map<string,integer> getval()
    {
        map<string,integer> reportpair = new map<string,integer>();
        integer TotalStoreAssign,planned,unplanned,plannedvisit,plannednotvisit,unplannedvisit,unplannednotvisit,Totalstorevisit;
        String invoiceId = RestContext.request.params.get('invoice_id');
        string daily = RestContext.request.params.get('daily'); 
        string weekly = RestContext.request.params.get('weekly');
        string excutivenam;
        list<integer> report =new list<integer>();
        
        List<User> uids = [SELECT Id, Username, LastName, FirstName, Name, CompanyName FROM User where Id = :invoiceId];
        excutivenam = uids[0].Name;
        if(daily == 'daily')
        {
            list<BeatPlan__c> TotalStoreAssignlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c = today and Executive_Name__c =: excutivenam ];
            reportpair.put('TotalStoreAssign', TotalStoreAssignlist.size());//chk
            
            list<BeatPlan__c> plannedstoreassignlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c = today and Branch_Manager_Name__c !=null and Executive_Name__c =: excutivenam ];
            reportpair.put('plannedstoreassign', plannedstoreassignlist.size());
            
            //list<BeatPlan__c> unplannedlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c = today and Branch_Manager_Name__c = null and Executive_Name__c =: excutivenam ];
           // reportpair.put('unplannedstoreassign', unplannedlist.size());
            
            list<BeatPlan__c> plannedvisitlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c = today and Branch_Manager_Name__c !=null and Store_Status__c ='Closed' and  Executive_Name__c =: excutivenam  ];
            reportpair.put('plannedvisit', plannedvisitlist.size());//ba

            
            list<BeatPlan__c> plannednotvisitlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c = today and Branch_Manager_Name__c !=null and Store_Status__c ='Open'and Executive_Name__c =: excutivenam ];
            reportpair.put('plannednotvisit', plannednotvisitlist.size()); //ba
            
            list<BeatPlan__c> unplannedvisitlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c = today and Branch_Manager_Name__c = null and Store_Status__c ='Closed' and Executive_Name__c =: excutivenam ];
            reportpair.put('unplannedvisit', unplannedvisitlist.size());
            
            //list<BeatPlan__c> unplannednotvisitlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c, Executive_Remark__c, Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c = today and Branch_Manager_Name__c = null and Store_Visit_Status__c ='Open'and  Executive_Name__c =: excutivenam ];
            //reportpair.put('unplannednotvisit', unplannednotvisitlist.size());
            
            list<BeatPlan__c> Totalstorevisitlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c = today and Store_Status__c ='Closed' and Executive_Name__c =: excutivenam ];
            reportpair.put('Totalstorevisit', Totalstorevisitlist.size()); 
            
            list<BeatPlan__c> Totalstorenotvisitlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c = today and ( Store_Status__c ='Open' or  Store_Status__c = ' In Progress') and Executive_Name__c =: excutivenam ];
            reportpair.put('Totalstorenotvisit', Totalstorenotvisitlist.size());
            
            list<BeatPlan__c> viscinity = [SELECT Id, Name, Visits_in_Vicinity_of_Store__c, Store_Status__c FROM BeatPlan__c where Store_Status__c ='Closed' and Store_Visit_Date__c = today  and Executive_Name__c =: excutivenam ];
            reportpair.put('viscinity', viscinity.size());
            
            list<BeatPlan__c> notviscinity = [SELECT Id, Name, Visits_not_in_Vicinity_of_Store__c , Store_Status__c FROM BeatPlan__c where Store_Status__c ='Closed' and Store_Visit_Date__c = today  and Executive_Name__c =: excutivenam  ];
            reportpair.put('notviscinity', notviscinity.size());
            
        }
        
        if(weekly == 'weekly')
        {
            list<BeatPlan__c> TotalStoreAssignlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c = LAST_N_DAYS:7 and Executive_Name__c =: excutivenam ];
            reportpair.put('TotalStoreAssign', TotalStoreAssignlist.size());//chk
            
            list<BeatPlan__c> plannedstoreassignlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c =  LAST_N_DAYS:7 and Branch_Manager_Name__c !=null and Executive_Name__c =: excutivenam ];
            reportpair.put('plannedstoreassign', plannedstoreassignlist.size());
            
           // list<BeatPlan__c> unplannedlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c =  LAST_N_DAYS:7 and Branch_Manager_Name__c = null and Executive_Name__c =: excutivenam ];
           // reportpair.put('unplannedstorevisit', unplannedlist.size());
            
            list<BeatPlan__c> plannedvisitlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c =  LAST_N_DAYS:7 and Branch_Manager_Name__c !=null and Store_Status__c ='Closed' and  Executive_Name__c =: excutivenam  ];
            reportpair.put('plannedvisit', plannedvisitlist.size());//ba

            
            list<BeatPlan__c> plannednotvisitlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c =  LAST_N_DAYS:7 and Branch_Manager_Name__c !=null and Store_Status__c ='Open'and Executive_Name__c =: excutivenam ];
            reportpair.put('plannednotvisit', plannednotvisitlist.size()); //ba
            
            list<BeatPlan__c> unplannedvisitlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c =  LAST_N_DAYS:7 and Branch_Manager_Name__c = null and Store_Status__c ='Closed' and Executive_Name__c =: excutivenam ];
            reportpair.put('unplannedvisit', unplannedvisitlist.size());
            
           // list<BeatPlan__c> unplannednotvisitlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c =  LAST_N_DAYS:7 and Branch_Manager_Name__c = null and Store_Visit_Status__c ='Open'and  Executive_Name__c =: excutivenam ];
           // reportpair.put('unplannednotvisit', unplannednotvisitlist.size());
            
            list<BeatPlan__c> Totalstorevisitlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c =  LAST_N_DAYS:7 and Store_Status__c ='Closed' and Executive_Name__c =: excutivenam ];
            reportpair.put('Totalstorevisit', Totalstorevisitlist.size()); 
            
            list<BeatPlan__c> Totalstorenotvisitlist = [SELECT Id, Name, Store_Visit_Date__c, Store_Executive_Name__c, Branch_Manager_Remark__c, Store_Entry_Time__c, Store_Exit_Time__c, Brand_EMI__c, Wallet_EMI__c, EFT__c,  Disposition__c, Stage__c, Executive_Name__c, Store_Location__Latitude__s, Store_Location__Longitude__s, Store_Location__c, Store_Account__c, Store_Stage__c, Store_Visit_Status__c, Exit_Store_Location__Latitude__s, Exit_Store_Location__Longitude__s, Exit_Store_Location__c, Entry_Store_Location__Latitude__s, Entry_Store_Location__Longitude__s, Entry_Store_Location__c, Store_Status__c, Status__c, Store_Disposition__c, Day_Assigned__c, Weekly_Assigned__c, Branch_Manager_Name__c FROM BeatPlan__c where Store_Visit_Date__c =  LAST_N_DAYS:7 and Store_Status__c ='Open' and Executive_Name__c =: excutivenam ];
            reportpair.put('Totalstorenotvisit', Totalstorenotvisitlist.size());
            
            list<BeatPlan__c> viscinity = [SELECT Id, Name, Visits_in_Vicinity_of_Store__c, Store_Status__c FROM BeatPlan__c where Store_Status__c ='Closed' and Store_Visit_Date__c =  LAST_N_DAYS:7  and Executive_Name__c =: excutivenam ];
            reportpair.put('viscinity', viscinity.size());
            
            list<BeatPlan__c> notviscinity = [SELECT Id, Name, Visits_not_in_Vicinity_of_Store__c , Store_Status__c FROM BeatPlan__c where Store_Status__c ='Closed' and Store_Visit_Date__c =  LAST_N_DAYS:7  and Executive_Name__c =: excutivenam  ];
            reportpair.put('notviscinity', notviscinity.size());
            
            
        }
        
        return reportpair;     
        
        
    }
}