trigger CaseDay5354Trigger on Case (before delete){ //(After insert,After update,After delete,After Undelete) {
    /******************************************************************************************
*Description: When a high priority case is created update the count in the parent contact record
*Algorithm:
*Find unique parent Id= use set<Id>//because child to parent
*Parent child relationship query===>to find no of case in each contact
*Update the count in the parent =>create a custom field 'count of highPriority' in contact

***************************************************************************************** */
/*    switch on Trigger.OperationType{
        when AFTER_INSERT{  
            commonDMLFunction(Trigger.New);
        }
        when AFTER_UPDATE{  
            commonDMLFunction(Trigger.New); 
        }
        when AFTER_DELETE{  
            commonDMLFunction(Trigger.Old); 
        }
        when AFTER_UNDELETE{    
            commonDMLFunction(Trigger.New); 
        }
    }   
    public void commonDMLFunction(List<Case> caseParameter){
        //a)Collect unique parent Ids
        Set<Id> contactIds=new Set<Id>();
        for(Case caseRecord:caseParameter){
            if(caseRecord.ContactId!=NULL)//check case that contact is there if null    
            {   
                system.debug(1);
                if(Trigger.isupdate){       
                    if(Trigger.OldMap.get(caseRecord.Id).Priority != caseRecord.Priority)//write only for update that particular field ischanged 
                    {
                        contactIds.add(caseRecord.ContactId); 
                        //if case created without parent contactID then it will store null so add if condition above                    
                    }
                }
                else{ 
                    system.debug(3);
                    contactIds.add(caseRecord.ContactId);  
                }
            }
        }
        if(contactIds.size()>0){
            //b)parent child relationship query=> to find the no of cases in each contact
            List<Contact> contactList=[Select Id,No_of_RelatedCases__c,
                                       (Select Id, Priority from Cases where Priority='High' and Status !='Closed')
                                       From Contact where Id in:contactIds
                                      ];
            //c)Update the count in the parent
            list<Contact> contactToUpdate=new list<Contact>();
            for(Contact contactRecord:contactList){
                contactRecord.No_of_RelatedCases__c=contactRecord.Cases.size();
                contactToUpdate.add(contactRecord);
                system.debug('no of records created'+contactRecord.Cases.size());
            }
            if(contactToUpdate.size()>0)
                //  system.debug('Updated');
                update contactToUpdate;
        }
    }*/
}