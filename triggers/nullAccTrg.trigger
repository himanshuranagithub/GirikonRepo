trigger nullAccTrg on Account (before delete) { /*(before insert,before update) {
    switch on Trigger.OperationType
    {
        when BEFORE_INSERT{
            for(Account record:Trigger.New){
                if(record.Rating==NULL){
                    record.Rating='Cold';
                }
            }
        }
        when BEFORE_UPDATE{
            for(Account record:Trigger.New){
                if(record.Rating==NULL){
                    record.Rating='Cold';
                }
            }
        }
    }     */
}