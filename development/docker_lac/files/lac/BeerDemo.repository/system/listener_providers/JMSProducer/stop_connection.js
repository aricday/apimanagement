connection.camelContext.stop();
connection.camelContext = null;
print("Stopped JMSProducer connection: " + connection.connectionName);
