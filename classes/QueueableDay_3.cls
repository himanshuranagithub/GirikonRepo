public class QueueableDay_3 implements Queueable{

    public static void execute(QueueableContext ctx){
        //Logic
        system.debug('Queueable demo');
        Delete[Select Id from Account where  createdDate=This_Month];
    }
}