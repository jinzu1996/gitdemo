global class sampledata implements Schedulable
{
    global  void execute(System.SchedulableContext SC) 
    {
        list<Store_Account__c> updaterec = new list<Store_Account__c>();
        list<Store_Account__c> up = [SELECT Id, Weekly_Status__c, Weekly_Assined_Person__c, Visited__c, Not_visited__c FROM Store_Account__c];
        for(Store_Account__c updatestore:up)
        {
            Store_Account__c strval = new Store_Account__c(Id = updatestore.id , Weekly_Status__c = null,Weekly_Assined_Person__c = null);
            updaterec.add(strval);
        }
        update updaterec;                        
    }

}