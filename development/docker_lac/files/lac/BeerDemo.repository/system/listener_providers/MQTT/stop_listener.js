// Stop a listener
if(connection.mqttClient && connection.mqttClient.isConnected()){
   connection.mqttClient.unsubscribe(parameters.topic_name);
}else{
    log.warn("There is no connection for the client : "+connection.mqttClient.getClientId());
}
log.debug("Listener unsubscribed to topic :"+parameters.topic_name);
