trigger nullOpp53D1Tgr on Opportunity (before delete) {
    /****************************************************************
@Description:When a opportunity stage changed into ’Negotiation/Review’ 
then update the opportunities count in the Account object
@Author:Naveenkumar J
@Algorithm:
1)Get the unique Account Ids using Set<> becase child ==>Parent
2)Aggregate result Soql find the no of opportunities 
with stage=Negotion/Review and add it to the parent Account.
3)used Aggregate result so sobject typecast 
4)Construct the account object from aggregate result.
===================================================================*
    Switch on Trigger.OperationType{
        When AFTER_UPDATE{
            //1.get the unique parent(A/c) Id from the related child(oppr) 
            Set<Id> accountIds=new Set<Id>();
            for(Opportunity record:Trigger.New){
                if(record.AccountId!=Null){   
                    system.debug('1');
                    if(Trigger.OldMap.get(record.Id).StageName!=record.StageName){
                        system.debug('2');
                        accountIds.add(record.AccountId);
                    }
                }
            }
            //2. Using Aggregate result to store count in parent(A/c) 
            if(accountIds.size()>0){
                system.debug('3');
                List<AggregateResult> agrResult=[Select Count(Id)CountofOpprt,AccountId, Account.Rating from Opportunity 
                                                 where StageName='Negotiation/Review' 
                                                 and AccountId in:accountIds  and Account.Rating='Hot'
                                                 Group by AccountId,Account.Rating ]; 
                list<Account> accountList=new list<Account>();
                for(AggregateResult ar:agrResult){
                    Account accRecord=new Account();
                    accRecord.Id=(Id)ar.get('AccountId');
                    accRecord.Count_of_Negotiation_Review__c=(decimal)ar.get('CountofOpprt');
                    accountList.add(accRecord);   //Add to list best practice outside loop  
                }
                if(accountList!=Null) {
                    // if(!accountList.isempty())
                    system.debug(' negotation/Review updated');
                    update accountList;
                }
            }
        }
    }*/
}