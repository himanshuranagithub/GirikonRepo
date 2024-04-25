public class TaskTriggerHandler { 
    /****************************************************************
* @Description
* @Author
* @Created Date
* @L.Modified by
Algorithm:
Implement:
Object:Action(Feild update) in Task
Event: after update(Related obj update)
Opereation: DML update 
* **************************************************************/
    //Typecasting intitally
    List<Task> triggerNew;
    List<Task> triggerOld;
    Map<Id,Task> triggerNewMap;
    Map<Id,Task> triggerOldMap;
    public  TaskTriggerHandler() //constructor
    {
        //system.debug('TriggerNew'+Trigger.New);//we can print output but not use in functions
        //Below how to typecast the trigger context variables from sobject so that to use in apex 
        triggerNew= 	(List<Task>)Trigger.New;
        triggerOld= 	(List<Task>)Trigger.Old;
        triggerNewMap= 	(Map<Id,Task>)Trigger.NewMap;
        triggerOldMap= 	(Map<Id,Task>)Trigger.OldMap;
        //doAction(); 
        /*after trigger context variables initialised you can call doAction fun here or
*  you can call from Trigger 	
* trigger TaskHandlerTrigger on Task (before insert, after insert,before update, after update) {
TaskTriggerHandler obj=new TaskTriggerHandler();//constructor
obj.doAction(); }
*/
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
        }
    }
    public void onBeforeInsert()
    {
    }
    public void onBeforeUpdate()
    {
        
    }
    public void onAfterInsert()
    {
        
    }
    public void  onAfterUpdate()
    {
        updateOpportunityStage();
    }
    Public void updateOpportunityStage()
        /*==========================================================
@Description:Once the task status changed to completed update the related opportunity status =closed Lost
@Algorithm:
1.Find the unique parent id using set<Id>
2.Taraverse loop ->task get the updated whatId 
3. store the whatid in the datatype string using implict(String)
4.check the whatid is it opportunity (006)
5.parent child relationship query=> for the stagename to update
6.update the opprtunity stage name
============================================================*/
    {
        string storeId;
        set<Id> opptyIds= new set<Id>();
        for(Task taskrecord:triggerNew)
        { 
            if(taskrecord.WhatId!=Null && taskrecord.Status=='Completed'){
                system.debug('1');
                if(string.valueOf(taskrecord.WhatId.getSobjectType())=='Opportunity')
                {  //string.valueOf(obj) into string 
                opptyIds.add(taskrecord.whatId);
               // storeId= (string)taskrecord.WhatId;
                //system.debug(storeId.Left(3));
                //Id oppId= '0065i000009Qe9FAAS';
                //system.debug(oppId.getsobjecttype()); //to check the  opportunity 
                system.debug(taskrecord.WhatId.getSobjectType()); //o/p: opportunity
            }
            }
        }
        // if(storeId.Left(3)=='006'){
        //system.debug('2');
        List<Opportunity> opptyRecord=[SELECT Id, StageName FROM Opportunity where Id in:opptyIds];
        list<Opportunity> updateOppty=new list<Opportunity>();
        for(Opportunity record:opptyRecord)
        {
            record.StageName='Closed Lost';
            updateOppty.add(record);
        }
        if(updateOppty.size()!=NULL)
            update updateOppty; 
        system.debug('updated');
    }
}