/*
 * In-scope variables are,
 * 1. connection - The Connection Object. (JavaScript Object). This is the connection
 *                  returned by start connection code for this provider.
 * 2. topic ( String )
 * 3. message - Payload Message . JavaScript Object
 * 4. Options . (JavaScript Object)
 */

var jt400Component = connection.jt400Component;
var context = connection.camelContext;
var keyed = false;
// Resolve options
if (typeof options != 'undefined' && null !== options) {
    for (var key in options) {
        if (options.hasOwnProperty(key)) {
            if (key === 'key') {
                var keyValue = options[key];
                 keyed = true;
            }
            else {
                log.debug("Unrecognized option : " + key);
            }
         }
      }
    }

// Form URL
var jt400URI = "jt400://"+ connectionParameters.userID+":" + connectionParameters.password + "@" + connectionParameters.systemName+connectionParameters.objectPath+"."+connectionParameters.type + "?keyed=" + keyed;

endpoint = jt400Component.createEndpoint(jt400URI);
producer = endpoint.createProducer();
producer.start();
exchange = endpoint.createExchange();
var DefaultMessage =  Java.type("org.apache.camel.impl.DefaultMessage");

var defaultMsg = new DefaultMessage(context);

// Publish message based on the options.
try {
    if (typeof keyValue != 'undefined') {
        defaultMsg.setBody(message);
        defaultMsg.setHeader("KEY",keyValue);
    }
    else {
        defaultMsg.setBody(message);
    }

    exchange.setIn(defaultMsg);
    producer.process(exchange);
}
catch(e) {
    log.error("Exception thrown : "+e);
    throw e;
}
finally {
    producer.stop();
}
