trigger nullAcctgr on Account(before delete){/* (before insert,after insert) {
    switch on Trigger.OperationType{
        when AFTER_INSERT{
            list<Contact> contactlst=new list<Contact>(); 
            for(Account newRecord:Trigger.New){
                if(newRecord.Active_Contact__c==True){
 contact create=new Contact(LastName=newRecord.Name + 'Related Contact', //just naming differntly or you type L.Name
                                               AccountId=newRecord.Id
                                                );
                    contactlst.add(create);
                }
            }
        insert contactlst;//outside the for loop DML
        } 
    }*/
    
}