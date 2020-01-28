connection.camelContext.stop();
connection.camelContext = null;
print("Stopped RabbitMQConsumer connection: " + connection.connectionName);
