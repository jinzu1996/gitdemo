@RestResource(urlMapping='/Apiresponse2/*')
global with sharing class clock_ctrl_list 
{
//    public virtual class BaseException extends Exception {}
    public class OtherException extends Exception 
    {
        public string test;
        public OtherException(string xyz,string fil)
        {
            test = xyz;
        }
    }
    @HttpGet
    global static boolean getval()
    {
        String invoiceId = RestContext.request.params.get('invoice_id');
        string excutivenam;
        
        List<User> uids = [SELECT Id, Username, LastName, FirstName, Name, CompanyName FROM User where Id = :invoiceId];
        excutivenam = uids[0].Name;
        
        
        
        List<Clock_Time__c> OppWrapperList = new List<Clock_Time__c>();
        List<Clock_Time__c>clockoutvalue = [SELECT Id, Name__c, Date__c, Clock_In__c, Clock_Out__c FROM Clock_Time__c where Date__c = TODAY  And Name__c =:excutivenam and Clock_Out__c != null];
        if(clockoutvalue.size() > 0 )
        {
            return false;
        }
        for(Clock_Time__c  accountObj : [SELECT Id, Name__c, Date__c, Clock_In__c, Clock_Out__c FROM Clock_Time__c  where Date__c = TODAY  And Name__c =:excutivenam  ])//Order by CreatedDate DESC
        {
            OppWrapperList.add(accountObj);
        }
        if(OppWrapperList.size()==0){
            
            return false;
        }
        else
        {
            return true;
        }
        
        
        
        
    }
    
    @HttpPost
    global static void createclock(double lat, double lon)
    {
        
            String invoiceId = RestContext.request.params.get('invoice_id');
            List<User> uids = [SELECT Id, Username, LastName, FirstName, Name, CompanyName FROM User where Id = :invoiceId];
            
            string excutivename = uids[0].Name;
            
            list<Clock_Time__c> sfd = [SELECT Id, Name__c, Date__c, Clock_In__c, Clock_Out__c  FROM Clock_Time__c where Date__c = today and Name__c =: excutivename];
   
            if(sfd.size() == 0)
            {
                clock_Time__c ins = new Clock_Time__c();
                ins.Name__c = excutivename;
                ins.Date__c= date.today();
                ins.Clock_In__c = system.now();
                ins.ClockIn_Location__Latitude__s = lat;
                ins.ClockIn_Location__Longitude__s = lon;
                insert ins;
            }
            else
            {
              throw new OtherException('Already Clocked In!');
             // throw new applicationException('You cant do that here');
            }

    }
    
    @HTTPPatch
    global static clock_Time__c updatetbeat(double lat,double lon) 
    {
        String invoiceId = RestContext.request.params.get('invoice_id');
        List<User> uids = [SELECT Id, Username, LastName, FirstName, Name, CompanyName FROM User where Id = :invoiceId];
        string excutivename = uids[0].Name;
        list<clock_Time__c> getclock = [SELECT Id, Name__c, Date__c, Clock_In__c, Clock_Out__c, ClockIn_Location__Latitude__s, ClockIn_Location__Longitude__s, ClockOut_Location__Latitude__s, ClockOut_Location__Longitude__s FROM Clock_Time__c where Name__c=:excutivename and Date__c=today ];
        clock_Time__c upclock = new clock_Time__c();
        upclock.id = getclock[0].id;
        upclock.Clock_Out__c = system.now();
        upclock.ClockOut_Location__Latitude__s = lat;
        upclock.ClockOut_Location__Longitude__s = lon;
        update upclock;   
        return upclock;
        
    }
    
}