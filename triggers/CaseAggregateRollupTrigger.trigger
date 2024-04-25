trigger CaseAggregateRollupTrigger on Case (After insert,After update,After Delete,After Undelete) {
    /******************************************************************************************
*Description: When a high priority case is created update the count in the parent contact record
*Algorithm:
*Find unique parent Id= use set<Id>//because child to parent
*Aggregate result===>to find no of case in each contact
*Update the count in the parent =>create a custom field 'count of highPriority' in contact
->Aggreagate result is a object so we need to typecast.
***************************************************************************************** */
    Switch on Trigger.OperationType{
        When After_INSERT{
            updateContactFunction(Trigger.New);
        }
        When After_UPDATE{
            updateContactFunction(Trigger.New);
        }
        When After_DELETE{
            updateContactFunction(Trigger.Old);
        }
        When After_UNDELETE{
            updateContactFunction(Trigger.New);
        }
    }
    public void updateContactFunction(List<Case> caseParameter)
    {
        //1.get unique contact id 
        set<Id> contactIds=new set<Id>();
        for(Case record:caseParameter){
            if(contactIds!=NULL){
                system.debug(1);
                if(Trigger.isUpdate)
                {
                    system.debug(2);
                    if(Trigger.OldMap.get(record.Id).Priority!= record.Priority ||
                       Trigger.OldMap.get(record.Id).Status!= record.Status )
                        //check prior field value with new field value 'ischanged'=>only for update
                        contactIds.add(record.ContactId);
                }
                else //for insert,delete & undelete because no ischanged in these DML's
                {
                    system.debug(3);
                    contactIds.add(record.ContactId);
                }
            }
            //2. count using AggregateResult=> Count related cases
            if(contactIds.size()>0)//to save soql
            {
                List<AggregateResult> agResult=[Select count(Id) countOfCases, ContactId From Case
                                                where Priority='High' and Status!='Closed' and ContactId =:contactIds 
                                                Group by ContactId]; 
                //3.Update contact with case count
                //need contact id and count of cases
                //Aggregate result is object   
                //constrct contact object from Aggregate Result
                List<Contact> contactList=new List<Contact>();
                for(AggregateResult ar:agResult){
                    Contact contactRecord=new Contact();
                    contactRecord.Id= (Id)ar.get('ContactId');
                    contactRecord.No_of_RelatedCases__c=(Integer)ar.get('countOfCases');
                    contactList.add(contactRecord);
                }
                if(contactList!=Null) //or if(!contactList.isEmpty()) //to save DML
                    system.debug('updated');
                    update contactList;
            }
        }
    }
}