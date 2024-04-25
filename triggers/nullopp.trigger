trigger nullopp on Opportunity (before delete) 
{/*
    //Descreption: when opportunity stage is closed the amount should be greater than zero
    switch on Trigger.OperationType{
        when BEFORE_INSERT{
            for(Opportunity record:Trigger.New){
                if(record.StageName=='Closed Won'){
                    record.addError(Label.Opp_Error_Msg);
                }   
                if(record.Amount==NULL || record.Amount<=0){
                    record.Amount.addError('Opportunity amount should be greater than Zero');
                }
            }
        } 
    }*/
}