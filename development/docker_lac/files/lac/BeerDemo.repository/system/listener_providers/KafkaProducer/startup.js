log.debug("KafkaProducer listener provider is now starting");
try {
   env.KafkaProducer = Java.type("org.apache.kafka.clients.producer.KafkaProducer");
   env.ProducerRecord = Java.type("org.apache.kafka.clients.producer.ProducerRecord");
    /*
    * A function that checks if the connection is alive.
    * connectionObj - parameter is the connection JavaScript object returned by the
    * startConnection code.
    * returns true if the connection is still alive.
    */
    env.isConnectionAlive = function isConnectionAlive(connectionObj) {
        return true;
    };
}
catch (e) {
    log.error("Kafka library not present - the Kafka listeners will not be active.");
    provider.setIsActive(false);
}
env.Properties = Java.type("java.util.Properties");
env.ArrayList = Java.type("java.util.ArrayList");
env.HashMap = Java.type("java.util.HashMap");
env.Thread = Java.type("java.lang.Thread");
