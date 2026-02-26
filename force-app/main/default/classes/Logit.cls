/**
 * @description       : Lightweight, asynchronous logging utility using Platform Events.
 * @author            : chuckito146@gmail.com
 * @group             : Logging
 * @last modified on  : 04-25-2026
 * @last modified by  : chuckito146@gmail.com
 * @link              : https://github.com/Chuckito146/logit
 *
 * Setup:
 * 1. Deploy metadata using manifest/logitPackage.xml
 *      sf project deploy start --manifest manifest/logitPackage.xml --target-org your-org-alias
 * 2. Manually assign the 'Logit' permission set to your user.
 *
 * Usage Examples:
 * - Quick Log   : Logit.log('message');
 * - Pretty Log  : Logit.logPretty(anyObject);
 * - Fluent API  : Logit.init().setLabel('App').setType('ERROR').setMessage('msg').publish();
 **/
public class Logit {
    @testVisible
    private LogitEvent__e logEvent;

    // private constructor to force use of init() method
    private Logit() {
        this.logEvent = new LogitEvent__e();
        this.logEvent.Label__c = '';
        this.logEvent.Label2__c = '';
        this.logEvent.Label3__c = '';
        this.logEvent.Type__c = '';
        this.logEvent.Message__c = '';
        this.logEvent.Message2__c = '';
        this.logEvent.Message3__c = '';
    }

    // entry point
    public static Logit init() {
        Logit self = new Logit();
        return self;
    }

    public static void log(String messageValue) {
        init().setMessage(messageValue).publish();
    }

    public static void logPretty(Object messageValue) {
        String prettyMessage = prettify(messageValue);
        log(prettyMessage);
    }

    public Logit setLabel(String labelValue) {
        this.logEvent.Label__c = truncate(labelValue, 255);
        return this;
    }

    public Logit setLabel2(String labelValue) {
        this.logEvent.Label2__c = truncate(labelValue, 255);
        return this;
    }

    public Logit setLabel3(String labelValue) {
        this.logEvent.Label3__c = truncate(labelValue, 255);
        return this;
    }

    public Logit setType(String typeValue) {
        this.logEvent.Type__c = truncate(typeValue, 255);
        return this;
    }

    public Logit setMessage(String messageValue) {
        this.logEvent.Message__c = truncate(messageValue, 50000);
        return this;
    }

    public Logit setMessage2(String messageValue) {
        this.logEvent.Message2__c = truncate(messageValue, 50000);
        return this;
    }

    public Logit setMessage3(String messageValue) {
        this.logEvent.Message3__c = truncate(messageValue, 50000);
        return this;
    }

    public void publish() {
        EventBus.publish(this.logEvent);
    }

    private static String prettify(Object obj) {
        if (obj == null) {
            return 'null';
        }

        String result;

        try {
            if (obj instanceof String) {
                String strObj = (String) obj;

                // detect if this is a JSON
                if (strObj.startsWith('{') || strObj.startsWith('[')) {
                    // turn into json obj
                    Object deserialized = JSON.deserializeUntyped(strObj);
                    // prettify the json string
                    result = JSON.serializePretty(deserialized);
                } else {
                    // if not a json, just return string
                    result = strObj;
                }
            } else {
                // if not a string, serialize as pretty JSON
                result = JSON.serializePretty(obj);
            }
        } catch (Exception e) {
            // if any error occurs during prettify, return simple string
            result = String.valueOf(obj);
        }

        // lets do just 50000 characters to be safe
        return truncate(result, 50000);
    }

    private static String truncate(String val, Integer maxLength) {
        if (String.isBlank(val) || val.length() <= maxLength) {
            return val;
        }
        return val.substring(0, maxLength);
    }
}
