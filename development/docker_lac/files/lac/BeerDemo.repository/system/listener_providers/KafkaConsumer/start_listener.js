out.println("Starting KafkaConsumer listener: " + listener.name);
var consumer = new env.KafkaConsumer(env.props);
var connectionClosed = false;
var topics = ('' + parameters.topics).split(",");
var topicsList = new env.ArrayList();
for (var i = 0; i < topics.length; i++) {
    topicsList.add(topics[i]);
}
var Runnable = Java.type("java.lang.Runnable");
var ListenerRunnable = Java.extend(Runnable, {
    listener: listener,
    consumer: consumer,
    topicsList: topicsList,
    close: function() { connectionClosed = true; },
    run: function() {
        try {
            consumer.subscribe(topicsList);
            while (!connectionClosed) {
                var records = consumer.poll(100);
                var iter = records.iterator();
                while (iter.hasNext()) {
                    var producerRecord = iter.next();
                    // Generate unique id of the message for clustered deployments.
                    var msgId = providerUtil.generateHash(producerRecord.value());
                    var executorPayload = {
                        record: producerRecord,
                        uniqueId: msgId,
                        clusterSyncOffset: 5000
                    };
                    listener.executor.execute(executorPayload);
                }
            }
        }
        catch (e) {
            connectionClosed = true;
            out.println("KafkaConsumer interrupt called ");
        }
        log.debug("KafkaConsumer Thread stopping");
        try { consumer.close(); } catch (e) { }
    }
});

var myRunnable = new ListenerRunnable();
var thread = new env.Thread(myRunnable,listener.name);
thread.start();
env.ThreadMap.put(listener.name, thread);
return {
    thread: thread
};
