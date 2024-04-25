public class LeadTriggerHandler {
    /****************************************************************
* @Description: When a oppr updated as closed won create a task for the record owner to followup that opportunity
Algorithm:
1) object: opportunity
2) Event: After update
3) Operation: DML Insert
* @Author:Naveenkumar J
* @Created Date:2ndNov'22
* @L.Modified by
* **************************************************************/
    //Typecasting intitally
    List<Lead> triggerNew;
    List<Lead> triggerOld;
    Map<Id,Lead> triggerNewMap;
    Map<Id,Lead> triggerOldMap;
    
    public  LeadTriggerHandler() //constructor
    {
        triggerNew= 	(List<Lead>)Trigger.New;
        triggerOld= 	(List<Lead>)Trigger.Old;
        triggerNewMap= 	(Map<Id,Lead>)Trigger.NewMap;
        triggerOldMap= 	(Map<Id,Lead>)Trigger.OldMap;
        
    }
    Public void doAction()
    {
        Switch on Trigger.OperationType{
            When BEFORE_INSERT
            {
                onBeforeInsert();
            }
            When BEFORE_UPDATE
            {
                onBeforeUpdate();
            }
            When AFTER_INSERT
            {
                onAfterInsert();
            }
            When AFTER_UPDATE
            {
                onAfterUpdate();
            }
            When BEFORE_DELETE
            {
                onBeforeDelete();
            }
            When AFTER_DELETE
            {
                onAfterDelete();
            }
            When AFTER_UNDELETE
            {
                onAfterUndelete();
            }
        }
    }
    public void onBeforeInsert()
    {
        beforeInsertNoStatusclosed();
        annualRevenue2LakhsRatingHot();
    }
    public void onBeforeUpdate()
    {
        descriptionMustClosedNotConverted();
        system.debug('1');
    }
    public void onAfterInsert()
    {
        
    }
    public void  onAfterUpdate()
    {
        
    }
    public void  onbeforeDelete()
    {
        validateDeleteLead();
    }
    public void  onAfterDelete()
    {
        
    }
    public void  onAfterUndelete()
    {
        
    }
    
/*===================================================================
* @Description: Block the user from creating a lead record with status as Closed
* Algorithm
* object=>Lead
* Event=>Before save
* operation: insert, no DML required
* */
    public void beforeInsertNoStatusclosed()
    {
        for(Lead record:triggerNew)
        {
            if(record.Status=='Closed - Converted' || record.Status=='Closed - Not Converted')
            {
                record.addError('Lead cannot be created with status as Closed');
            }
        }
    }
/*======================================================
* Description: When a lead creating with Annual revenue more than 2lakhs set the Rating as Hot
* Algorithm
* object=>Lead
* Event=>Before save
* operation: insert, no DML required
========================================================*/    
    public void annualRevenue2LakhsRatingHot(){
        for(Lead record:triggerNew){
            if(record.AnnualRevenue>200000){
                record.Rating='Hot';
            }
        }
    }
/*=============================================================
*Description: When a lead Updating with status as closed -not converted make sure description is entered.
If the description is not entered block the user from updating that lead record
* Algorithm
* object=>Lead
* Event=>Before save
* operation: before update, no DML required
* */     
    public void descriptionMustClosedNotConverted(){   
        for(Lead record:triggerNew){
            system.debug('2');
            if(record.Status=='Closed - Not Converted' && record.Description==Null)
                record.Description.addError('When the lead is closed not converted then you must define description');
        }
    }
    
 /*================================================================================
  * Description: Working contacted lead should not be deleted
  * Obj: Lead, Event: before Delete C.Variables: trigger.old and trigger.oldmap
  * */
    public void validateDeleteLead(){
        for(Lead record:triggerOld){
            if(record.Status=='Working - Contacted'){
                record.addError('Working contacted lead cannot be deleted'); 
            }
            
        }
    }
}