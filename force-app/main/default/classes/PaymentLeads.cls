@RestResource(urlMapping='/PaymentLeads/*')
global class PaymentLeads 
{
    @HttpGet
    global static list<PaymentLead__c> PaymentLeadssend()
    {
        string tranid=restcontext.request.params.get('Transaction_ID');
        list<PaymentLead__c> sendrequest=[SELECT Id, Name, Source_tag__c, Date_and_time__c, Transaction_ID__c, Full_Name__c, Mobile_Number__c, Status_Field__c, Payment_Status__c, GST_Number__c, Address__c, Amount__c, Product_Info__c, EaseBuzz__c FROM PaymentLead__c where Transaction_ID__c =:tranid];
       return sendrequest; 
    }

}