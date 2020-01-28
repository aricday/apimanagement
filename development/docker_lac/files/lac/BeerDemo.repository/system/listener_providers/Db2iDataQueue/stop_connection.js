connection.camelContext.stop();
connection.camelContext = null;
log.debug("Stopped Db2iDataQueue connection: " + connection.connectionName);
