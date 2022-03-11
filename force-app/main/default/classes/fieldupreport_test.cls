@istest
public class fieldupreport_test 
{
    public static testMethod void testUpdate()
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
            Store_Visit_Date__c = Date.today(),  
            Store_Account__c = sobj.Id,                                   
            Store_Executive_Name__c = useval[0].id,                             
         //   Store_Entry_Time__c = Datetime.valueOf('5-23-2012, 11:55 PM:00'),  
            Brand_EMI__c = 30.00,                                             
            Wallet_EMI__c = 302,                                               
            EFT__c = 301.00                                                   
            //Executive_Remark__c = 'checked'
            );
        insert sobj1;
        sobj1.Wallet_EMI__c = 444;
        update sobj1;
        BeatPlan__c sobj2 = new BeatPlan__c(
            Store_Name__c = 'Pavan Mart',                            
            Executive_Name__c = 'gunaseelandemo k',                            
            Store_Visit_Date__c = date.today()-1,  
            Store_Account__c = sobj.Id,                                   
            Store_Executive_Name__c = useval[0].id,                             
         //   Store_Entry_Time__c = Datetime.valueOf('5-23-2012, 11:55 PM:00'),  
            Brand_EMI__c = 30.00,                                             
            Wallet_EMI__c = 302,                                               
            EFT__c = 301.00                                                   
           // Executive_Remark__c = 'checked'
        );
        insert sobj2;
        list<Beat_Plan_Report__c> reportval =  [SELECT Id, Name, Date__c, Executive_Name__c, Total_No_of_Store_Assigned__c, No_of_Store_Visited__c, No_of_Store_Not_Visited__c  FROM Beat_Plan_Report__c where Executive_Name__c =: sobj1.Executive_Name__c and Date__c = today ];
                list<Beat_Plan_Report__c> reportval1 =  [SELECT Id, Name, Date__c, Executive_Name__c, Total_No_of_Store_Assigned__c, No_of_Store_Visited__c, No_of_Store_Not_Visited__c  FROM Beat_Plan_Report__c where Executive_Name__c =: sobj2.Executive_Name__c and Date__c = yesterday ];
        System.assert(reportval != reportval1);
     /*   Order__c ord = new Order__c(Account__c = acc.Id, Contact__c = con.Id);
        insert ord;       
        Object1__c obj1 = new Object1__c(Marks__c = 10.00);
        insert tp;
        
        Object2__c obj2 = new Object2__c ( Name = 'Test',Marks__c = 12.12,Account__c = acc.Id,Object1__c = obj1.Id); // Here object1 has relationship with obj2
        insert obj2;
        obj1.Marks__c = obj2.Marks__c;
        update obj1; */
    }
    
    public static testMethod void testschedule() 
    { 
        Store_Account__c sobj = new Store_Account__c(
            Name = 'Vandana Communications',                                                  // Store Name
            UTID__c = 'C02382A1',                                                               // UTID
            Stage__c = 'Converted',                                                             // Stage
            Disposition__c = 'A',                                                               // Disposition
            Phone_No__c = '(984) 442-6199',                                                     // Phone No
            City__c = 'Bangalore',                                                              // City
            Address__c = 'Jk Plaza Bsk 1st Stage 1, Kathriguppa Main Road, Vidyapeeta Circle',  // Address
            Pincode__c = '560085',                                                              // Pincode
            State__c = 'Karnataka'                                                             // State
        );
        insert sobj;
        
        Store_Account__c strval = new Store_Account__c(Id = sobj.id , Weekly_Status__c = null,Weekly_Assined_Person__c = null);
        update strval;
        
        
        Test.StartTest();
        sampledata sh1 = new sampledata();
      //  SchedulableContext sc = null;

      //  sh1.execute(sc);
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest();
    }
}