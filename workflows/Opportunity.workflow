<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Close_Date</fullName>
        <description>Close Date</description>
        <protected>false</protected>
        <recipients>
            <recipient>naveenjai@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Time_Trigger</template>
    </alerts>
    <alerts>
        <fullName>Notify_Mgr_on_the_high_value_Opportunity</fullName>
        <description>Notify Mgr on the high value Opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>naveenjai@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notify_MGR</template>
    </alerts>
    <fieldUpdates>
        <fullName>Type</fullName>
        <field>Type</field>
        <literalValue>Existing Customer - Upgrade</literalValue>
        <name>Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Notify Mgr on the high value Opportunity</fullName>
        <actions>
            <name>Notify_Mgr_on_the_high_value_Opportunity</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterThan</operation>
            <value>10000</value>
        </criteriaItems>
        <description>Notify Mgr on the high value Opportunity</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Close_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
