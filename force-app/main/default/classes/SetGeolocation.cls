public without sharing class SetGeolocation {
    
    @AuraEnabled
    public static boolean setGeolocation(Id evntId, String lat, String lng) {
        
       string objecttype = string.valueof(evntId.getsobjecttype()); 
        system.debug(objecttype);
        
        
        List<Lead> leadupd = new List<Lead>();
        List<Opportunity> oppupd = new List<Opportunity>();
        
        try
        {
            
        if (objecttype == 'Lead')

        {
            leadupd = [select id from lead where id =: evntId and (location__Latitude__s = null or location__Longitude__s = null)];
            
            if (leadupd.size() == 1)
            {
                leadupd[0].location__Latitude__s = decimal.valueof(lat);
                leadupd[0].location__Longitude__s = decimal.valueof(lng);
                 update leadupd; 
            }
            
            
        }
            
        if (objecttype == 'Opportunity')

        {
            oppupd = [select id from Opportunity where id =: evntId and (location__Latitude__s = null or location__Longitude__s = null)];
            
            if (oppupd.size() == 1)
            {
                oppupd[0].location__Latitude__s = decimal.valueof(lat);
                oppupd[0].location__Longitude__s = decimal.valueof(lng);
                 update oppupd; 
            }
            
            
        }        
          
           return true; 
        }
        catch(DMLException e)
        {
            return false; 
        }
    }

}