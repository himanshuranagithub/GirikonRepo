import { LightningElement, wire,track,api} from 'lwc';

export default class ChildCompLwcRef extends LightningElement {

    handleOnChange(event){
        let inputfield=event.target.label;
        if(inputfield=='Name'){
            console.log('Name Field::'+event.target.value)
        }
        else if(inputfield=='Happy'){

            console.log('Happy Field::::'+ event.target.value)
        }


    }
    

   @api handleClick(){
        console.log('save button clicked')
    }


    
}