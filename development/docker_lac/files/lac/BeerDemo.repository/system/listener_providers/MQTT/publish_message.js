/*
 * In-scope variables are,
 * 1. connection - The Connection Object. (JavaScript Object). This is the connection
 *                  returned by start connection code for this provider.
 * 2. topic ( String )
 * 3. message - Payload Message . JavaScript Object
 * 4. Options . (JavaScript Object)
 */
var mqttClientObj = connection.mqttClient;
var mqttMessageObj = new env.MqttMessage();
var bytesMessage = SysUtility.getBytes(message);
mqttMessageObj.setPayload(bytesMessage);

// Resolve options
if (typeof options != 'undefined' && null !== options) {
    for (var key in options) {
        if (options.hasOwnProperty(key)) {
            if (key === 'qos') {
                var qos = options[key];
            }
            else if (key === 'retained') {
                var retained = options[key];
            }
            else {
                log.debug("Unrecognized option : "+key);
            }
      }
    }
}

// Publish message based on the options.
try {
    if (typeof qos != 'undefined' && typeof retained != 'undefined') {
        mqttClientObj.publish(topic,bytesMessage,qos,retained);
    }
    else {
        mqttClientObj.publish(topic,mqttMessageObj);
    }
}
catch(e) {
    log.error("Error during publishing message to topic:"+topic);
    log.error("Exception thrown : "+e);
    throw e;
}
