trigger OpportunityTrigger on Opportunity (before insert,after update) {

    opportunityHandlerTrigger obj=new opportunityHandlerTrigger();
    obj.doAction();
    
}