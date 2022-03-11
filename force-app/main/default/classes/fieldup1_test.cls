@isTest
public class fieldup1_test 
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
         //   Store_Visit_Date__c = Datetime.valueOf('12-31-2021, 5:30 AM:00'),  
            Store_Account__c = sobj.Id,                                   
            Store_Executive_Name__c = useval[0].id,                             
         //   Store_Entry_Time__c = Datetime.valueOf('5-23-2012, 11:55 PM:00'),  
            Brand_EMI__c = 30.00,                                             
            Wallet_EMI__c = 302,                                               
            EFT__c = 301.00                                                   
           // Executive_Remark__c = 'checked'
           );
        insert sobj1;
        integer val;
        list<BeatPlan__c> beatval = [SELECT Id,Store_Account__c FROM BeatPlan__c where Store_Account__c =: sobj1.Store_Account__c ];
        val = beatval.size();
        list<Store_Account__c> afterval = [SELECT Count_Val__c, Name, Id FROM Store_Account__c where id =: sobj1.Store_Account__c];
        afterval[0].Count_Val__c = string.valueOf(val);
        update afterval;
    }

}