connection.camelContext.stop();
connection.camelContext = null;
print("Stopped JMSConsumer connection: " + connection.connectionName);
