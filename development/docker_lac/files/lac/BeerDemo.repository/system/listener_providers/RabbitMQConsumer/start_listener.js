print("Starting RabbitMQConsumer listener: " + listener.name);
var camelContext = connection.camelContext;
var routeId = listener.name + '_' + new Date().getTime();

/* Form URL */
var rabbitMQCamelURI = providerUtil.formCamelURI(camelContext, "rabbitmq",
    parameters.hostname +
    ":" + parameters.portNumber +
    "/" + parameters.exchangeName
    );

// Add a processor to assign an id
var messageProcessor = new env.Processor({
    process: function(exchange) {
        // Unique id is the Camel Message id.
        exchange.setProperty("uniqueId",exchange.getIn().getMessageId());
        exchange.setProperty("clusterSyncOffset", 5000);
    }
});

var routeBuilder = new env.RouteBuilder({
    configure: function() {
        var superClass = Java.super(routeBuilder);
        superClass.from(rabbitMQCamelURI)
            .routeId(routeId)
            .process(messageProcessor)
            .bean(messageHandler);
    }
});

try {
    camelContext.addRoutes(routeBuilder);
}
catch(e){
    throw e;
}
print("Started RabbitMQConsumer listener: " + listener.name);
return {
    "camelContext" : camelContext,
    // Useful for stopping listeners.
    "routeId" : routeId
}
