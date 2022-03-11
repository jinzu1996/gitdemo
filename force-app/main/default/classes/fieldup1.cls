public class fieldup1 
{
    public static integer val;
    public static void flo(list<BeatPlan__c> finval)
    {
        string nam;
        list<BeatPlan__c> currentval = new list<BeatPlan__c>();
        for(BeatPlan__c sd:finval)
        {
            nam = sd.Store_Account__c ;   
        }
        list<BeatPlan__c> beatval = [SELECT Id,Store_Account__c FROM BeatPlan__c where Store_Account__c =: nam ];
        val = beatval.size();
        list<Store_Account__c> afterval = [SELECT Count_Val__c, Name, Id FROM Store_Account__c where id =: nam];
        afterval[0].Count_Val__c = string.valueOf(val);
        update afterval;
    }
  /*  public static void report(list<BeatPlan__c> finval)
    {
        string executivename;
        executivename = finval[0].Executive_Name__c;
        list<BeatPlan__c> totalstore = [SELECT Id, Executive_Name__c, Store_Name__c, Store_Visit_Date__c, Status__c FROM BeatPlan__c where Executive_Name__c =:executivename and Store_Visit_Date__c = today ];
                list<BeatPlan__c> totalvisitstore = [SELECT Id, Executive_Name__c, Store_Name__c, Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where Executive_Name__c =:executivename and Store_Visit_Status__c = 'close' and Store_Visit_Date__c = today];
                        list<BeatPlan__c> totalvisitstoreopen = [SELECT Id, Executive_Name__c, Store_Name__c, Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where Executive_Name__c =:executivename and Store_Visit_Status__c = 'open' and Store_Visit_Date__c = today];
            Beat_Plan_Report__c newreport = new Beat_Plan_Report__c();
        	newreport.Executive_Name__c = executivename;
           	newreport.Total_No_of_Store_Assigned__c= totalstore.size();
            newreport.No_of_Store_Visited__c = totalvisitstore.size();
            newreport.No_of_Store_Not_Visited__c = totalvisitstoreopen.size();
            newreport.Date__c = date.today();
            insert newreport;    
    } */
  /*  public static void flo1(list<BeatPlan__c> finval)
    {
        string excutive;
        datetime strdate;
        for(BeatPlan__c sd:finval)
        {
            excutive = sd.Executive_Name__c;
                strdate = sd.Store_Visit_Date__c;
        }
        list<BeatPlan__c> oldvalue = [SELECT Id, Store_Visit_Status__c, Executive_Name__c, Store_Name__c, Store_Visit_Date__c FROM BeatPlan__c where Executive_Name__c =: excutive AND Store_Visit_Date__c =: strdate];
        if(oldvalue.size() > 0)
        {
            oldvalue[0].Executive_Name__c.addError('sorry!');
        //    excutive.addError('sorry!');
          //  system.addError('sorry!');
            
        }
        
    } */

}