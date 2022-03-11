trigger fieldup on BeatPlan__c (before insert,after insert,after update,after delete) 
{
    
   if(trigger.isAfter)
    {
        if(trigger.isInsert)//it is not valid assign trigger.isUpdate
        {
          //  fieldupreport.report(trigger.new);
        }
        else if(trigger.isUpdate)
        {
          // fieldupreport.report1(trigger.new);
        }
        else if(trigger.isDelete)
        {
          //  fieldupreport.report(trigger.old);
        }
    } 
}