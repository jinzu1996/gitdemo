@isTest
public class LeadTriggerTest {
    public static testmethod void testLeadName() {
        Lead leadInstance = new Lead();
        leadInstance.LastName = 'Test';
        leadInstance.Company = 'Test';
        leadInstance.LeadSource = 'Facebook';
        insert leadInstance;
    }
}