trigger AccountTrigger on Account (before insert, after insert,before update, after update) {

    AccountTriggerHandler obj=new AccountTriggerHandler();//constructor
    obj.doAction(); 
}