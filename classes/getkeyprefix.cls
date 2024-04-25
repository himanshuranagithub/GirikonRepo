public class getkeyprefix {
 public String getprefix(){ 
         
        //Fetch all the URL parameters
        list<string> str = ApexPages.currentPage().getHeaders().get('referer').split('/');
        
        //Get the Key Prefix
        string kp = str[str.size() - 1].left(3);        
        if(kp=='o' || kp.contains('e'))
           kp = str[str.size() - 2].left(3);
        
        //Fetch the Schema of Your org    
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        
        //Get the SObject
        for(Schema.SObjectType objectInstance : gd.values()){       
        
            if(objectInstance.getdescribe().getkeyprefix() == kp){
            
                kp = objectInstance.getDescribe().getName();
            
            }
        
        }
        
        return kp; 
    }
        
    
}