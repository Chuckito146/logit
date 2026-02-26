# 🚀 Logit

A lightweight, asynchronous, logging utility for Salesforce.

🔗 **GitHub:** [https://github.com/Chuckito146/logit](https://github.com/Chuckito146/logit)

## 🌟 Overview

**Logit** decouples logging from your main transaction using Platform Events.
This ensures that logs are captured even if your code execution fails and rolls
back, while minimizing the performance impact on your business logic.

## 🛠️ Key Features

- **Asynchronous & Resilient:** Uses `PublishImmediately` Platform Events to
  survive transaction rollbacks.
- **Fluent Apex API:** Clean, readable syntax for developers.
- **Pretty Print:** Automatically formats JSON and Apex Objects for better
  readability.
- **Bulkified:** Trigger-based persistence handles high-volume events
  efficiently.
- **Large Payload Support:** Captures up to 50,000 characters per message field.

## 📖 How to Use

### 1. Quick Logging
For simple "fire-and-forget" messages.

```apex
Logit.log('Something happened here');
```

### 2. Pretty Logging
Automatically serializes and formats JSON strings or Apex Objects for better readability.

```apex
Account acc = [SELECT Name, Industry FROM Account LIMIT 1];
Logit.logPretty(acc);
```

### 3. Fluent API (Detailed)
For detailed categorization and multiple data points.

```apex
Logit.init()
    .setLabel('PaymentGateway')
    .setType('ERROR')
    .setMessage('Status Code: 500')
    .setMessage2('Additional Context')
    .publish();
```

## 🏗️ Architecture

1. **`Logit.cls`**: The developer-facing API to publish events.
2. **`LogitEvent__e`**: The Platform Event used for asynchronous transport.
3. **`LogitEventTrigger`**: The subscriber that listens for events and inserts
   records.
4. **`LogitEntry__c`**: The custom object where logs are persisted.

## 🚀 Deployment

1. **Deploy Metadata:**
   ```bash
   sf project deploy start --manifest manifest/logitPackage.xml --target-org your-org-alias
   ```

2. **Assign Permission Set:**
   Manually assign the `Logit` permission set to your user to grant access to the logging objects and classes.
## ⚖️ License

MIT
