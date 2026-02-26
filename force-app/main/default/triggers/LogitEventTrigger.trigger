/**
 * @description       : Trigger to log LogitEvent__e events into LogitEntry__c records.
 * @author            : Amos Go
 * @group             :
 * @last modified on  : 02-26-2026
 * @last modified by  : Amos Go
 **/
trigger LogitEventTrigger on LogitEvent__e(after insert) {
    List<LogitEntry__c> logsToInsert = new List<LogitEntry__c>();

    for (LogitEvent__e event : Trigger.new) {
        // timestamp to sort logs in sequence
        String timestamp = Datetime.now().format('yyyy-MM-dd HH:mm:ss.SSS');

        // create the log record
        LogitEntry__c logEntry = new LogitEntry__c();
        logEntry.Name = timestamp;
        logEntry.Label__c = event.Label__c;
        logEntry.Label2__c = event.Label2__c;
        logEntry.Label3__c = event.Label3__c;
        logEntry.Type__c = event.Type__c;
        logEntry.Message__c = event.Message__c;
        logEntry.Message2__c = event.Message2__c;
        logEntry.Message3__c = event.Message3__c;

        logsToInsert.add(logEntry);
    }

    if (!logsToInsert.isEmpty()) {
        insert logsToInsert;
    }
}
