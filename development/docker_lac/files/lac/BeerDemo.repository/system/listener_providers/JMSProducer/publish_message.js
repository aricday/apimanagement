/*
 * In-scope variables are,
 * 1. connection - The Connection Object. (JavaScript Object). This is the connection
 *                  returned by start connection code for this provider.
 * 2. topic ( String )
 * 3. message - Payload Message . JavaScript Object
 * 4. Options . (JavaScript Object)
 */
var context = connection.camelContext;
var producer = context.createProducerTemplate();
var body = SysUtility.getBytes(message);

/*
 * Form URL
 */
var jmsURI = providerUtil.formCamelURI(context, "jms", connectionParameters.destinationType+":" + connectionParameters.destinationName);

// Resolve options
if (typeof options != 'undefined' && null !== options) {
    for (var key in options) {
        if (options.hasOwnProperty(key)) {
            if (key === 'headers') {
                var headerMap = options[key];
            }
            else {
                log.debug("Unrecognized option : "+key);
            }
      }
    }
}
producer.start();
// Publish message based on the options.
try {
    if (typeof headerMap != 'undefined' && !headerMap.isEmpty()) {
        producer.sendBodyAndHeaders(jmsURI,message,headerMap);
    }
    else {
        producer.sendBody(jmsURI,message);
    }
}
catch(e) {
    log.error("Exception thrown : "+e);
    throw e;
}
finally {
    producer.stop();
}
