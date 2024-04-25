Global class Day11Soap_example {
    webservice static string createNewLead(string leadLastname, string leadCompany,  string email, string phone){
        try{
            lead rec=new lead();
            rec.Lastname=leadLastname;
            rec.Company=leadCompany;
            rec.Email=email;
            rec.Phone=phone;
            
            insert rec;
            return rec.Id;
        }
        catch(exception e){
            return 'error during record processing ';
        }
    }
}