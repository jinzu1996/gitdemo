@isTest
public class SetGeolocationTest {
    
    @isTest static void validatesetGeolocation(){
        
        Lead ld = new Lead();
        
        ld.LastName  = 'Test LN';
        
        ld.Company = 'Test company';
        
        ld.Contact_Name__c = 'Test company';
        ld.Contact_Mobile__c = '1234567890';
        ld.Owner_Name__c	 = 'Test company';
        ld.Owner_Mobile__c = 1234567890;
        ld.Email = 'test@gmail.com';
        ld.Store_Name__c = 'Test company';
        ld.Store_Address__c = 'Test company';
        ld.Pincode__c = 123456;
        ld.Number_of_stores__c = 1;
      //  ld.Store_Category__c = 'C';
        ld.Existing_POS_Machine__c = 'Bank';
        ld.mobilephone = '1234567890';
        ld.RecordTypeId = '0125g000000tE0MAAU';
        
        insert ld;
        
        opportunity opp = new opportunity();
        opp.name = 'test';
        opp.StageName = 'Actioned';
        opp.CloseDate = system.today();
        insert opp;
        
        
        Test.startTest();
        SetGeolocation.SetGeolocation(ld.id,'1','1');
        SetGeolocation.SetGeolocation(opp.id,'1','1');
        Test.stopTest();          
        
    }
    
}