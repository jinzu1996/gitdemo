public class opposecls
{  
    @AuraEnabled
    public static List<Store_Account__c> saveFile(String base64Data) 
    {
        String data  = JSON.deserializeUntyped(base64Data).toString();  
        system.debug('hf' + data);
        list<Store_Account__c> lstCCToInsert = new list<Store_Account__c>();
        list<String> lstCSVLines = data.split('\n');
        for(Integer i = 1; i < lstCSVLines.size(); i++)
        {
            Store_Account__c acc = new Store_Account__c();    
            String csvLine = lstCSVLines[i];   
            String prevLine = csvLine;
            Integer startIndex;
            Integer endIndex;
            while(csvLine.indexOf('"') > -1)
            {
                if(startIndex == null)
                {
                    startIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
                }
                else
                {
                    if(endIndex == null)
                    {
                        endIndex = csvLine.indexOf('"');
                        csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                    }
                }
                
                if(startIndex != null && endIndex != null)
                {
                    String sub = csvLine.substring(startIndex, endIndex);
                    sub = sub.replaceAll(',', ':comma:');
                    csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                    startIndex = null;
                    endIndex = null;
                }
            }
            
            List<String> csvRowData = new List<String>();
            for(String column : csvLine.split(','))
            {
                column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');                
                csvRowData.add(column);  
            }            
            acc.Name = csvRowData[0];
            acc.UTID__c = csvRowData[1];
          //  acc.AccountSource                    = csvRowData[2];
            lstCCToInsert.add(acc);
        }
        insert lstCCToInsert; 
        return [Select Id, Name, UTID__c From Store_Account__c Where CreatedDate>=:Date.TODAY() limit 5];
    }  
}