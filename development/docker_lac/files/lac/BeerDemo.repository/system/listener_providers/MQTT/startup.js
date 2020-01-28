out.println("MQTT listener provider is now starting");
try {
    // Main classes
    env.MemoryPersistence = Java.type("org.eclipse.paho.client.mqttv3.persist.MemoryPersistence");
    env.MqttClient = Java.type("org.eclipse.paho.client.mqttv3.MqttClient");
    env.MqttConnectOptions = Java.type("org.eclipse.paho.client.mqttv3.MqttConnectOptions");
    env.MqttMessage = Java.type("org.eclipse.paho.client.mqttv3.MqttMessage");
    // Additional helpers from Java
    env.Properties = Java.type("java.util.Properties");
    /*
    * A function that checks if the connection is alive.
    * connectionObj - parameter is the connection JavaScript object returned by the
    * startConnection code.
    * returns true if the connection is still alive.
    */
    env.isConnectionAlive = function isConnectionAlive(connectionObj) {
        return connectionObj.mqttClient.isConnected();
    };
}
catch (e) {
    out.println("Paho library not present - the MQTT listeners will not be active.");
    provider.setIsActive(false);
}
