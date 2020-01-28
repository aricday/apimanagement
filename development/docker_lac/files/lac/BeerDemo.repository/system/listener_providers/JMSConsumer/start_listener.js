print("Starting JMSConsumer listener: " + listener.name);
var camelContext = connection.camelContext;
var routeId = listener.name + '_' + new Date().getTime();
/*
* Form URL
*/
var jmsURI = providerUtil.formCamelURI(camelContext, "jms", parameters.destinationType + ":" + parameters.destinationName);

// Add a processor to assign an id
var messageProcessor = new env.Processor({
    process: function(exchange){
        var message = exchange.getIn();
        var hashString = message.getMessageId();
        exchange.setProperty("uniqueId",hashString);
        exchange.setProperty("clusterSyncOffset",5000);
    }
});

var routeBuilder = new env.RouteBuilder({
    configure: function() {
        var superClass = Java.super(routeBuilder);
        superClass.from(jmsURI)
            .routeId(routeId)
            .process(messageProcessor)
            .bean(messageHandler);
   }
});

try {
    camelContext.addRoutes(routeBuilder);
}
catch(e) {
    throw e;
}
print("Started JMSConsumer listener: " + listener.name);
return {
    "camelContext" : camelContext,
    // Useful for stopping listeners.
    "routeId" : routeId
};
