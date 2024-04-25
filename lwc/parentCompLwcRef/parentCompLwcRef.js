import { LightningElement } from 'lwc';

export default class ParentCompLwcRef extends LightningElement {

    handleChildCompSave(){
        console.log('parent comp handle child save');
        this.template.querySelector("c-child-comp-lwc-ref").handleClick();
    }
}