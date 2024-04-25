trigger nullPhnocopyAcc on Account (before delete){//(before update, after update) {
    /*Algorithm:
1.Loop all account(Trigger.New)
2.Loop contact
3.Copy parent account record phone no.
4.Update child record
*
    switch on Trigger.OperationType{
        When AFTER_UPDATE{
            List<Contact> lstContact=[Select Id,LastName,Phone, AccountId from Contact 
                                      where AccountId=:Trigger.New];
            for(Contact contRecord:lstContact){
                contRecord.Phone=Trigger.NewMap.get(contRecord.AccountId).Phone;
            }            
            update lstContact;
        }
    }
}
 /* //for loop inside for loop => consumes cpu time limit
  *  List<Account> lstAccount=[Select Id,Phone, (Select Id, AccountId, Phone from contacts) 
                                      From Account where Id=:Trigger.New];
            list<Contact> lstContact=new list<Contact> (); 
            for(Account record:lstAccount){
                for(Contact contRecord:record.contacts){
                    contRecord.Phone=record.phone;
                    lstContact.add(contRecord);
                }//for loop inside for loop => consumes cpu time limit
            }
            update lstContact;
        }*   
    
/* //NOT BEST PRACTISE -Soql inside loop, DML inside loop
           
            for(Account accRecord:Trigger.New){
              List<contact> lstContact=[Select LastName, AccountId,Phone From Contact 
                                        where AccountId=:accRecord.Id];    //Soql inside loop  
                for(Contact conRecord:lstContact){   
                    conRecord.Phone=accRecord.Phone;
                }
               // update lstContact; //DML inside loop
            }
} */ }