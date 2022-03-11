public class fieldupreport 
{
    public static void report(list<BeatPlan__c> finval)
    {
        string executivename;
        executivename = finval[0].Executive_Name__c;
                list<Beat_Plan_Report_Daily__c> beatdaily =  [SELECT Id, Executive_Name__c, Total_No_of_Store_Not_Visited__c, Total_No_of_Store_Visited__c, Single_Day_Assigned_Stores__c, Date__c, Name  FROM Beat_Plan_Report_Daily__c where Executive_Name__c =: executivename and Date__c = Today ];
        list<Beat_Plan_Report_Daily__c> sd = new list<Beat_Plan_Report_Daily__c>();
        list<Beat_Plan_Report_Daily__c> up = new list<Beat_Plan_Report_Daily__c>();
        list<Beat_Plan_Report_Daily__c> reportval1 =  [SELECT Id, Executive_Name__c, Total_No_of_Store_Not_Visited__c, Total_No_of_Store_Visited__c, Single_Day_Assigned_Stores__c, Date__c, Name  FROM Beat_Plan_Report_Daily__c where Executive_Name__c =: executivename and Date__c = THIS_WEEK ];
        integer filesize1 = reportval1.size();
        
        date dateval = date.today();
        integer cnt = 0;
        Datetime dt = System.now();
        String day=dt.format('EEEE');
        
        if(day == 'Saturday' )
        {
            cnt = 2;
        }
        else if(day=='Sunday')
        {
            cnt = 1;
        }
        else if(day=='monday')
        {
            cnt = 7;
        }
        else if(day=='tuesday')
        {
            cnt = 6;
        }
        else if(day=='wednesday')
        {
            cnt = 5;
        }
        else if(day=='thursday')
        {
            cnt = 4;
        }
        else if(day=='friday')
        {
            cnt = 3;
        }
        list<Beat_Plan_Report__c> dub = new list<Beat_Plan_Report__c>();
        list<Beat_Plan_Report__c> reportval =  [SELECT Id, Name, Date__c, Executive_Name__c, Total_No_of_Store_Assigned__c, No_of_Store_Visited__c, No_of_Store_Not_Visited__c  FROM Beat_Plan_Report__c where Executive_Name__c =: executivename and Date__c = THIS_WEEK ];
        integer filesize = reportval.size();
        list<BeatPlan__c> totalstore = [SELECT Id, Executive_Name__c, Store_Name__c, Store_Visit_Date__c FROM BeatPlan__c where Executive_Name__c =:executivename and Store_Visit_Date__c = today ];
        list<BeatPlan__c> totalvisitstore = [SELECT Id, Executive_Name__c, Store_Name__c, Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where Executive_Name__c =:executivename and Store_Visit_Status__c = 'closed' and Store_Visit_Date__c = today];
        list<BeatPlan__c> totalvisitstoreopen = [SELECT Id, Executive_Name__c, Store_Name__c, Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where Executive_Name__c =:executivename and (Store_Visit_Status__c = 'open' or Store_Visit_Status__c = 'In Progress') and Store_Visit_Date__c = today];
        if(filesize == 0)
        {
            Beat_Plan_Report__c newreport = new Beat_Plan_Report__c();
            newreport.Date__c = Date.today();
            newreport.Executive_Name__c = executivename;
            newreport.Total_No_of_Store_Assigned__c= totalstore.size();
            newreport.No_of_Store_Visited__c = totalvisitstore.size(); 
            newreport.No_of_Store_Not_Visited__c = totalvisitstoreopen.size();
            newreport.Single_Day_Assgined_Stores__c = 0;
            newreport.Single_Day_Store_Not_Visited__c = 0;
            newreport.Single_Day_Store_Visited__c = 0;
            newreport.Date__c = date.today();
            insert newreport;             
        }
        else
        {
            // list<BeatPlan__c> singledayassign = [SELECT Id, Executive_Name__c, Store_Name__c, Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where Executive_Name__c =:executivename and Store_Visit_Date__c = today];
            list<BeatPlan__c> totalstore1 = [SELECT Id, Executive_Name__c, Store_Name__c, Store_Visit_Date__c FROM BeatPlan__c where Executive_Name__c =:executivename and Store_Visit_Date__c = today and Day_Assigned__c !=: executivename ];
            list<BeatPlan__c> totalvisitstore1 = [SELECT Id, Executive_Name__c, Store_Name__c, Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where Executive_Name__c =:executivename and Store_Visit_Status__c = 'closed' and Store_Visit_Date__c = today and Day_Assigned__c !=: executivename];
            list<BeatPlan__c> totalvisitstoreopen1 = [SELECT Id, Executive_Name__c, Store_Name__c, Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where Executive_Name__c =:executivename and (Store_Visit_Status__c = 'open' or Store_Visit_Status__c = 'In Progress') and Store_Visit_Date__c = today and Day_Assigned__c !=: executivename];
            Beat_Plan_Report__c newreport1 = new Beat_Plan_Report__c();
            newreport1.id = reportval[0].Id;
            newreport1.Total_No_of_Store_Assigned__c= totalstore1.size(); system.debug('first'+totalstore1.size());
            newreport1.No_of_Store_Visited__c = totalvisitstore1.size(); system.debug('second'+totalvisitstore1.size());
            newreport1.No_of_Store_Not_Visited__c = totalvisitstoreopen1.size(); system.debug('three'+totalvisitstoreopen1.size());
            dub.add(newreport1); 
            update dub;        
        } 
        if(filesize1 == 0)
        {
            for(integer i=1;i<=cnt;i++)
            {
                Beat_Plan_Report_Daily__c sobj = new Beat_Plan_Report_Daily__c(
                    Executive_Name__c = executivename,            
                    Date__c = dateval,                           
                    Single_Day_Assigned_Stores__c = totalstore.size(),     
                    Total_No_of_Store_Visited__c = totalvisitstore.size(),      
                    Total_No_of_Store_Not_Visited__c = totalvisitstoreopen.size()  
                );
                sd.add(sobj);
                dateval += 1;
            }
            insert sd;
        }
        else
        {
            for(Beat_Plan_Report_Daily__c chk:beatdaily)
            {
                Beat_Plan_Report_Daily__c sobj = new Beat_Plan_Report_Daily__c(
                    id = chk.Id,
                    Executive_Name__c = chk.Executive_Name__c,            
                     Date__c = chk.Date__c,                           
                     Single_Day_Assigned_Stores__c = totalstore.size(),     
                    Total_No_of_Store_Visited__c = totalvisitstore.size(),      
                    Total_No_of_Store_Not_Visited__c = totalvisitstoreopen.size());
                up.add(sobj);
            }
            update up;
        } 
    } 
    
    public static void report1(list<BeatPlan__c> finval)
    {
        list<BeatPlan__c> beatplanupdate = trigger.new;
        string storename,store_status,dayassignn;
        storename = beatplanupdate[0].Store_Account__c;
         store_status = beatplanupdate[0].Store_Visit_Status__c;
        dayassignn = beatplanupdate[0].Day_Assigned__c;
        
        if(store_status == 'Closed' && dayassignn == 'N/A' )  //Store Status Update
        {
            list<Store_Account__c> weeklystatus =[SELECT Id, Name, Weekly_Status__c FROM Store_Account__c where Id=:storename];
            Store_Account__c statusupdate = new Store_Account__c();
            statusupdate.id = weeklystatus[0].id;
            statusupdate.Weekly_Status__c = 'Closed';
            update statusupdate;
        }           
    } 
}