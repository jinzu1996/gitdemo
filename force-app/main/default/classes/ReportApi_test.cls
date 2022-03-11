@isTest
private class ReportApi_test 
{
    @testSetup
    static void dataSetup() 
    {
        Clock_Time__c sobj = new Clock_Time__c( Name__c = 'gunaseelandemo k',  
                                               ClockIn_Location__Latitude__s = 45.968046, 
                                               ClockIn_Location__Longitude__s = -94.420307, 
                                               ClockOut_Location__Latitude__s = 45.968046, 
                                               ClockOut_Location__Longitude__s = -94.420307,
                                               Date__c = Date.valueOf('2022-02-28'));
        insert sobj;
    }
    private class CustomException extends Exception 
    {
        public string test;
        public CustomException(string xyz,string fil)
        {
            test = xyz;
        } 
    }
    
    static testMethod void testPost() 
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/Apiresponse2/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
       // String acctId = SampleRest.doPost('Test', 'Testing');
        try 
        {
       //     clock_ctrl_list.createclock(45.968046,-94.420307);
        } 
        catch(DMLException e) 
        {
           // system.assertEquals(e.getMessage().contains('Last Name'));
        }
       /* Account acc = [ SELECT Id, Name, Description FROM Account WHERE Id =: acctId ];
        system.assertEquals(acc.Name, 'Test');
        system.assertEquals(acc.Description, 'Testing'); */
    }
}