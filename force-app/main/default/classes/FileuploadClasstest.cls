@isTest
private class FileuploadClasstest 
{
     @isTest static void ContentDocumentLinkTriggerTest() {
        
        Account accountObj = new Account();
        accountObj.Name = 'CRECAccount';
        INSERT accountObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'CREC';
        contactObj.LastName = 'Project';
        contactObj.Email = 'abc@CERC.com';
        contactObj.AccountId = accountObj.Id;
        INSERT contactObj;
        
        ContentVersion content1 = new ContentVersion(); 
        content1.Title = 'Header_Picture1'; 
        content1.PathOnClient = '/' + content1.Title + '.jpg'; 
        Blob bodyBlob1 = Blob.valueOf('snc'); 
        content1.VersionData = bodyBlob1; 
        content1.origin = 'H';
        insert content1;
        ContentDocumentLink contentlink1 = new ContentDocumentLink();
        contentlink1.LinkedEntityId = contactObj.id; // linked with contact module
        contentlink1.contentdocumentid = [select contentdocumentid from contentversion where id =: content1.id].contentdocumentid;
        // contentlink1.ShareType = 'I';
        contentlink1.Visibility = 'AllUsers';
         try{
             insert contentlink1;
             Update contentlink1;
         }
         
         catch (Exception e) {
             System.assert(false, 'Exception ' + e);
         }
         Test.startTest();
         FileUploaderClass.uploadFile('Unit Test Attachment Body', content1.Title , contactObj.id);
        Test.stopTest();
    }

}