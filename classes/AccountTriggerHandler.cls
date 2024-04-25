/****************************************************************
* @Description
* @Author
* @Created Date
* @L.Modified by
* **************************************************************/
public class AccountTriggerHandler {
   //Typecasting intitally
	List<Account> triggerNew;
    List<Account> triggerOld;
    Map<Id,Account> triggerNewMap;
    Map<Id,Account> triggerOldMap;
    
    public  AccountTriggerHandler() //constructor
    {
        //system.debug('TriggerNew'+Trigger.New);//we can print output but not use in functions
        //Below how to typecast the trigger context variables from sobject so that to use in apex 
        triggerNew= 	(List<Account>)Trigger.New;
        triggerOld= 	(List<Account>)Trigger.Old;
        triggerNewMap= 	(Map<Id,Account>)Trigger.NewMap;
        triggerOldMap= 	(Map<Id,Account>)Trigger.OldMap;
        //doAction(); 
        /*after trigger context variables initialised you can call doAction fun here or
*  you can call from Trigger 	
* trigger AccountHandlerTrigger on Account (before insert, after insert,before update, after update) {
AccountTriggerHandler obj=new AccountTriggerHandler();//constructor
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
	 updateRating();
    }
    public void onBeforeUpdate()
    {
      updateNotAddressMoreThan5();
        system.debug(1);
    }
    public void onAfterInsert()
    {
        
    }
    public void  onAfterUpdate()
    {
        
    }
    public void updateRating()
    {
        //Set rating=Hot when account created with industry=Banking
        for(Account record:triggerNew) //here using triggerNew(typecasted) not trigger.New
        {
            if(record.Industry=='Banking'){
                record.Rating='Hot';
            }
        }
    }
    public void updateNotAddressMoreThan5(){
   
        for(Account record:triggerNew)
        {
                // integer count =1;//(integer)record.Count_of_AddressField_update__c;
            if(triggerOldMap.get(record.Id).BillingCity!=record.BillingCity && record.Count_of_AddressField_update__c<5) 
            {    
               //system.debug('2');
                record.Count_of_AddressField_update__c +=1;
            }
            else{
                record.addError(Label.AccountHandler5timesError);
            }
        }
    }
}