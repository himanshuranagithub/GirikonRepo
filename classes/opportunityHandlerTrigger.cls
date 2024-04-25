public class opportunityHandlerTrigger {
    
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
    List<Opportunity> triggerNew;
    List<Opportunity> triggerOld;
    Map<Id,Opportunity> triggerNewMap;
    Map<Id,Opportunity> triggerOldMap;
    
    public  opportunityHandlerTrigger() //constructor
    {
        triggerNew= 	(List<Opportunity>)Trigger.New;
        triggerOld= 	(List<Opportunity>)Trigger.Old;
        triggerNewMap= 	(Map<Id,Opportunity>)Trigger.NewMap;
        triggerOldMap= 	(Map<Id,Opportunity>)Trigger.OldMap;
        
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
        createTask();
        updateLineItem();
        updateAccountQuantity();
    }
    public void createTask()
    {
 /********************************************************************************
* Description: when opportunity updated as closed won,create a task for the record owner to followup
the opportunity.Task subject 'hi{RecordOwner}please follow this opportunity my making a call'
*Algorthm
*Object:Opportunity
*Event:Afterupdate (related record=task)
*Operation: update,DML required
*Create Soql for user to get the owner name
*create task 
************************************************************************************* */        
       //1.Create task
        List<Task> taskList =new List<Task>();
        for(Opportunity record:triggerNew)
        {
            //To find the owner name
            Map<Id,User> newUser=new Map<Id,User>([Select Id,Name from User
                                                   Where isActive=True                
            										]); 
            if(record.StageName=='Closed Won' && record.StageName !=triggerOldMap.get(record.Id).StageName)
            {
                Task taskRecord=new Task();
                taskRecord.WhatId=record.Id;
                taskRecord.OwnerId =record.OwnerId;
                taskRecord.Status='Not Started';
                taskRecord.Subject='Followup ';
                taskRecord.Description='Hi ' + newUser.get(record.OwnerId)?.Name + '\n Please follow this opportunity by making this call';
                taskList.add(taskrecord);
            }
            insert(taskList);  
        }
        
    }
    public void updateLineItem(){
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
*******************************************************************************************/
        List<OpportunityLineItem> newlst=new List<OpportunityLineItem>(); 
        List<OpportunityLineItem> lstLineItem=[Select 
                                               Id, Quantity, OpportunityId
                                               from OpportunityLineItem 
                                               where OpportunityId=:triggerNew];
        for(OpportunityLineItem record:lstLineItem){
            record.Quantity=triggerNewMap.get(record.OpportunityId).Quantity__c;
            newlst.add(record);
        }
        update newlst;
    }
    
    public void updateAccountQuantity(){
        /****************************************************************
@Description:When a opportunity stage changed into ’Negotiation/Review’ 
then update the opportunities count in the Account object
@Author:Naveenkumar J
@Algorithm:
Object: opportunity,Event:After save, Operation: DML after update
1)Get the unique Account Ids using Set<> becase child ==>Parent
2)Aggregate result Soql find the no of opportunities 
with stage=Negotion/Review and add it to the parent Account.
3)used Aggregate result so sobject typecast 
4)Construct the account object from aggregate result.
===================================================================*/
        //1.get the unique parent(Account) id from child(oppr) using <set>
        set<Id> accountIds=new Set<Id>();
        for(Opportunity record:triggerNew){
            if(record.AccountId!=Null){
                if(triggerOldMap.get(record.Id).StageName !=record.StageName){
                    accountIds.add(record.AccountId);   
                }
            }
            if(accountIds.size()>0){
                //2.create a aggregate result SOQL to count no of R.opportunities 
                list<AggregateResult> aggr=[Select count(Id) opptycount,
                                            AccountId from Opportunity where StageName='Negotiation/Review'
                                            and AccountId in:accountIds 
                                            Group by AccountId];
                list<Account> accList=new list<Account>();
                for(AggregateResult ar:aggr){
                    //convert aggregate sobject typecast to Account
                    Account acc=new Account();
                    acc.Id=(Id)ar.get('AccountId');
                    acc.Count_of_Negotiation_Review__c=(decimal)ar.get('opptycount');   
                    accList.add(acc);
                }
                if(!accList.isempty()) //if(accountList!=Null)
                {
                    update accList;
                }
            }
        }
    }
    public void ValidateAmount(){
        //Descreption: when opportunity stage is closed won the amount should be greater than zero
        //Obj:Opp,Event:before update
        for(Opportunity record:triggerNew){
            if(record.StageName=='Closed Won' && record.Amount>0){
                record.addError('Opportunity amount should be greater than zero');
            }
        }
    }        
}