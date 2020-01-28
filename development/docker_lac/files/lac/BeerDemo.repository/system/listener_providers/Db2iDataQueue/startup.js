log.debug("Db2iDataQueue provider is now starting");
try {
    // Camel classes
    env.CamelContext = CamelContext;
    env.RouteBuilder = RouteBuilder;
    env.DefaultCamelContext = DefaultCamelContext;
    env.ProducerTemplate = ProducerTemplate;
    env.Processor = Java.type("org.apache.camel.Processor");
    env.Properties = Java.type("java.util.Properties");

    /*
     * A function that checks if the connection is alive.
     * connectionObj - parameter is the connection JavaScript object returned by the
     * startConnection code.
     * returns true if the connection is still alive.
     */
    env.isConnectionAlive = function isConnectionAlive(connectionObj) {
        //TODO Use ServiceStatus.
        var status = connectionObj.camelContext.getStatus();
        return status.isStarted();
    };
}
catch (e) {
    log.error("Db2iDataQueue - Camel library not present." + e);
    provider.setIsActive(false);
}
