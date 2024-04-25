trigger TaskTrigger on Task (before insert,after update,before update, after insert) {
   
    TaskTriggerHandler obj=new TaskTriggerHandler();
    obj.doAction();
}