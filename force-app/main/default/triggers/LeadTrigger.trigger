trigger LeadTrigger on Lead (before insert) {
    if(Trigger.isInsert) {
        List<Lead> leads = Trigger.new;
        for (Lead leadInstance : leads) {
            if(leadInstance.LeadSource == 'Facebook'){
                leadInstance.Company = leadInstance.LastName;
            }
        }
    }

}