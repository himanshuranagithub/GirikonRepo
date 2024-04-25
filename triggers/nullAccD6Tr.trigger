trigger nullAccD6Tr on Account (before delete){ //(before update, after update) {
    /********************************************************************************
* Description:When an account is marked as inactive then close all the related cases
*Algorthm
*Object:Account
*Event:After (related record)
*Operation: update,DML required
*Create list for the child -Case object
*loop case object
*check Account active field active using IF()
*assign case status to close if condition is true 
**************************************************************************************/
    switch on Trigger.OperationType{
        when AFTER_UPDATE{
            list<Case> lstCase=[Select Status, AccountID from Case where AccountId=:Trigger.New];
            for(Case record:lstCase){
                if(Trigger.NewMap.get(record.AccountId).Active__c=='No'){
                    record.Status='Closed';
                }       
            }
            update lstCase;
        }
    }
}