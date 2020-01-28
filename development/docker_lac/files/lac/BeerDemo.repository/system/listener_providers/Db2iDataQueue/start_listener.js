log.debug("Starting Db2iDataQueue listener: " + listener.name);
var camelContext = connection.camelContext;
var routeId = listener.name + '_' + new Date().getTime();

var keyed = "";
var searchType = "";
var searchKey = "";
if (parameters !== null) {
    if (parameters.keyed !== null && parameters.keyed) {
        keyed = true;
    }
    else {
        keyed = false;
    }

    if (parameters.searchType!==null && parameters.searchType) {
       searchType = parameters.searchType;
    }

    if (parameters.searchKey!==null && parameters.searchKey) {
       searchKey = parameters.searchKey;
    }
}

// Form URL
var jt400URI;
if (keyed) {
    jt400URI = ""
        + "jt400://" + connectionParameters.userID
        + ":" + connectionParameters.password
        + "@" + connectionParameters.systemName + connectionParameters.objectPath + "." + connectionParameters.type
        + "?keyed=" + keyed
        + "&searchKey=" + searchKey
        + "&searchType=" + searchType;
}
else {
    jt400URI = ""
        + "jt400://" + connectionParameters.userID
        + ":" + connectionParameters.password
        + "@" + connectionParameters.systemName + connectionParameters.objectPath + "." + connectionParameters.type
        + "?keyed=" + keyed;
}

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
        superClass.from(jt400URI)
            .routeId(routeId)
            .process(messageProcessor)
            .bean(messageHandler);
   }
});

try {
    camelContext.addRoutes(routeBuilder);
}
catch (e) {
    throw e;
}

log.debug("Started Db2iDataQueue Consumer listener: " + listener.name);
return {
    camelContext : camelContext,
    // Useful for stopping listeners.
    routeId : routeId
};
