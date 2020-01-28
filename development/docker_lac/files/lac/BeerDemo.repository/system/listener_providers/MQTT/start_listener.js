print("Starting MQTT listener: " + listener.name);

var con = Java.type("com.kahuna.admin.entity.Connection").getByIdent(listener.project_ident, listener.connection_ident);
var topics = {};
for each (var listen in con.listeners) {
    if ( ! listen.isActive()) {
        continue;
    }
    for each (var listParam in listen.getParameters()) {
        if ('topic_name' === listParam.getName()) {
            if (topics[listParam.value]) {
                throw "You cannot have two active listeners for the same topic: " + listParam.value;
            }
            topics[listParam.value] = true;
        }
    }
}

// Parameter initilization
var topicName = parameters.topic_name;
var qos = 0;
if (parameters.quality_of_service) {
    qos = parameters.quality_of_service;
}

// Listener instantiation
var msgListener = new org.eclipse.paho.client.mqttv3.IMqttMessageListener({
    messageArrived: function(topicName, msg) {
        log.fine("Message has arrived at listener for topic: " + topicName);
        // Generate unique id of the message for clustered deployments.
        var msgId = providerUtil.generateHash(msg.getPayload());
        var executorPayload  = {
            topicName: topicName,
            message: msg,
            uniqueId: msgId,
            clusterSyncOffset: 5000
        };

        listener.executor.execute(executorPayload);
    }
});

// Check if the client is still connected
if(connection.mqttClient && !connection.mqttClient.isConnected()){
   log.error("Client with client id :" + connection.mqttClient.getClientId() + " is not connected!. Reconnecting...");
   connection.mqttClient.reconnect();
var clientId = (connection.mqttClient !== null)?connection.mqttClient.getClientId():null;
log.error("Client with client id :" + clientId + " has reconnected.");
}

// Listener subscription
log.debug("MQTT listener is about to subscribe to the topic : " + topicName);
connection.mqttClient.subscribe(topicName, qos, msgListener);
log.debug("MQTT listener is subscribed");
print("MQTT Listener is subscribed to the topic: " + topicName);

// Return
return {
    messageListener: msgListener
};
