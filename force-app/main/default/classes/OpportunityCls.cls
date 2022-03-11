public class OpportunityCls
{  
    public static string extivename;
    public static string storetivename;
    @AuraEnabled( cacheable = true ) 
    public static list<Store_Account__c> fetchAssetRenOpp(string keyval, string pickli) 
    { 
        List<Store_Account__c> OppWrapperList = new List<Store_Account__c>();      
        //list<Store_Account__c>  accountObj11 = [SELECT Disposition__c, Stage__c, MBO_EBO__c, Preferred_Brand__c, Phone_No__c, Pincode__c, Address__c, City__c, Region__c, Vivo_State_Code__c, Vivo_Dealer_Code__c, Xiaomi_Dealer_Code__c, Samsung_Dealer_Code__c, Oppo_State_Code__c, Oppo_Dealer_Code__c, Onboarding_Date__c, Status__c, State__c, UTID__c,Name, Id, (SELECT Id, Store_Status__c,Store_Visit_Status__c, Executive_Name__c ,Weekly_Assigned__c, Store_Visit_Date__c FROM BeatPlans__r where Store_Visit_Date__c =LAST_N_DAYS:8 AND Store_Visit_Date__c <= TODAY ) FROM Store_Account__c where Name like: keyval order by LastModifiedDate desc ];
        //system.debug('hj' + accountObj11);
        if(keyval != null || keyval != '')
        {
            string con =  keyval + '%';
            for(Store_Account__c  accountObj : [SELECT Disposition__c, Stage__c, MBO_EBO__c, Preferred_Brand__c, Phone_No__c, Pincode__c, Address__c, City__c, Region__c, Vivo_State_Code__c, Vivo_Dealer_Code__c, Xiaomi_Dealer_Code__c, Samsung_Dealer_Code__c, Oppo_State_Code__c, Oppo_Dealer_Code__c, Onboarding_Date__c, Status__c, State__c, UTID__c,Name, Id, (SELECT Id, Store_Status__c ,Store_Visit_Status__c, Executive_Name__c ,Weekly_Assigned__c, Store_Visit_Date__c FROM BeatPlans__r where Store_Visit_Date__c =LAST_N_DAYS:30 AND Store_Visit_Date__c <= TODAY ) FROM Store_Account__c where Name like: con and Location__c =:pickli order by LastModifiedDate desc ])//Order by CreatedDate DESC
            {
                OppWrapperList.add(accountObj);
            }  
        } 
        
        return OppWrapperList;     
    }     
    
    @AuraEnabled
    public static void createrec(list<Store_Account__c> sf) //id storeid,string excutivename,list<Store_Account__c> sf
    { 
        system.debug('hs' + sf);
        list<BeatPlan__c> sd = new list<BeatPlan__c>();
        list<Store_Account__c> storevalueupda = new list<Store_Account__c>();
        for(Store_Account__c storeval:sf)
        {   
            //list<Store_Account__c> storeid = [SELECT Id, Name, UTID__c FROM Store_Account__c where id = ''];
            if(storeval.Executive_Name__c != null || storeval.Executive_Name__c != '')
            {
                date dateval = date.today();            
                integer cnt = 0;
                Datetime dt = System.now();
                String day=dt.format('EEEE');
                
                if(day == 'Saturday' )
                {
                    cnt = 4;
                }
                else if(day=='Sunday')
                {
                    cnt = 3;
                }
                else if(day=='monday')
                {
                    cnt = 2;
                }
                else if(day=='tuesday')
                {
                    cnt = 1;
                }
                else if(day=='wednesday')
                {
                    cnt = 7;
                }
                else if(day=='thursday')
                {
                    cnt = 6;
                }
                else if(day=='friday')
                {
                    cnt = 5;
                }
                list<BeatPlan__c> second = [SELECT Id, Executive_Name__c ,Store_Account__c, Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where Store_Account__c =: storeval.id and Store_Visit_Date__c = today];   //duplicate
                integer filesize = second.size();
                if(filesize == 0)
                {
                    for(integer i=1;i<=cnt;i++)
                    {
                        if(storeval.Executive_Name__c != null && storeval.Executive_Name__c != '')
                        { 
                            BeatPlan__c createob = new BeatPlan__c();
                            createob.Executive_Name__c = storeval.Executive_Name__c; 
                            createob.Store_Account__c = storeval.Id ;
                            // createob.UTID__c = storeval.UTID__c;
                            createob.Store_Visit_Date__c = dateval;
                            createob.Day_Assigned__c = 'N/A';
                            createob.Weekly_Assigned__c = storeval.Executive_Name__c;
                            createob.Actual_Store_Location__Latitude__s = storeval.Store_Location__Latitude__s;
                            createob.Actual_Store_Location__Longitude__s  = storeval.Store_Location__Longitude__s;
                            sd.add(createob);
                        } 
                        dateval += 1; //next date iteration update
                    }
                    ////store account weekly assigned person field update
                    if(storeval.Executive_Name__c != null && storeval.Executive_Name__c != '')
                    {
                        Store_Account__c val = new Store_Account__c();
                        val.id =  storeval.Id; 
                        val.Weekly_Assined_Person__c =  storeval.Executive_Name__c;
                        val.Weekly_Status__c = 'open';
                        storevalueupda.add(val);
                    }
                } 
            }
            else
            {
                sd[0].addError(' Cannot have two events start at the same time'); 
            } 
        } 
        insert sd;  
        update storevalueupda;
    }    
    @AuraEnabled
    public static void updaterec(list<Store_Account__c> sf) 
    {        
        list<BeatPlan__c> scf = new list<BeatPlan__c>();
        for(Store_Account__c sfval:sf)
        {
            if(sfval.Executive_Name__c != null && sfval.Executive_Name__c != '')
            {
                string excutivename = sfval.Executive_Name__c;
                id storeid = sfval.Id;
                list<BeatPlan__c> oldbeatval = [SELECT Id, Store_Account__c,Day_Assigned__c,Executive_Name__c , Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where  Store_Visit_Date__c = TODAY and Store_Account__c =: storeid];
                if(oldbeatval[0].Store_Visit_Status__c == 'Open' && oldbeatval[0].Day_Assigned__c == 'N/A' && oldbeatval[0].Executive_Name__c != null && oldbeatval[0].Executive_Name__c != '')//only for open record
                {
                    //  list<BeatPlan__c> sd = new list<BeatPlan__c>();
                    BeatPlan__c createob = new BeatPlan__c();
                    createob.Id = oldbeatval[0].Id;
                    createob.Executive_Name__c = excutivename ; 
                    createob.Day_Assigned__c = excutivename;
                    scf.add(createob);       
                }
                else
                {
                    oldbeatval[0].addError('Cannot have two events start at the same time'); 
                }
            }
            else
            {
                scf[0].addError(' Cannot have two events start at the same time'); 
            }
            
            /* for(BeatPlan__c cval: [SELECT Id, Store_Account__c,Day_Assigned__c,Executive_Name__c , Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where  Store_Visit_Date__c = TODAY and Store_Account__c =: sfval.Id])
{
system.debug('beatval' + cval);
if(cval.Store_Visit_Status__c == 'Open' && cval.Day_Assigned__c == 'N/A' && cval.Executive_Name__c != null && cval.Executive_Name__c != '')//only for open record
{
system.debug('max id' + cval.Id); 
system.debug('jk' + cval.Executive_Name__c);
//  list<BeatPlan__c> sd = new list<BeatPlan__c>();
BeatPlan__c createob = new BeatPlan__c();
createob.Id = cval.Id;
createob.Executive_Name__c = cval.Executive_Name__c ; 
createob.Day_Assigned__c = cval.Executive_Name__c;
scf.add(createob);       
}
else
{
//   scf[0].addError(' Cannot have two events start at the same time'); 
} 
}
system.debug('scf'+scf);
//  update scf;
*/
        }
        try
        {
            update scf;   
        }
        catch(exception e)
        {
            throw e;
        }
        
        /* string val11;
for(Store_Account__c  accountObj : [SELECT Disposition__c, Stage__c, MBO_EBO__c, Preferred_Brand__c,  Phone_No__c, Pincode__c, Address__c, City__c, Region__c, Vivo_State_Code__c, Vivo_Dealer_Code__c, Xiaomi_Dealer_Code__c, Samsung_Dealer_Code__c, Oppo_State_Code__c, Oppo_Dealer_Code__c, Onboarding_Date__c, Status__c, State__c, UTID__c,Name, Id, (SELECT Id, Store_Visit_Status__c, Executive_Name__c, Store_Visit_Date__c FROM BeatPlans__r where Store_Visit_Date__c = TODAY ) FROM Store_Account__c where id =:storeid ])//Order by CreatedDate DESC
{
for(BeatPlan__c c:accountObj.BeatPlans__r)
{
val11 = c.Id;   //get inner query value
}             
}         

list<BeatPlan__c> second = [SELECT Id,Store_Account__c, Day_Assigned__c,Executive_Name__c , Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where Store_Visit_Date__c = today and Store_Account__c =:storeid  ];
if(second[0].Store_Visit_Status__c == 'Open' && second[0].Day_Assigned__c == 'N/A')//only for open record
{
list<BeatPlan__c> sd = new list<BeatPlan__c>();
BeatPlan__c createob = new BeatPlan__c();
createob.Id = val11;
createob.Executive_Name__c = excutivename; 
createob.Day_Assigned__c = excutivename;
sd.add(createob);       
update sd; 
}
else
{
second[0].addError(' Cannot have two events start at the same time'); 
} */
    } 
    
    @AuraEnabled
    public static void csvFileRead(Id contentDocumentId)
    {        
        list<BeatPlan__c> sd = new list<BeatPlan__c>();
        list<BeatPlan__c> updatelist = new list<BeatPlan__c>();
        set<string> utidstinrt = new set<string>();
        list<Store_Account__c> accountInsertList = new list<Store_Account__c>();
        list<Store_Account__c> accountInsertList1 = new list<Store_Account__c>();
        list<Store_Account__c> updatestore = new list<Store_Account__c>();        
        if(contentDocumentId != null) 
        {
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            list<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');
            for(Integer i = 1; i < csvRecordsList.size(); i++)
            {
                Store_Account__c asd = new Store_Account__c();
                list<String>  csvRowData = csvRecordsList[i].split(',');
                asd.UTID__c = csvRowData[0];  
                asd.Name  = csvRowData[1];
                asd.Stage__c = csvRowData[5];
                asd.Disposition__c=csvRowData[6];
                asd.Phone_No__c=csvRowData[7];
                asd.Store_Location__Latitude__s=decimal.valueOf(csvRowData[8]) ;
                asd.Store_Location__Longitude__s=decimal.valueOf(csvRowData[9]);
                asd.Location__c = csvRowData[10];
                asd.Address__c= csvRowData[11];
                accountInsertList.add(asd);
            }
            
            //   system.debug('accountInsertList' + accountInsertList);
            for(Store_Account__c sd1:accountInsertList)
            {
                for(Store_Account__c sd2:[SELECT Id, Name, Stage__c, Disposition__c, Address__c, Location__c, Store_Location__Latitude__s, Store_Location__Longitude__s, UTID__c, Phone_No__c FROM Store_Account__c where UTID__c =: sd1.UTID__c])
                {
                    Store_Account__c strname = new Store_Account__c();
                    strname.Id = sd2.Id;
                    strname.Name=sd1.Name;
                    strname.Stage__c=sd1.Stage__c;
                    strname.Disposition__c=sd1.Disposition__c;
                    strname.Phone_No__c=sd1.Phone_No__c;
                    strname.Store_Location__Latitude__s=sd1.Store_Location__Latitude__s;
                    strname.Store_Location__Longitude__s=sd1.Store_Location__Longitude__s;
                    strname.Address__c=sd1.Address__c;
                    strname.Location__c=sd1.Location__c;
                    updatestore.add(strname);               
                }
                list<Store_Account__c> sd3 = [SELECT Id, Name, Stage__c, Disposition__c, Address__c, Location__c, Store_Location__Latitude__s, Store_Location__Longitude__s, UTID__c, Phone_No__c FROM Store_Account__c where UTID__c =: sd1.UTID__c];
                if(sd3.size() == 0 )
                {
                    Store_Account__c strname = new Store_Account__c();
                    strname.Name=sd1.Name;
                    strname.UTID__c = sd1.UTID__c;
                    strname.Stage__c=sd1.Stage__c;
                    strname.Disposition__c=sd1.Disposition__c;
                    strname.Phone_No__c=sd1.Phone_No__c;
                    strname.Store_Location__Latitude__s=sd1.Store_Location__Latitude__s;
                    strname.Store_Location__Longitude__s=sd1.Store_Location__Longitude__s;
                    strname.Address__c=sd1.Address__c;
                    strname.Location__c=sd1.Location__c;
                    accountInsertList1.add(strname);
                    
                }        
            } 
            system.debug('insert' + accountInsertList1);
            system.debug('update' + updatestore);
            insert accountInsertList1;
            update updatestore;
            
            //<----------------- Beat-plan ---------------->
            
            for(Integer i = 1; i < csvRecordsList.size(); i++)
            {
                list<String> csvRowData = csvRecordsList[i].split(',');
                for(Store_Account__c sample:[SELECT Id,Executive_Name__c,Store_Location__Latitude__s, Store_Location__Longitude__s, Name, UTID__c FROM Store_Account__c where UTID__c =: csvRowData[0]])
                {
                    system.debug('enter 1');
                    integer asm = 0;
                    integer bm = 0;
                    integer sh = 0;
                    date dateval = date.today();            
                    integer cnt = 0;
                    Datetime dt = System.now();
                    String day=dt.format('EEEE');
                    
                    if(day == 'Saturday' )
                    {
                        cnt = 4;
                         asm = 16;
                        bm = 24;
                        sh = 32;
                    }
                    else if(day=='Sunday')
                    {
                        cnt = 3;
                         asm = 17;
                        bm = 25;
                        sh = 33;
                    }
                    else if(day=='monday')
                    {
                        cnt = 2;
                         asm = 18;
                        bm = 26;
                        sh = 34;
                    }
                    else if(day=='tuesday')
                    {
                        cnt = 1;
                        asm = 19;
                        bm = 27;
                        sh = 35;
                    }
                    else if(day=='wednesday')
                    {
                        cnt = 7;
                        asm = 13;
                        bm = 21;
                        sh = 29;
                    }
                    else if(day=='thursday')
                    {
                        cnt = 6;
                        asm = 14;
                        bm = 22;
                        sh = 30;
                    }
                    else if(day=='friday')
                    {
                        cnt = 5;
                        asm = 15;
                        bm = 23;
                        sh = 31;
                    }
                    list<BeatPlan__c> second = [SELECT Id, Executive_Name__c , Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where Store_Account__c =: sample.id and Store_Visit_Date__c =today ];   //duplicate
                    list<BeatPlan__c> second1 = [SELECT Id, Executive_Name__c , Store_Visit_Date__c, Store_Visit_Status__c FROM BeatPlan__c where Store_Account__c =: sample.id and Store_Visit_Date__c <= Next_N_DAYS:7 and Store_Visit_Date__c >= TODAY  ];   //duplicate
                    integer filesize = second.size();
                    if(filesize == 0)
                    {
                         system.debug('new Record');
                        for(integer j=1;j<=cnt;j++)
                        {  
                            system.debug('test');
                            BeatPlan__c createob = new BeatPlan__c();
                            createob.Executive_Name__c = csvRowData[2]; 
                            createob.Branch_Manager_Name__c = csvRowData[3];
                            createob.Store_Account__c = sample.Id ;
                            createob.Store_Visit_Date__c = dateval;
                            createob.Actual_Store_Location__Latitude__s = sample.Store_Location__Latitude__s;
                            createob.Actual_Store_Location__Longitude__s  = sample.Store_Location__Longitude__s;
                            if(csvRowData[bm] == 'Yes')
                            {
                                createob.Branch_Manager_Name__c = csvRowData[3];
                                createob.Planned_Visit_Branch_Manager__c = true;
                            }
                            if(csvRowData[asm] == 'Yes')
                            {
                               createob.Planned_Visit_Executive__c = true;
                            }
                            if(csvRowData[sh] == 'Yes')
                            {
                                createob.Planned_Visit_State_Head__c = true;
                               createob.State_Head_Name__c = csvRowData[4];
                            }
                            createob.Day_Assigned__c = 'N/A';
                            createob.Weekly_Assigned__c = csvRowData[1];
                            sd.add(createob);
                            system.debug('sd' + sd);
                            asm += 1;
                            system.debug('sh ' + sh);
                           // if(sh < 35)
                           // {
                               sh += 1; 
                           // }
                            
                            bm += 1;
                            dateval += 1; //next date iteration update
                        }
                    } 
                    else
                    {
                        for(BeatPlan__c sf:second1)
                        {
                            system.debug('id' + sf.id );
                            BeatPlan__c updateob = new BeatPlan__c();
                            updateob.Id = sf.id;
                            updateob.Executive_Name__c = csvRowData[2]; 
                            updateob.Store_Account__c = sample.Id ;
                            updateob.Store_Visit_Date__c = dateval;
                            updateob.Actual_Store_Location__Latitude__s = sample.Store_Location__Latitude__s;
                            updateob.Actual_Store_Location__Longitude__s  = sample.Store_Location__Longitude__s;
                            if(csvRowData[bm] == 'Yes')
                            {
                                updateob.Branch_Manager_Name__c = csvRowData[3];
                                updateob.Planned_Visit_Branch_Manager__c = true;
                            }
                            if(csvRowData[asm] == 'Yes')
                            {
                               updateob.Planned_Visit_Executive__c = true;
                            }
                            if(csvRowData[sh] == 'Yes')
                            {
                                updateob.Planned_Visit_State_Head__c = true;
                               updateob.State_Head_Name__c = csvRowData[4];
                            }
                            updateob.Day_Assigned__c = 'N/A';
                            updateob.Weekly_Assigned__c = csvRowData[1];
                            updatelist.add(updateob);
                            
                            asm += 1;
                           // if(sh <= 36)
                          //  {
                               sh += 1; 
                          //  }
                            bm += 1;
                            dateval += 1; //next date iteration update
                        }
                            
                    }
                    
                }
            }  
            
        } 
        insert sd;
        update updatelist;        
    } 
}