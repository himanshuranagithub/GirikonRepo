trigger nullOppD5Tr on Opportunity (before delete) {
    
}  

/********************************************************************************
* Description: Create a quantity custom field in the opportunity object, when the 
user updates the quantity then it should reflect the same quantity in the opportunity
line item related to that opportunity .
*Algorthm
*Object:Opportunity
*Event:After (related record=opprLineItem)
*Operation: update,DML required
*Create Soql for the child -Opportunity object
*loop Opportunity line item child object
*Assign opportunity's quantity field to opp lineItem quantity 
**************************************************************************************/
    
  /*  switch on Trigger.OperationType{
        When AFTER_UPDATE{
            list<OpportunityLineItem> lstLineItem=[Select Id, OpportunityId, Quantity From 
                                                   OpportunityLineItem 
                                                   Where OpportunityId=:Trigger.New
                                                  ];
            for(OpportunityLineItem record:lstLineItem){
                record.Quantity=Trigger.NewMap.get(record.OpportunityId).Quantity__c;
                
            }
        update lstLineItem; 
        }
    }*/