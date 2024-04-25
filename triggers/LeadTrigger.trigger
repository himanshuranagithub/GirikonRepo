trigger LeadTrigger on Lead (before insert,after insert,before update,after update,after delete,before delete,after undelete)
{
    
    LeadTriggerHandler obj=new LeadTriggerHandler();
    obj.doAction();
    
}